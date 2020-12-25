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
    hclk = 0;
    #`HCYCLE hreset_n = 0;
    #`HCYCLE hclk = 1;
    #`HCYCLE hreset_n = 1; hclk = 0;
    forever 
      #`HCYCLE hclk = ~hclk; 
  end 

  vmas_itf   mas[0:MasNum-1];  
  vslv_itf   slv[0:SlvNum-1];  

  AHB_bus bus
  (
    .master_1_in(mas[0].master_cb.mas_in),
    .hprior_master_1(mas[0].master_cb.prio),
    .master_1_out(mas[0].master_cb.mas_out),
    .master_2_in(mas[1].master_cb.mas_in),
    .hprior_master_2(mas[1].master_cb.prio),
    .master_2_out(mas[1].master_cb.mas_out),
    .master_3_in(mas[2].master_cb.mas_in),
    .hprior_master_3(mas[2].master_cb.prio),
    .master_3_out(mas[2].master_cb.mas_out),
    .kemee_in(mas[3].master_cb.mas_in),
    .hprior_kemee(mas[3].master_cb.prio),
    .kemee_out(mas[3].master_cb.mas_out),
//#MI
    .slave_1_in(slv[0].slave_cb.slv_in),
    .hsel_slave_1(slv[0].slave_cb.hsel),
    .slave_1_out(slv[0].slave_cb.slv_out),
    .slave_2_in(slv[1].slave_cb.slv_in),
    .hsel_slave_2(slv[1].slave_cb.hsel),
    .slave_2_out(slv[1].slave_cb.slv_out),
    .slave_3_in(slv[2].slave_cb.slv_in),
    .hsel_slave_3(slv[2].slave_cb.hsel),
    .slave_3_out(slv[2].slave_cb.slv_out),
    .slave_4_in(slv[3].slave_cb.slv_in),
    .hsel_slave_4(slv[3].slave_cb.hsel),
    .slave_4_out(slv[3].slave_cb.slv_out),
    .slave_5_in(slv[4].slave_cb.slv_in),
    .hsel_slave_5(slv[4].slave_cb.hsel),
    .slave_5_out(slv[4].slave_cb.slv_out),
    .slave_6_in(slv[5].slave_cb.slv_in),
    .hsel_slave_6(slv[5].slave_cb.hsel),
    .slave_6_out(slv[5].slave_cb.slv_out),
    .slave_7_in(slv[6].slave_cb.slv_in),
    .hsel_slave_7(slv[6].slave_cb.hsel),
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
    mas, slv, hreset_n, hclk
  );
 

endmodule: top
