//////////////////////////////////////////////////////////////////////////////////
// File Name: 		ahb_monitor.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       2/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

typedef class Ahb_mmonitor;
//--------------------------------------------------------------------------------
 
class Ahb_mmonitor_cbs;
  virtual task pre_tx( input Ahb_monitor mmon,
                       input Slave       s);
  endtask: pre_tx

  virtual task post_tx( input Ahb_monitor mmon,
                        input Slave      s);
  endtask: post_tx
endclass: Ahb_mmonitor_cbs

//--------------------------------------------------------------------------------
 
class Ahb_mmonitor;
  vmas_itf         mas;
  Ahb_mmonitor_cbs cbsq[$];
  int              portID;

  extern function new( input vmas_itf mas,
                       input int      portID);  

  extern task run();
  extern task receive(output Slave s);

endclass: Ahb_mmonitor

//--------------------------------------------------------------------------------

function Ahb_mmonitor::new(
                       input vmas_itf mas, 
                       input int      portID); 
  this.mas = mas;
  this.portID = portID;
endfunction

//--------------------------------------------------------------------------------

task Ahb_mmonitor::run();
  Slave s;

  forever begin
    receive(s);
    foreach(cbsq[i])
      cbsq[i].post_tx(this, s)
  end   
  
endtask: run

//--------------------------------------------------------------------------------

task  Ahb_mmonitor::receive(output Slave s)
   s = new();

   @(mas.master_cb.mas_in.hreadyout); 
     s.hresp <= mas.master_cb.mas_in.hresp;
     s.hrdata <= mas.master_cb.mas_in.hrdata; 

   s.display($sformatf("%t Master_Monitor %d", $time, portID)); 

endtask: receive

//--------------------------------------------------------------------------------

typedef class Ahb_smonitor;

class Ahb_smonitor_cbs;
  virtual task pre_rx( input Ahb_smonitor smon,
                       input Master       m);
  endtask: pre_rx

  virtual task post_rx( input Ahb_smonitor smon,
                        input Master       m);  
  endtask: post_rx

endclass: Ahb_smonitor_cbs

//--------------------------------------------------------------------------------

class Ahb_smonitor;
  vslv_itf         slv;
  Ahb_smonitor_cbs cbsq[$];
  int              portID;

  extern function new( input vslv_itf slv,
                       input int      portID);
 
  extern task run();
  exterm task receive(Master m);

endclass: Ahb_smonitor

//--------------------------------------------------------------------------------

function Ahb_smonitor::new(
                    input vslv_itf slv,
                    input int      portID);
  this.slv = slv; 
  this.portID = portID;
endfunction: new

//--------------------------------------------------------------------------------

task Ahb_smonitor::run();
  Master m;

  forever begin
    foreach(cbsq[i])
      cbsq[i].post_rx(this, m);
  end
endtask: run

//--------------------------------------------------------------------------------

task Ahb_smonitor::receive(Master m);
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
