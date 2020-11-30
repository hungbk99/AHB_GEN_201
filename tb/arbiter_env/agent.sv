//////////////////////////////////////////////////////////////////////////////////
// File Name: 		requestor.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       09/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////


import arbiter_package::*;

class agent_np;
  generator_np gen;
  bit [SLAVE_0_MASTER_NUM-1:0] multi_req;
  bit [SLAVE_0_MASTER_NUM-1:0][SLAVE_0_PRIOR_BIT-1:0] multi_prior;

  bit [SLAVE_0_MASTER_NUM-1:0] golden_grant;

  function new(
    generator_np gen
  );
    this.gen = gen;
    this.multi_req = 0;
    this.multi_prior = 0;
    this.golden_grant = 0;
  endfunction: new

  extern function void gen_request;
endclass: agent_np

extern function void agent_np::gen_request;

endfunction: gen_request
