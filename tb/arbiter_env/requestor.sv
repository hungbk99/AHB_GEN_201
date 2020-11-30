//////////////////////////////////////////////////////////////////////////////////
// File Name: 		requestor.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       09/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

import arbiter_package::*;
class requestor;
  rand bit req;
  `ifdef DYNAMIC__PRIORITY_ARBITER
  rand bit [SLAVE_0_PRIOR_BIT-1:0] prior;  
  `endif  
  int ran_seed,
      prior_low,
      prior_high;
endclass
