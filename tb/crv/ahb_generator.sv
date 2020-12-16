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
  vmas_itf    mas;
  Ahb_mmonitor_cbs cbsq[$];
  int         portID;

  extern function new( input vmas_itf mas,
                       input int      portID);  

  extern task run();
  extern task receive ();

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
