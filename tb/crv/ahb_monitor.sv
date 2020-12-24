//////////////////////////////////////////////////////////////////////////////////
// File Name: 		ahb_monitor.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       2/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

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

  forever begin
    receive(s);
    foreach(cbsq[i])
      cbsq[i].post_rx(this, s);
  end   
  
endtask: run

//--------------------------------------------------------------------------------

task  Mas_monitor::receive(output Slave s);
   s = new();

   @(mas.master_cb.mas_in.hreadyout); 
     s.hresp <= mas.master_cb.mas_in.hresp;
     s.hrdata <= mas.master_cb.mas_in.hrdata; 

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

  forever begin
    receive(m);
    foreach(cbsq[i])
      cbsq[i].post_rx(this, m);
  end
endtask: run

//--------------------------------------------------------------------------------

task Slv_monitor::receive(output Master m);
  m = new();
  
  @(slv.slave_cb.slv_in.hsel); 
    m.initial_haddr <= slv.slave_cb.slv_in.haddr; 
    m.hwrite <= slv.slave_cb.slv_in.hwrite;
    m.hsize <= slv.slave_cb.slv_in.hsize;
    m.hburst <= slv.slave_cb.slv_in.hburst;
    m.hprot <= slv.slave_cb.slv_in.hprot;
    m.htrans <= slv.slave_cb.slv_in.htrans;
    m.hmastlock <= slv.slave_cb.slv_in.hmastlock;
    m.hwdata <= slv.slave_cb.slv_in.hwdata;

 m.display($sformatf("%t: Slave_Monitor %0d", $time, portID));

endtask: receive
