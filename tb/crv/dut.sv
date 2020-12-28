module dut
#(
  parameter MasNum = 4,
  parameter SlvNum = 8
)
(
  ahb_itf.mas_itf   mas[0:MasNum-1],
  ahb_itf.slv_itf   slv[0:SlvNum-1],
  input             hreset_n,
  input             hclk
);
  
  //`include"AHB_bus.sv"
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

endmodule: dut
