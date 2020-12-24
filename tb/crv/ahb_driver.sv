//////////////////////////////////////////////////////////////////////////////////
// File Name: 		ahb_driver.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       2/10/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

//--------------------------------------------------------------------------------
typedef class  Mas_driver;

class Mas_driver_cbs;
  virtual task pre_tx(
    input Mas_driver drv,
    input Master m
  );
  endtask

  virtual task post_tx(
    input Mas_driver drv,
    input Master m
  );
  endtask

endclass: Mas_driver_cbs  

//--------------------------------------------------------------------------------

class Mas_driver;
  mailbox mas_gen2drv;
  event   mas_drv2gen;
  vmas_itf mas;
  Mas_driver_cbs cbsq[$]; //queue of callback objects
  int portID;

  extern function new(
    input mailbox mas_gen2drv,
    input event   mas_drv2gen,
    input vmas_itf mas,
    input int portID
  );

  extern task run();
  extern task send(input Master m);

endclass: Mas_driver

//--------------------------------------------------------------------------------

function Mas_driver::new(
    input mailbox  mas_gen2drv,
    input event    mas_drv2gen,
    input vmas_itf mas,
    input int portID
  );
    this.mas_gen2drv = mas_gen2drv;
    this.mas_drv2gen = mas_drv2gen;
    this.mas = mas;
    this.portID = portID;
endfunction: new

//--------------------------------------------------------------------------------

task Mas_driver::run();
  import ahb_package::*;
  Master m;

  //Initial 
  mas.master_cb.mas_out.haddr <= '0;
  mas.master_cb.mas_out.hwrite <= '0;
  mas.master_cb.mas_out.hsize <= WORD;
  mas.master_cb.mas_out.hburst <= SINGLE;
  mas.master_cb.mas_out.hprot <= '0;
  mas.master_cb.mas_out.htrans <= IDLE;
  mas.master_cb.mas_out.hmastlock <= '0;
  mas.master_cb.mas_out.hwdata <= '0;

  forever begin
    //Read from mailbox
    mas_gen2drv.peek(m);
    begin: mas_tx
      foreach(cbsq[i]) begin
        cbsq[i].pre_tx(this, m);
        //if(m.hmastlock) disable mas_tx;
      end
      
      m.display($sformatf("%t: %0d"), $time, portID);
      send(m);
  
      //foreach (cbsq[i]) 
      //  cbsq[i].post_tx(this, m);
    end

    mas_gen2drv.get(m);
    -> mas_drv2gen;
  end

endtask: run

//--------------------------------------------------------------------------------
// hwdata is portID: this help to do the check_actual in monitor
//--------------------------------------------------------------------------------

task Mas_driver::send(input Master m);
  import ahb_package::*;
  //Master package;
  Master fix;
  int num;
  bit [31:0] wrap_addr, limit_addr;
  $display("Master sendinggg.....");
  mas.master_cb.mas_out.haddr <= m.initial_haddr;
  //mas.master_cb.mas_out.hwdata <= m.hwdata;
  mas.master_cb.mas_out.hwdata <= portID;
  case(m.hburst)
    SINGLE, INCR: num = 1;
    WRAP4, INCR4:
    begin 
      num = 4;
      wrap_addr = m.initial_haddr & (32'hF << (m.hsize + 2));
      limit_addr = wrap_addr + 2**(m.hsize)*3; 
    end
    WRAP8, INCR8: 
    begin
      num = 8;
      wrap_addr = m.initial_haddr & (32'hF << (m.hsize + 3)); 
      limit_addr = wrap_addr + 2**(m.hsize)*7; 
    end
    WRAP16, INCR16:
    begin
      num = 16;
      wrap_addr = m.initial_haddr & (32'hF << (m.hsize + 4)); 
      limit_addr = wrap_addr + 2**(m.hsize)*15; 
    end
  endcase

  fix = new();
  fix = m;
  fix.hwdata = portID;
  for(int i = 0; i < num; i++)  
  begin
    if(i == 0) begin
      mas.master_cb.mas_out.htrans <= NONSEQ; 
    end
    else begin
      @(mas.master_cb.mas_in.hreadyout);
        mas.master_cb.mas_out.htrans <= SEQ; 
    end 

    if((m.hburst == WRAP4) || (m.hburst == WRAP8) || (m.hburst == WRAP16) && (mas.master_cb.mas_out.haddr == limit_addr))
      mas.master_cb.mas_out.haddr <= wrap_addr;
    else
        mas.master_cb.mas_out.haddr <= mas.master_cb.mas_out.haddr + 2**(m.hsize);
    
    //mas.master_cb.mas_out.hwdata <= mas.master_cb.mas_out.hwdata + 1;
    
    //put data in Mas_scoreboard
    foreach (cbsq[i]) begin
      cbsq[i].post_tx(this, fix);
    end
  end
 
endtask: send


//--------------------------------------------------------------------------------
typedef class Slv_driver;

class Slv_driver_cbs;
  virtual task pre_rx(
    input Slv_driver drv,
    input Slave      s 
  );
  endtask

  virtual task post_rx(
    input Slv_driver drv,
    input Slave      s
  );
  endtask

endclass: Slv_driver_cbs

//--------------------------------------------------------------------------------

class Slv_driver;
  mailbox         slv_gen2drv;
  event           slv_drv2gen;  
  vslv_itf         slv;
  Slv_driver_cbs  cbsq[$];
  int             portID;

  extern function new (
    input mailbox   slv_gen2drv,
    input event     slv_drv2gen,
    input vslv_itf  slv,
    input int       portID
  );

  extern task run;
  extern task send(input Slave s);
endclass: Slv_driver

//--------------------------------------------------------------------------------

function Slv_driver::new(
                input mailbox    slv_gen2drv,
                input event      slv_drv2gen,
                input vslv_itf   slv,
                input int        portID
                );
  this.slv_gen2drv = slv_gen2drv;
  this.slv_drv2gen = slv_drv2gen;
  this.slv         = slv;
  this.portID      = portID;
endfunction: new

//--------------------------------------------------------------------------------
task Slv_driver::run();
  Slave s;

  //Initial 
  slv.slave_cb.slv_out.hreadyout = 0;
  slv.slave_cb.slv_out.hresp = 0;
  slv.slave_cb.slv_out.hrdata = '0;

  forever begin
    //Read from mailbox
    slv_gen2drv.peek(s);
    //foreach(cbsq[i]) begin
    //  cbsq[i].pre_rx(this, s);
    //end

    s.display($sformatf("%t: %0d"), $time, portID);

    send(s);

    //foreach(cbsq[i]) begin
    //  cbsq[i].post_rx(this, s);
    //end

    slv_gen2drv.get(s); 
    ->slv_drv2gen;
  end  

endtask: run

//--------------------------------------------------------------------------------
// hrdata is portID: this help to do the check_actual in monitor
//--------------------------------------------------------------------------------

task Slv_driver::send(input Slave s);
  import ahb_package::*;
  //Slave package;
  int num;
  Slave fix;
  fix = new();

  case(m.hburst)
    SINGLE, INCR: num = 1;
    WRAP4, INCR4: num = 4;
    WRAP8, INCR8: num = 8;
    WRAP16, INCR16: num = 16;
  endcase
  slv.slave_cb.slv_out.hrdata = portID;
  fix.hrdata = portID;
  
  for(int i = 0; i < num; i++)
  begin
    @(slv.slave_cb.hsel)
    slv.slave_cb.slv_out.hreadyout <= 1;
    slv.slave_cb.slv_out.hresp <= 0;
    //slv.slave_cb.slv_out.hrdata = slv.slave_cb.slv_out.hrdata + 1;
    //Put data in Slv_scoreboard 
    fix.hreadyout <= 1;
    fix.hresp <= 1;
    foreach(cbsq[i]) begin
      cbsq[i].post_rx(this, fix);
    end
  end  

endtask: send 


















