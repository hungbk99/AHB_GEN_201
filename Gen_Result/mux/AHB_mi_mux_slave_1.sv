//////////////////////////////////////////////////////////////////////////////////
// File Name: 		AHB_mux_slave_1.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       3/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//#CONFIG_GEN#
	`define CHNUM 3
	`define SLV
//================================================================================

import AHB_package::*;
module AHB_mux_slave_1
#(
    parameter CHANNEL_NUM = `CHNUM,
    `ifdef MAS
    parameter PAY_LOAD = 78 
    `elsif SLV
    parameter PAY_LOAD = 33 
    `endif
)
(
    input  [CHANNEL_NUM-1:0][PAY_LOAD-1:0] payload_in,
    input  [CHANNEL_NUM-1:0]               sel,                
    output [PAYLOAD-1:0]                   payload_out   
);
    
    always_comb begin
        payload_out = '0;
        for(int i = 0; i < CHANNEL_NUM; i++)
        begin
            if(sel == (1 << i))
                payload_out = payload_in[i];
        end
    end

endmodule: AHB_mux_slave_1
