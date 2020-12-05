//////////////////////////////////////////////////////////////////////////////////
// File Name: 		AHB_bus.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       2/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//#CONFIG_GEN#
//================================================================================

import AHB_package::*;
module AHB_bus
(
//#INTERFACEGEN#
//#SI#
	mas_send_type  master_1_in,
	mas_send_type  master_2_in,
	mas_send_type  master_3_in,
	mas_send_type  kemee_in,
//#MI#
	slv_send_type  slave_1_in,
	slv_send_type  slave_2_in,
	slv_send_type  slave_3_in,
	slv_send_type  slave_4_in,
	slv_send_type  slave_5_in,
	slv_send_type  slave_6_in,
	slv_send_type  slave_7_in,
	input					 hclk,
	input					 hreset_n
);

//================================================================================
//#SIGGEN# 
//================================================================================
//#DECGEN# 
//================================================================================
//#ARBGEN#

endmodule: AHB_bus
