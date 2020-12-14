/*********************************************************************************
 * File Name: 		ahb_env.sv
 * Project Name:	AHB_Gen
 * Email:         quanghungbk1999@gmail.com
 * Version    Date      Author      Description
 * v0.0       2/10/2020 Quang Hung  First Creation
 *********************************************************************************/

//================================================================================
// Call Scoreboard from Master Driver
//================================================================================
class Scb_mdriver_cbs extends Ahb_mdriver_cbs;
  Ahb_mscoreboard scb;

  function new(Ahb_mscoreboard scb);
    this.scb = scb;
  endfunction: new

  virtual task post_tx(
                input Ahb_mdriver drv,
                input Slv_cell    s
                );
    scb.save_expected(s);
  endtask: post_tx

endclass: Scb_mdriver_cbs

//================================================================================
// Call Scoreboard from Slave Driver
//================================================================================
class Scb_sdriver_cbs extends Ahb_sdriver_cbs;
  Ahb_sscoreboard scb;

  function new(Ahb_sscoreboard scb);
    this.scb = scb;
  endfunction: new

  virtual task post_tx(
                input Ahb_sdriver drv,
                input Mas_cell    m
                );
    scb.save_expected(m);
  endtask: post_tx

endclass: Scb_sdriver_cbs

//================================================================================
// Call Scoreboard from Master Monitor
//================================================================================
class Scb_mmonitor_cbs extends Ahb_mmonitor_cbs;
  Ahb_mscoreboard scb;

  function new(Ahb_mscoreboard scb);
    this.scb = scb;
  endfunction

  virtual task post_rx(
                input Ahb_mmonitor mon,
                input Slv_cell     s
                );
    scb.check_actual(s, mon.portID);
  endtask: post_rx

endclass: Scb_mmonitor_cbs

//================================================================================
// Call Scoreboard from Master Monitor
//================================================================================
class Scb_smonitor_cbs extends Ahb_smonitor_cbs;
  Ahb_mscoreboard scb;

  function new(Ahb_mscoreboard scb);
    this.scb = scb;
  endfunction

  virtual task post_rx(
                input Ahb_mmonitor mon,
                input Mas_cell     m
                );
    scb.check_actual(m, mon.portID);
  endtask: post_rx

endclass: Scb_smonitor_cbs

class Ahb_environment;
  Mas_generator mgen[];
  mailbox       mgen2drv[];
  event         mdrv2gen[];
  Mas_driver    mdrv[];
  Ahb_mconfig     mcfg;
  Ahb_mmonitor    mmon[];
  Ahb_mscoreboard mscb[];

  Slv_genertor  sgen[];
  mailbox       sgen2drv[];
  event         sdrv2gen[];
  Slv_driver    sdrv[];
  Ahb_sconfig     scfg;
  Ahb_smonitor    smon[];
  Ahb_sscoreboard sscb[];
  
  Ahb_coverage   cov[];

  vmas_itf    masi[];
  vslv_itf    slvi[];  
  
  int masnum, slvnum;

  extern function new(
                input vmas_itf masi[],
                input vslv_itf slvi[],
                input int masnum, slvnum
                );
  extern virtual function void gen_cfg();
  extern virtual function void build();
  extern virtual function void wrap_up();
  extern virtual task run();

endclass: Ahb_env

function Ahb_environment::new(
                input vmas_itf masi[],
                input vslv_itf slvi[],
                input int masnum, slvnum
                );
  this.masi = new[masi.size()];
  foreach (masi[i])
    this.masi[i] = masi[i];
  foreach (slvi[i])
    this.slvi[i] = slvi[i];
  this.masnum = masnum;
  this.slvnum = slvnum;
 
  cfg = new(masnum, slvnum);

  if($test$plusargs("Random_seed"))
    int seed;
    $value$plusargs("Random_seed=%0d", seed);
    $display("Simulation run with random seed = %d", seed);
  else
    $display("Simulation run with default random seed");

endfunction: new

function void Ahb_environment::gen_cfg();
  assert(cfg.randomize());
  cfg.display();
endfunction: gen_cfg

function void Ahb_environment::build();
  mgen = new[masnum];
  mdrv = new[masnum];
  mgen2drv = new[masnum];
  mdrv2gen = new[masnum];
  
  sgen = new[slvnum];
  sdrv = new[slvnum];
  sgen2drv = new[slvnum];
  sdrv2gen = new[slvnum];
  
  mon = new(masnum);
  scb = new();
  cov = new();

endfunction: build
