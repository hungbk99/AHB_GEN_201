//////////////////////////////////////////////////////////////////////////////////
// File Name: 		ahb_interface.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       2/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

import AHB_package::*;
interface ahb_itf;
    
  mas_send_type    mas_out, slv_in;
  slv_send_type    mas_in, slv_out;  


  clocking master_cb @(posedge hclk);
    output mas_out;  
    input  mas_in; 
  endclocking: master

  clocking slave_cb @(posedge hclk);
    input  slv_in;   
    output slv_out;  
  endclocking: master
  
  modport mas_itf(clocking master_cb);
  modport slv_itf(clocking slave_cb);

endinterface: ahb_itf

typedef virtual ahb_itf vahb_itf;
typedef virtual ahb_itf.mas_itf vmas_itf;
typedef virtual ahb_itf.slv_itf vslv_itf;
