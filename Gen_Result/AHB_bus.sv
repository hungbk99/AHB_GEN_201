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
	output mas_send_type  master_1_out,
	input  [$clog2(2)-1:0]  master_1_prior,
	input  slv_send_type  master_1_in,
	output mas_send_type  master_2_out,
	input  [$clog2(2)-1:0]  master_2_prior,
	input  slv_send_type  master_2_in,
	output mas_send_type  master_3_out,
	input  [$clog2(2)-1:0]  master_3_prior,
	input  slv_send_type  master_3_in,
	output mas_send_type  kemee_out,
	input  [$clog2(2)-1:0]  kemee_prior,
	input  slv_send_type  kemee_in,
//#MI#
	output slv_send_type  slave_1_out,
	output hsel_slave_1,
	input  mas_send_type  slave_1_in,
	output slv_send_type  slave_2_out,
	output hsel_slave_2,
	input  mas_send_type  slave_2_in,
	output slv_send_type  slave_3_out,
	output hsel_slave_3,
	input  mas_send_type  slave_3_in,
	output slv_send_type  slave_4_out,
	output hsel_slave_4,
	input  mas_send_type  slave_4_in,
	output slv_send_type  slave_5_out,
	output hsel_slave_5,
	input  mas_send_type  slave_5_in,
	output slv_send_type  slave_6_out,
	output hsel_slave_6,
	input  mas_send_type  slave_6_in,
	output slv_send_type  slave_7_out,
	output hsel_slave_7,
	input  mas_send_type  slave_7_in,
	input					 hclk,
	input					 hreset_n
);

  parameter SI_PAYLOAD = 78;
  parameter MI_PAYLOAD = 34;
//================================================================================
//#SIGGEN# 
	logic [4-1:0][MI_PAYLOAD-1:0] payload_master_1_in;
	logic [MI_PAYLOAD-1:0] payload_master_1_out;
	logic default_slv_sel_master_1;
	logic [4-1:0] hreq_master_1;
	logic [3-1:0][MI_PAYLOAD-1:0] payload_master_2_in;
	logic [MI_PAYLOAD-1:0] payload_master_2_out;
	logic default_slv_sel_master_2;
	logic [3-1:0] hreq_master_2;
	logic [2-1:0][MI_PAYLOAD-1:0] payload_master_3_in;
	logic [MI_PAYLOAD-1:0] payload_master_3_out;
	logic default_slv_sel_master_3;
	logic [2-1:0] hreq_master_3;
	logic [7-1:0][MI_PAYLOAD-1:0] payload_kemee_in;
	logic [MI_PAYLOAD-1:0] payload_kemee_out;
	logic default_slv_sel_kemee;
	logic [7-1:0] hreq_kemee;

	logic [NO-1:0][SI_PAYLOAD-1:0] payload_slave_1_out;
	mas_send_type payload_slave_1_out;
	logic [NO-1:0] hgrant_slave_1;
	logic [YES-1:0][SI_PAYLOAD-1:0] payload_slave_2_out;
	mas_send_type payload_slave_2_out;
	logic [YES-1:0] hgrant_slave_2;
	logic [NO-1:0][SI_PAYLOAD-1:0] payload_slave_3_out;
	mas_send_type payload_slave_3_out;
	logic [NO-1:0] hgrant_slave_3;
	logic [NO-1:0][SI_PAYLOAD-1:0] payload_slave_4_out;
	mas_send_type payload_slave_4_out;
	logic [NO-1:0] hgrant_slave_4;
	logic [YES-1:0][SI_PAYLOAD-1:0] payload_slave_5_out;
	mas_send_type payload_slave_5_out;
	logic [YES-1:0] hgrant_slave_5;
	logic [YES-1:0][SI_PAYLOAD-1:0] payload_slave_6_out;
	mas_send_type payload_slave_6_out;
	logic [YES-1:0] hgrant_slave_6;
	logic [NO-1:0][SI_PAYLOAD-1:0] payload_slave_7_out;
	mas_send_type payload_slave_7_out;
	logic [NO-1:0] hgrant_slave_7;
//================================================================================
//#DECGEN# 
	AHB_decoder_master_1 DEC_master_1	(
		.haddr(master_1_in.haddr),
		.default_slv_sel(default_slv_sel_master_1),
		.hreq(hreq_master_1),
		.*
	);


	AHB_mux_master_1 MUX_master_1
	(
		.payload_in(payload_master_1_in),
		.payload_out(payload_master_1_out),
		.sel(hreq_master_1)
	);

	AHB_decoder_master_2 DEC_master_2	(
		.haddr(master_2_in.haddr),
		.default_slv_sel(default_slv_sel_master_2),
		.hreq(hreq_master_2),
		.*
	);


	AHB_mux_master_2 MUX_master_2
	(
		.payload_in(payload_master_2_in),
		.payload_out(payload_master_2_out),
		.sel(hreq_master_2)
	);

	AHB_decoder_master_3 DEC_master_3	(
		.haddr(master_3_in.haddr),
		.default_slv_sel(default_slv_sel_master_3),
		.hreq(hreq_master_3),
		.*
	);


	AHB_mux_master_3 MUX_master_3
	(
		.payload_in(payload_master_3_in),
		.payload_out(payload_master_3_out),
		.sel(hreq_master_3)
	);

	AHB_decoder_kemee DEC_kemee	(
		.haddr(kemee_in.haddr),
		.default_slv_sel(default_slv_sel_kemee),
		.hreq(hreq_kemee),
		.*
	);


	AHB_mux_kemee MUX_kemee
	(
		.payload_in(payload_kemee_in),
		.payload_out(payload_kemee_out),
		.sel(hreq_kemee)
	);

//================================================================================
//#ARBGEN#
	AHB_arbiter_slave_1 ARB_slave_1
	(
		.hreq(`{}),
		.hburst(payload_slave_1_out.hburst),
		.hwait(~slave_1_out.hreadyout),
		.hgrant(hgrant_slave_1),
		.hsel(hsel_slave_1),
		.hprior(),
		.*
	);


	AHB_arbiter_slave_2 ARB_slave_2
	(
		.hreq(`{}),
		.hburst(payload_slave_2_out.hburst),
		.hwait(~slave_2_out.hreadyout),
		.hgrant(hgrant_slave_2),
		.hsel(hsel_slave_2),
		.*
	);


	AHB_arbiter_slave_3 ARB_slave_3
	(
		.hreq(`{}),
		.hburst(payload_slave_3_out.hburst),
		.hwait(~slave_3_out.hreadyout),
		.hgrant(hgrant_slave_3),
		.hsel(hsel_slave_3),
		.*
	);


	AHB_arbiter_slave_4 ARB_slave_4
	(
		.hreq(`{}),
		.hburst(payload_slave_4_out.hburst),
		.hwait(~slave_4_out.hreadyout),
		.hgrant(hgrant_slave_4),
		.hsel(hsel_slave_4),
		.*
	);


	AHB_arbiter_slave_5 ARB_slave_5
	(
		.hreq(`{}),
		.hburst(payload_slave_5_out.hburst),
		.hwait(~slave_5_out.hreadyout),
		.hgrant(hgrant_slave_5),
		.hsel(hsel_slave_5),
		.*
	);


	AHB_arbiter_slave_6 ARB_slave_6
	(
		.hreq(`{}),
		.hburst(payload_slave_6_out.hburst),
		.hwait(~slave_6_out.hreadyout),
		.hgrant(hgrant_slave_6),
		.hsel(hsel_slave_6),
		.*
	);


	AHB_arbiter_slave_7 ARB_slave_7
	(
		.hreq(`{}),
		.hburst(payload_slave_7_out.hburst),
		.hwait(~slave_7_out.hreadyout),
		.hgrant(hgrant_slave_7),
		.hsel(hsel_slave_7),
		.hprior(),
		.*
	);



endmodule: AHB_bus
