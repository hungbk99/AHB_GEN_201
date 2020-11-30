//////////////////////////////////////////////////////////////////////////////////
// File Name: 		transactor.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       09/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

import arbiter_package::*;
//class transactor;
//  rand bit req;
//  rand bit [SLAVE_0_PRIOR_BIT-1:0] prior;  
//  int seed,
//      prior_low,
//      prior_high;
//
//  constraint prior range {
//    prior inside {[prior_low:prior_high]}  
//  };
//
//  function new( 
//    int seed = 0,
//    int prior_low = 0,
//    int prior_high = 3
//  );
//
//    this.seed = seed;
//    this.prior_low = prior_low;
//    this.prior_high = prior_high;
//    
//    // set a new seed for this instance
//    this.srandom(seed);
//  endfunction: new
//
//endclass: transactor

class transactor_np;
  rand bit req;
  int seed;

  function new(
      int seed = 0
  );
    // set a new seed for this instance
    this.seed = srandom(seed)
  endfunction: new

endclass: transactor

class transactor_p extends transactor_np;
  rand bit [[SLAVE_0_PRIOR_BIT-1:0] prior; 
  int low_prior,
      high_prior;

  function new (
    int seed = 0,
    int high_prior = 3,
    int low_prior = 0
  );
    super.new(seed);
    this.low_prior = low_prior;
    this.high_prior = high_prior;
    this.seed = srandom(seed);  
  endfunction: new

endclass: transactor_p
