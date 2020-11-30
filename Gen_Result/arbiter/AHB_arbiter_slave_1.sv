//////////////////////////////////////////////////////////////////////////////////
// File Name: 		AHB_arbiter_slave_1.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       2/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//#CONFIG_GEN#
	`define ONE_PATH
//================================================================================

import AHB_package::*;
//import AHB_arbiter_package::*;
module AHB_arbiter_slave_1 
#(
//#PARAGEN#
	parameter SLAVE_X_PRIOR_LEVEL = 3,
	parameter SLAVE_X_PRIOR_BIT = $clog2(SLAVE_X_PRIOR_LEVEL),
	parameter SLAVE_X_MASTER_NUM = 3
)  
(
  input   [SLAVE_X_MASTER_NUM-1:0]                      hreq,
                                                        hlast,
  input                                                 hwait,
  output  logic [SLAVE_X_MASTER_NUM-1:0]                hgrant,
  output  logic                                         hsel,
`ifdef  DYNAMIC__PRIORITY_ARBITER
  input [SLAVE_X_MASTER_NUM-1:0][SLAVE_X_PRIOR_BIT-1:0] hprior,   
`endif
  input                                                 hclk,
                                                        hreset_n
);
  
  logic [SLAVE_X_MASTER_NUM-1:0] raw_grant;
  logic [SLAVE_X_MASTER_NUM-1:0] grant;

`ifdef  FIXED_PRIORITY_ARBITER   

  Fixed_Prior_Mask 
  #(
    .REQ_NUM(SLAVE_X_MASTER_NUM)
  )
  FPA
  (
    .hlast(hlast),
    .collect_req(hreq),
    .hsel(hsel),  
    .raw_grant(raw_grant)
  );
  
`elsif  DYNAMIC__PRIORITY_ARBITER
  `define PRIOR_GEN
  
  Fixed_Prior_Mask  
  #(
    .REQ_NUM(SLAVE_X_MASTER_NUM)
  )
  FPM
  (
    .hlast(hlast),
    .collect_req(collect_req),
    .hsel(hsel),  
    .raw_grant(raw_grant)
  );
`elsif  ROUND_ROBIN_ARBITER
  `define PRIOR_GEN
  logic [SLAVE_X_MASTER_NUM-1:0][SLAVE_X_PRIOR_BIT-1:0] prior_reg,
                                                        prior_cout,
                                                        hprior;
  logic [SLAVE_X_PRIOR_BIT-1:0] current_prior;
  logic update,
        current_hlast;

  always_ff @(posedge hclk, negedge hreset_n)
  begin
    for(int i = 0; i < SLAVE_X_MASTER_NUM; i++)
    begin
      if(!hreset_n)
        prior_reg[i] <= i;
      else if(update)                                      // Update the reg table at the last transfer of the current  
        prior_reg[i] <= prior_cout[i];                     // transaction if there are no wait request from slave
    end
  end
  
  assign update = hsel & ~hwait & current_hlast;

  // One-hot Mux
  always_comb begin
     current_prior = '0;
     current_hlast = 1'b0;
     prior_cout = prior_reg;
     for(int i = 0; i < SLAVE_X_MASTER_NUM; i++)
     begin
      if(grant == (1 << i))   
      begin
        current_prior = hprior[i];
        current_hlast = hlast[i];
        prior_cout[i] = '0;
      end
      else if (prior_reg[i] < current_prior)
        prior_cout[i] = prior_reg[i] + 1;
     end
  end

  assign hprior = prior_reg;
  
  BR_Req_Detect  
  #(
    .REQ_NUM(SLAVE_X_MASTER_NUM)
  )
  BRRD
  (
    .hlast(hlast),
    .collect_req(collect_req),
    .hsel(hsel),  
    .raw_grant(raw_grant)
  );
`endif

`ifdef  PRIOR_GEN
  logic [SLAVE_X_MASTER_NUM-1:0][SLAVE_X_PRIOR_LEVEL-1:0] gen_req;    
  logic [SLAVE_X_MASTER_NUM-1:0][SLAVE_X_PRIOR_LEVEL-1:0]  mask_req;
  logic [SLAVE_X_MASTER_NUM-1:0]  collect_req;
//                                  raw_grant,
//                                  grant; 
 
  genvar i;
  generate
    for(i = 0; i < SLAVE_X_MASTER_NUM; i++)
    begin: PG_gen
      Prior_Gen 
      #(
        .PRIOR_BIT(SLAVE_X_PRIOR_BIT),
        .PRIOR_LEVEL(SLAVE_X_PRIOR_LEVEL)
      )
      PG
      (
        .hreq(hreq[i]),
        .hprior(hprior[i]),
        .hsel(hsel),
        .grant(grant[i]),
        .gen_req(gen_req[i])
      );
    end
  endgenerate

  Dynamic_Prior_Mask  
  #(
    .PRIOR_LEVEL(SLAVE_X_PRIOR_LEVEL),
    .REQ_NUM(SLAVE_X_MASTER_NUM)
  )
  DPM
  (
    .gen_req(gen_req),
    .mask_req(mask_req)
  );

  Req_Collect 
  #(
    .PRIOR_LEVEL(SLAVE_X_PRIOR_LEVEL),
    .REQ_NUM(SLAVE_X_MASTER_NUM)
  )
  RC
  (
    .mask_req(mask_req),
    .collect_req(collect_req)    
  );
  
`endif
  
//  always_ff @(posedge hclk, negedge hreset_n)
//  begin
//    if(!hreset_n)
//      hgrant <= '0;
//    else 
//      hgrant <= mask_grant;
//  end
//  assign hsel = |hgrant;

`ifdef ONE_PATH
  assign raw_grant = hreq;  
`endif  
  always_ff @(posedge hclk, negedge hreset_n)
  begin
    if(!hreset_n)
      grant <= '0;
    else 
      grant <= raw_grant; 
  end

  assign hgrant = grant & ~hwait;  
  assign hsel = hwait & |grant; 

endmodule: AHB_arbiter_slave_1

