//////////////////////////////////////////////////////////////////////////////////
// File Name: 		ahb_monitor.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       2/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

//`include "D:/Project/AMBA_BUS/AHB_GEN_201/tb/crv/ahb_cells.sv"
//`include "D:/Project/AMBA_BUS/AHB_GEN_201/tb/crv/config.sv"
//`include "D:/Project/AMBA_BUS/AHB_GEN_201/tb/crv/ahb_interface.sv"

typedef class Mas_monitor;
//--------------------------------------------------------------------------------
 
class Mas_monitor_cbs;
  virtual task pre_rx( input Mas_monitor mmon,
                       input Slave       s);
  endtask: pre_rx

  virtual task post_rx( input Mas_monitor mmon,
                        input Slave      s);
  endtask: post_rx
endclass: Mas_monitor_cbs

//--------------------------------------------------------------------------------
 
class Mas_monitor;
  vmas_itf         mas;
  Mas_monitor_cbs cbsq[$];
  int              portID;

  extern function new( input vmas_itf mas,
                       input int      portID);  

  extern task run();
  extern task receive(output Slave s);

endclass: Mas_monitor

//--------------------------------------------------------------------------------

function Mas_monitor::new(
                       input vmas_itf mas, 
                       input int      portID); 
  this.mas = mas;
  this.portID = portID;
endfunction

//--------------------------------------------------------------------------------

task Mas_monitor::run();
  Slave s;

  //Hung db 2_1_2020
  //s = new();
  
  forever begin
    receive(s);
    foreach(cbsq[i])
      cbsq[i].post_rx(this, s);
  end   
  
endtask: run

//--------------------------------------------------------------------------------

task  Mas_monitor::receive(output Slave s);
  //Hung db 2_1_2020
   s = new();

   @(mas.master_cb.mas_out.hreadyout);
   wait(mas.master_cb.mas_out.hreadyout);
     //s.hreadyout <= 1'b1; 
     //s.hresp <= mas.master_cb.mas_out.hresp;
     //s.hrdata <= mas.master_cb.mas_out.hrdata; 
     s.hreadyout = 1'b1; 
     s.hresp = mas.master_cb.mas_out.hresp;
     s.hrdata = mas.master_cb.mas_out.hrdata; 

   s.display($sformatf("%t Master_Monitor %d", $time, portID)); 

endtask: receive

//--------------------------------------------------------------------------------

typedef class Slv_monitor;

class Slv_monitor_cbs;
  virtual task pre_rx( input Slv_monitor smon,
                       input Master       m);
  endtask: pre_rx

  virtual task post_rx( input Slv_monitor smon,
                        input Master       m);  
  endtask: post_rx

endclass: Slv_monitor_cbs

//--------------------------------------------------------------------------------

class Slv_monitor;
  vslv_itf         slv;
  Slv_monitor_cbs  cbsq[$];
  int              portID;

  extern function new( input vslv_itf slv,
                       input int      portID);
 
  extern task run();
  extern task receive(output Master m);

endclass: Slv_monitor

//--------------------------------------------------------------------------------

function Slv_monitor::new(
                    input vslv_itf slv,
                    input int      portID);
  this.slv = slv; 
  this.portID = portID;
endfunction: new

//--------------------------------------------------------------------------------

task Slv_monitor::run();
  Master m;
  //Hung db 2_1_2020
  //m = new(32'h0, 32'hFFFF_FFFF);

  forever begin
    receive(m);
    foreach(cbsq[i])
      cbsq[i].post_rx(this, m);
  end
endtask: run

//--------------------------------------------------------------------------------

task Slv_monitor::receive(output Master m);
  //Hung db 2_1_2020
  m = new(32'h0, 32'hFFFF_FFFF);
  
  @(slv.slave_cb); 
  wait(slv.slave_cb.hsel); 
   //Hung 5_1_2020 m.initial_haddr <= slv.slave_cb.slv_out.haddr; 
   //Hung 5_1_2020 m.hwrite <= slv.slave_cb.slv_out.hwrite;
   //Hung 5_1_2020 m.hsize <= slv.slave_cb.slv_out.hsize;
   //Hung 5_1_2020 m.hburst <= slv.slave_cb.slv_out.hburst;
   //Hung 5_1_2020 m.hprot <= slv.slave_cb.slv_out.hprot;
   //Hung 5_1_2020 m.htrans <= slv.slave_cb.slv_out.htrans;
   //Hung 5_1_2020 m.hmastlock <= slv.slave_cb.slv_out.hmastlock;
   //Hung 5_1_2020 m.hwdata <= slv.slave_cb.slv_out.hwdata;

   m.initial_haddr = slv.slave_cb.slv_out.haddr; 
   m.hwrite = slv.slave_cb.slv_out.hwrite;
   m.hsize = slv.slave_cb.slv_out.hsize;
   m.hburst = slv.slave_cb.slv_out.hburst;
   m.hprot = slv.slave_cb.slv_out.hprot;
   m.htrans = slv.slave_cb.slv_out.htrans;
   m.hmastlock = slv.slave_cb.slv_out.hmastlock;
   m.hwdata = slv.slave_cb.slv_out.hwdata;
 m.display($sformatf("%t: Slave_Monitor %0d", $time, portID));

endtask: receive
