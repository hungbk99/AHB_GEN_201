/*********************************************************************************
 * File Name: 		ahb_top.sv
 * Project Name:	AHB_Gen
 * Email:         quanghungbk1999@gmail.com
 * Version    Date      Author      Description
 * v0.0       2/10/2020 Quang Hung  First Creation
 *********************************************************************************/

//--------------------------------------------------------------------------------

`define MasPort 4
`define SlvPort 7
`define HCYCLE 5

module top;
  
  parameter int MasNum = `MasPort;
  parameter int SlvNum = `SlvPort;

  logic hreset_n, hclk;

  initial begin
    hreset_n = 1;
    clk = 0;
    #`HCYCLE hreset_n = 0;
    #`HCYCLE hclk = 1;
    #`HCYCLE hreset_n = 1; hclk = 0;
    forever 
      #`HCYCLE hclk = ~hclk; 
  end 

  master_cb.mas_itf     mas[0:MasNum-1];
  prior_itf   prio[0:MasNum-1];  
  slave_cb.slv_itf     slv[0:SlvNum-1];

  AHB_bus bus
  (
    .master_1_in(mas[0].master_cb.mas_in),
    .hprior_master_1(prio[0]),
    .master_1_out(mas[0].master_cb.mas_out),
    .master_2_in(mas[1].master_cb.mas_in),
    .hprior_master_2(prio[1]),
    .master_2_out(mas[1].master_cb.mas_out),
    .master_3_in(mas[2].master_cb.mas_in),
    .hprior_master_3(prio[2]),
    .master_3_out(mas[2].master_cb.mas_out),
    .kemee_in(mas[3].master_cb.mas_in),
    .hprior_kemee(prio[3]),
    .kemee_out(mas[3].master_cb.mas_out),
//#MI
    .slave_1_in(slv[0].slave_cb.slv_in),
    .slave_1_out(slv[0].slave_cb.slv_out),
    .slave_2_in(slv[1].slave_cb.slv_in),
    .slave_2_out(slv[1].slave_cb.slv_out),
    .slave_3_in(slv[2].slave_cb.slv_in),
    .slave_3_out(slv[2].slave_cb.slv_out),
    .slave_4_in(slv[3].slave_cb.slv_in),
    .slave_4_out(slv[3].slave_cb.slv_out),
    .slave_5_in(slv[4].slave_cb.slv_in),
    .slave_5_out(slv[4].slave_cb.slv_out),
    .slave_6_in(slv[5].slave_cb.slv_in),
    .slave_6_out(slv[5].slave_cb.slv_out),
    .slave_7_in(slv[6].slave_cb.slv_in),
    .slave_7_out(slv[6].slave_cb.slv_out),
    .*
  );

  ahb_test
  #(
    .MASNUM(MasNum),
    .SLVNUM(SlvNum)
  )
  test
  (
    mas, prio, slv, hreset_n, hclk
  );
 

endmodule: top
