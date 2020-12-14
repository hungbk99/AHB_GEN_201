/*********************************************************************************
 * File Name: 		ahb_test.sv
 * Project Name:	AHB_Gen
 * Email:         quanghungbk1999@gmail.com
 * Version    Date      Author      Description
 * v0.0       2/10/2020 Quang Hung  First Creation
 *********************************************************************************/

//--------------------------------------------------------------------------------

program automatic ahb_test
#(
  parameter MASNUM = 4,
  parameter SLVNUM = 8
)
(
  master_cb.mas_itf     mas[0:MasNum-1],
  prior_itf             prio[0:MasNum-1]  
  slave_cb.slv_itf      slv[0:SlvNum-1],
  input                 hreset_n,
                        hclk
);

  initial begin
    $display("********************************************************************");
    $display("    Simulation was run with:............");
    $display("    MasPort := %0d", MASNUM);
    $display("    SlvPort := %0d", SLVNUM);
    $display("********************************************************************");
  end
  
  Ahb_environment env;

  initial begin
    env (mas, prio, slv, MASNUM, SLVNUM);
    env.gen_cfg();
    env.build();
    env.run();
    env.wrap_up();
  end

endprogram: ahb_test

