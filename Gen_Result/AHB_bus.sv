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

  parameter SI_PAYLOAD = 78;
  parameter MI_PAYLOAD = 34;
//================================================================================
//#SIGGEN# 
	logic [4-1:0][MI_PAYLOAD-1:0] payload_master_1_in;
	logic [MI_PAYLOAD-1:0] payload_master_1_out;
	logic [3-1:0][MI_PAYLOAD-1:0] payload_master_2_in;
	logic [MI_PAYLOAD-1:0] payload_master_2_out;
	logic [2-1:0][MI_PAYLOAD-1:0] payload_master_3_in;
	logic [MI_PAYLOAD-1:0] payload_master_3_out;
	logic [7-1:0][MI_PAYLOAD-1:0] payload_kemee_in;
	logic [MI_PAYLOAD-1:0] payload_kemee_out;
	logic [NO-1:0][SI_PAYLOAD-1:0] payload_slave_1_out;
	logic [SI_PAYLOAD-1:0] payload_slave_1_out;
	logic [NO-1:0][SI_PAYLOAD-1:0] payload_slave_2_out;
	logic [SI_PAYLOAD-1:0] payload_slave_2_out;
	logic [YES-1:0][SI_PAYLOAD-1:0] payload_slave_3_out;
	logic [SI_PAYLOAD-1:0] payload_slave_3_out;
	logic [YES-1:0][SI_PAYLOAD-1:0] payload_slave_4_out;
	logic [SI_PAYLOAD-1:0] payload_slave_4_out;
	logic [NO-1:0][SI_PAYLOAD-1:0] payload_slave_5_out;
	logic [SI_PAYLOAD-1:0] payload_slave_5_out;
	logic [NO-1:0][SI_PAYLOAD-1:0] payload_slave_6_out;
	logic [SI_PAYLOAD-1:0] payload_slave_6_out;
	logic [NO-1:0][SI_PAYLOAD-1:0] payload_slave_7_out;
	logic [SI_PAYLOAD-1:0] payload_slave_7_out;
//================================================================================
//#DECGEN# 
	AHB_decoder_master_1 DEC_master_1	(
		.haddr(haddr_master_1),
		.htrans(htrans_master_1),
		.hremap(hremap_master_1),
		.hsplit(hsplit_master_1),
		.default_slv_sel(default_slv_sel_master_1),
		.hreq(hreq_master_1),
		.*
	);


	AHB_mux_master_1 MUX_master_1
	(
		.payload_in(payload_master_1_in),
		.payload_out(payload_master_1_out),
		.sel(sel_master_1)
	);
	AHB_decoder_master_2 DEC_master_2	(
		.haddr(haddr_master_2),
		.htrans(htrans_master_2),
		.hremap(hremap_master_2),
		.hsplit(hsplit_master_2),
		.default_slv_sel(default_slv_sel_master_2),
		.hreq(hreq_master_2),
		.*
	);


	AHB_mux_master_2 MUX_master_2
	(
		.payload_in(payload_master_2_in),
		.payload_out(payload_master_2_out),
		.sel(sel_master_2)
	);
	AHB_decoder_master_3 DEC_master_3	(
		.haddr(haddr_master_3),
		.htrans(htrans_master_3),
		.hremap(hremap_master_3),
		.hsplit(hsplit_master_3),
		.default_slv_sel(default_slv_sel_master_3),
		.hreq(hreq_master_3),
		.*
	);


	AHB_mux_master_3 MUX_master_3
	(
		.payload_in(payload_master_3_in),
		.payload_out(payload_master_3_out),
		.sel(sel_master_3)
	);
	AHB_decoder_kemee DEC_kemee	(
		.haddr(haddr_kemee),
		.htrans(htrans_kemee),
		.hremap(hremap_kemee),
		.hsplit(hsplit_kemee),
		.default_slv_sel(default_slv_sel_kemee),
		.hreq(hreq_kemee),
		.*
	);


	AHB_mux_kemee MUX_kemee
	(
		.payload_in(payload_kemee_in),
		.payload_out(payload_kemee_out),
		.sel(sel_kemee)
	);
//================================================================================
//#ARBGEN#
	AHB_arbiter_slave_1 ARB_slave_1
	AHB_arbiter_slave_2 ARB_slave_2
	AHB_arbiter_slave_3 ARB_slave_3
	AHB_arbiter_slave_4 ARB_slave_4
	AHB_arbiter_slave_5 ARB_slave_5
	AHB_arbiter_slave_6 ARB_slave_6
	AHB_arbiter_slave_7 ARB_slave_7

endmodule: AHB_bus
