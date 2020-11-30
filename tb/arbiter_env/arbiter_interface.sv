//////////////////////////////////////////////////////////////////////////////////
// File Name: 		requestor.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       09/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

import arbiter_package::*;
interface arb_if 
(
  logic bit clk
);

  logic   [SLAVE_0_MASTER_NUM-1:0]                      hreq,
                                                        hlast;
  logic                                                 hwait;
  logic [SLAVE_0_MASTER_NUM-1:0]                        hgrant;
  logic                                                 hsel;
`ifdef  DYNAMIC__PRIORITY_ARBITER
  logic [SLAVE_0_MASTER_NUM-1:0][SLAVE_0_PRIOR_BIT-1:0] hprior;   
`endif
  logic                                                 hclk,
                                                        hreset_n;

endinterface
