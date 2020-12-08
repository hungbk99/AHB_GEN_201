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
	input  mas_send_type  master_1_in,
	input  [$clog2(2)-1:0]  master_1_prior,
	output  slv_send_type  master_1_out,
	input  mas_send_type  master_2_in,
	input  [$clog2(2)-1:0]  master_2_prior,
	output  slv_send_type  master_2_out,
	input  mas_send_type  master_3_in,
	input  [$clog2(2)-1:0]  master_3_prior,
	output  slv_send_type  master_3_out,
	input  mas_send_type  kemee_in,
	input  [$clog2(2)-1:0]  kemee_prior,
	output  slv_send_type  kemee_out,
//#MI#
	input  slv_send_type  slave_1_in,
	output hsel_slave_1,
	output mas_send_type  slave_1_out,
	input  slv_send_type  slave_2_in,
	output hsel_slave_2,
	output mas_send_type  slave_2_out,
	input  slv_send_type  slave_3_in,
	output hsel_slave_3,
	output mas_send_type  slave_3_out,
	input  slv_send_type  slave_4_in,
	output hsel_slave_4,
	output mas_send_type  slave_4_out,
	input  slv_send_type  slave_5_in,
	output hsel_slave_5,
	output mas_send_type  slave_5_out,
	input  slv_send_type  slave_6_in,
	output hsel_slave_6,
	output mas_send_type  slave_6_out,
	input  slv_send_type  slave_7_in,
	output hsel_slave_7,
	output mas_send_type  slave_7_out,
	input					 hclk,
	input					 hreset_n
);

  parameter SI_PAYLOAD = 78;
  parameter MI_PAYLOAD = 34;
//================================================================================
//#SIGGEN# 
	logic [NO-1:0][MI_PAYLOAD-1:0] payload_master_1_in;
	slv_send_type payload_master_1_out;
	logic default_slv_sel_master_1;
	logic [NO-1:0] hreq_master_1;
	logic [3-1:0][MI_PAYLOAD-1:0] payload_master_2_in;
	slv_send_type payload_master_2_out;
	logic default_slv_sel_master_2;
	logic [3-1:0] hreq_master_2;
	logic [2-1:0][MI_PAYLOAD-1:0] payload_master_3_in;
	slv_send_type payload_master_3_out;
	logic default_slv_sel_master_3;
	logic [2-1:0] hreq_master_3;
	logic [7-1:0][MI_PAYLOAD-1:0] payload_kemee_in;
	slv_send_type payload_kemee_out;
	logic default_slv_sel_kemee;
	logic [7-1:0] hreq_kemee;

	logic [3-1:0] hreq_slave_1
	logic [3-1:0][SI_PAYLOAD-1:0] payload_slave_1_in;
	mas_send_type payload_slave_1_out;
	logic [3-1:0] hgrant_slave_1;
	logic [2-1:0] hreq_slave_2
	logic [2-1:0][SI_PAYLOAD-1:0] payload_slave_2_in;
	mas_send_type payload_slave_2_out;
	logic [2-1:0] hgrant_slave_2;
	logic [2-1:0] hreq_slave_3
	logic [2-1:0][SI_PAYLOAD-1:0] payload_slave_3_in;
	mas_send_type payload_slave_3_out;
	logic [2-1:0] hgrant_slave_3;
	logic [1-1:0] hreq_slave_4
	logic [1-1:0][SI_PAYLOAD-1:0] payload_slave_4_in;
	mas_send_type payload_slave_4_out;
	logic [1-1:0] hgrant_slave_4;
	logic [4-1:0] hreq_slave_5
	logic [4-1:0][SI_PAYLOAD-1:0] payload_slave_5_in;
	mas_send_type payload_slave_5_out;
	logic [4-1:0] hgrant_slave_5;
	logic [1-1:0] hreq_slave_6
	logic [1-1:0][SI_PAYLOAD-1:0] payload_slave_6_in;
	mas_send_type payload_slave_6_out;
	logic [1-1:0] hgrant_slave_6;
	logic [2-1:0] hreq_slave_7
	logic [2-1:0][SI_PAYLOAD-1:0] payload_slave_7_in;
	mas_send_type payload_slave_7_out;
	logic [2-1:0] hgrant_slave_7;
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
		.hreq(hreq_slave_1),
		.hburst(payload_slave_1_out.hburst),
		.hwait(~slave_1_out.hreadyout),
		.hgrant(hgrant_slave_1),
		.hsel(hsel_slave_1),
		.*
	);


	AHB_arbiter_slave_2 ARB_slave_2
	(
		.hreq(hreq_slave_2),
		.hburst(payload_slave_2_out.hburst),
		.hwait(~slave_2_out.hreadyout),
		.hgrant(hgrant_slave_2),
		.hsel(hsel_slave_2),
		.hprior(),
		.*
	);


	AHB_arbiter_slave_3 ARB_slave_3
	(
		.hreq(hreq_slave_3),
		.hburst(payload_slave_3_out.hburst),
		.hwait(~slave_3_out.hreadyout),
		.hgrant(hgrant_slave_3),
		.hsel(hsel_slave_3),
		.*
	);


	AHB_arbiter_slave_4 ARB_slave_4
	(
		.hreq(hreq_slave_4),
		.hburst(payload_slave_4_out.hburst),
		.hwait(~slave_4_out.hreadyout),
		.hgrant(hgrant_slave_4),
		.hsel(hsel_slave_4),
		.*
	);


	AHB_arbiter_slave_5 ARB_slave_5
	(
		.hreq(hreq_slave_5),
		.hburst(payload_slave_5_out.hburst),
		.hwait(~slave_5_out.hreadyout),
		.hgrant(hgrant_slave_5),
		.hsel(hsel_slave_5),
		.hprior(),
		.*
	);


	AHB_arbiter_slave_6 ARB_slave_6
	(
		.hreq(hreq_slave_6),
		.hburst(payload_slave_6_out.hburst),
		.hwait(~slave_6_out.hreadyout),
		.hgrant(hgrant_slave_6),
		.hsel(hsel_slave_6),
		.*
	);


	AHB_arbiter_slave_7 ARB_slave_7
	(
		.hreq(hreq_slave_7),
		.hburst(payload_slave_7_out.hburst),
		.hwait(~slave_7_out.hreadyout),
		.hgrant(hgrant_slave_7),
		.hsel(hsel_slave_7),
		.*
	);


//================================================================================
//#CROSSGEN#

	assign hreq_slave_1 = `{ hreq_master_1[3], hreq_master_2[2], hreq_kemee[6]};
	assign payload_slave_1_in[2] = master_1_in;
	assign payload_slave_1_in[1] = master_2_in;
	assign payload_slave_1_in[0] = kemee_in;

	assign hreq_slave_2 = `{ hreq_master_1[2], hreq_kemee[5]};
	assign payload_slave_2_in[1] = master_1_in;
	assign payload_slave_2_in[0] = kemee_in;

	assign hreq_slave_3 = `{ hreq_master_2[1], hreq_kemee[4]};
	assign payload_slave_3_in[1] = master_2_in;
	assign payload_slave_3_in[0] = kemee_in;

	assign hreq_slave_4 = `{ hreq_master_3[1] hreq_kemee[3],};
	assign payload_slave_4_in[0] = master_3_in;
	assign payload_slave_4_in[-1] = kemee_in;

	assign hreq_slave_5 = `{ hreq_master_1[1], hreq_master_2[0], hreq_master_3[0], hreq_kemee[2]};
	assign payload_slave_5_in[3] = master_1_in;
	assign payload_slave_5_in[2] = master_2_in;
	assign payload_slave_5_in[1] = master_3_in;
	assign payload_slave_5_in[0] = kemee_in;

	assign hreq_slave_6 = `{ hreq_kemee[1]};
	assign payload_slave_6_in[0] = kemee_in;

	assign hreq_slave_7 = `{ hreq_master_1[0], hreq_kemee[0]};
	assign payload_slave_7_in[1] = master_1_in;
	assign payload_slave_7_in[0] = kemee_in;

	assign payload_master_2_in[2] = {slave_1_in.hreadyout & hgrant_slave_1, slave_1_in.hrdata, slave_1_in.hresp};
	assign payload_master_2_in[1] = {slave_3_in.hreadyout & hgrant_slave_3, slave_3_in.hrdata, slave_3_in.hresp};
	assign payload_master_2_in[0] = {slave_5_in.hreadyout & hgrant_slave_5, slave_5_in.hrdata, slave_5_in.hresp};
	assign payload_master_2_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_2_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_2_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_2_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_2_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_2_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_2_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_2_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_2_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_3_in[1] = {slave_4_in.hreadyout & hgrant_slave_4, slave_4_in.hrdata, slave_4_in.hresp};
	assign payload_master_3_in[0] = {slave_5_in.hreadyout & hgrant_slave_5, slave_5_in.hrdata, slave_5_in.hresp};
	assign payload_master_3_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_3_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_3_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_3_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_3_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_3_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_3_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_3_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_3_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_master_3_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[6] = {slave_1_in.hreadyout & hgrant_slave_1, slave_1_in.hrdata, slave_1_in.hresp};
	assign payload_kemee_in[5] = {slave_2_in.hreadyout & hgrant_slave_2, slave_2_in.hrdata, slave_2_in.hresp};
	assign payload_kemee_in[4] = {slave_3_in.hreadyout & hgrant_slave_3, slave_3_in.hrdata, slave_3_in.hresp};
	assign payload_kemee_in[3] = {slave_4_in.hreadyout & hgrant_slave_4, slave_4_in.hrdata, slave_4_in.hresp};
	assign payload_kemee_in[2] = {slave_5_in.hreadyout & hgrant_slave_5, slave_5_in.hrdata, slave_5_in.hresp};
	assign payload_kemee_in[1] = {slave_6_in.hreadyout & hgrant_slave_6, slave_6_in.hrdata, slave_6_in.hresp};
	assign payload_kemee_in[0] = {slave_7_in.hreadyout & hgrant_slave_7, slave_7_in.hrdata, slave_7_in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};
	assign payload_kemee_in[] = {_in.hreadyout & hgrant_, _in.hrdata, _in.hresp};

endmodule: AHB_bus
