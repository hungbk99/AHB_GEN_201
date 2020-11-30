//////////////////////////////////////////////////////////////////////////////////
// File Name: 		generator.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       09/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

import arbiter_package::*;
//class generator;
//  transactor req; 
//  
//  function new(
//    transactor req
//  );
//    this.req = req;
//  endfunction: new
//
//  extern function void generate_transactor;
//  
//  extern function bit get_request;
//
//  extern function bit get_prior;
//
//endclass: generator

class generator_np;
  transactor_np req;

  function new(
    transactor req
  );
    this.req = req;
  endfunction: new  

  extern function void gen_np_requestor;

  extern function bit get_np_request;

endclass: generator_np

function void generator_np::gen_np_requestor;
  if(req.randomize() == 1)
  begin
    $display ("RANDOM REQUEST GENERATED \n");
    $display ("Time = %t || req = %b || prior_level = %h \n", $time, req.req, req, req.prior);
  else
    $display ("RANDOM REQUEST FAILED \n");
  end
endfunction: gen_np_requestor  

function bit generator_np::get_np_request;
  return req.req;
endfunction: get_np_request

class generator_p;
  transactor_p req; 
  
  function new(
    transactor_p req
  );
    this.req = req;
  endfunction: new

  extern function void gen_p_requestor;

  extern function bit get_p_request;

  extern function bit [SLAVE_0_PRIOR_BIT-1:0] get_p_prior;

endclass: generator_p

function void generator_p::gen_p_requestor;
  if(req.randomize() == 1)
  begin
    $display ("RANDOM REQUEST GENERATED \n");
    $display ("Time = %t || req = %b || prior_level = %h \n", $time, req.req, req, req.prior);
  else
    $display ("RANDOM REQUEST FAILED \n");
  end
endfunction: gen_p_requestor  

function bit generator_p::get_p_request;
  return req.req;
endfunction: get_p_request

function bit [SLAVE_0_PRIOR_BIT-1:0] generator_p::get_p_prior;
  return req.prior
endfunction: get_p_prior

