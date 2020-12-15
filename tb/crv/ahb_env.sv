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
// Call Scoreboard from Slave Monitor
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

//================================================================================
// Call Coverage from Master Monitor
//================================================================================
class Cov_mmonitor_cbs extends Ahb_mmonitor_cbs
  Ahb_mcoverage cov;

  function new (Ahb_mcoverage cov);
    this.cov = cov;
  endfunction: new

  vitual task post_rx(
            input Ahb_mmonitor mmon,
            input Mas_cell     m,
            );
  endtask: post_rx

endclass: Cov_mmonitor_cbs

//================================================================================
// Call Coverage from Slave Monitor
//================================================================================
class Cov_smonitor_cbs extends Ahb_smonitor_cbs
  Ahb_scoverage cov;

  function new (Ahb_scoverage cov);
    this.cov = cov;
  endfunction: new

  vitual task post_rx(
            input Ahb_mmonitor smon,
            input Slv_cell     s,
            );
  endtask: post_rx

endclass: Cov_smonitor_cbs

//================================================================================
// Environment
//================================================================================

class Ahb_environment;
  Mas_generator mgen[];
  mailbox       mgen2drv[];
  event         mdrv2gen[];
  Mas_driver    mdrv[];
  //Ahb_mconfig     mcfg;
  Ahb_mmonitor    mmon[];
  Ahb_mscoreboard mscb[];

  Slv_genertor  sgen[];
  mailbox       sgen2drv[];
  event         sdrv2gen[];
  Slv_driver    sdrv[];
  //Ahb_sconfig     scfg;
  Ahb_smonitor    smon[];
  Ahb_sscoreboard sscb[];
  
  Ahb_config     cfg[];
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

//================================================================================

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
  mmon = new[masnum];
  mgen2drv = new[masnum];
  mdrv2gen = new[masnum];
  
  sgen = new[slvnum];
  sdrv = new[slvnum];
  smon = new[slvnum];
  sgen2drv = new[slvnum];
  sdrv2gen = new[slvnum];
 
  mscb = new(masnum); 
  sscb = new(slvnum); 
  mcov = new();
  scov = new();

  foreach(mgen[i]) begin
    mgen2drv[i] = new();
    mgen[i] = new(mgen2drv[i], mdrv2gen[i], cfg.master[i], i);
    mdrv[i] = new(mgen2drv[i], mdrv2gen[i], masi[i], i);
  end 

  foreach(sgen[i]) begin
    sgen2drv[i] = new();
    sgen[i] = new(sgen2drv[i], mdrv2gen[i], cfg.slave[i], i);
    sdrv[i] = new(mgen2drv[i], mdrv2gen[i], slvi[i], i);
  end

  foreach(mmon[i])
    mmon[i] = new(masi[i], i);

  foreach(smon[i])
    smon[i] = new(slvi[i], i);
   
  // connect scoreboard with callbacks	
  begin
    Ahb_mdriver_cbs smdc  = new(mscb);
    Ahb_mmonitor_cbs smmc = new(mscb);
    foreach (mdrv[i]) 
      mdrv[i].cbsq.push_back(smdc);
    foreach (mmon[i])
      mmon[i].cbsq.push_back(smmc);
  end
 
  begin
    Ahb_sdriver_cbs  ssdc  = new(sscb);
    Ahb_smonitor_cbs ssmc = new(sscb);
    foreach (sdrv[i]) 
      sdrv[i].cbsq.push_back(ssdc);
    foreach (mmon[i])
      mmon[i].cbsq.push_back(ssmc);
  end

  // connect coverage wth callbacks
  begin
    Cov_mmonitor_cbs mc = new(mcov);    
    foreach (mnon[i]) mmon[i].cbsq.push_back(mc);
  end
  
  begin  
    Cov_smonitor_cbs sc = new(scov);
    foreach (smon[i]) smon[i].sbsq.push_back(sc);
  end

endfunction: build

//================================================================================

task Ahb_environment::run();
  int running;
  running = masnum;  

  foreach(mgen[i]) begin
    int j=i;
    fork
      if(cfg.mas_in_use[j])
      begin 
        mgen[j].run();
        mdrv[j].run();
      end   
    join_none
  end   
  
  foreach(smon[i]) begin
    int j=i;
    fork
      smon[j].run();
    join_none
  end

  foreach(mgen[i]) begin
    int j=i;
    fork
      sgen[j].run();
      sdrv[j].run();
    join_none
  end

  foreach(mmon[i]) begin
    int j=i;
    fork
      mmon[j].run();
    join_none
  end

  fork: timeout
    wait(running == 0);

    begin
      repeat(1000000) @masi[0].master_cb);
        $display("%t: ERRORRR: Timeout while waiting for master generators to finish", $time);
        cfg.n_errors++;
    end  
  join_any
  disable timeout

endtask: run

function void Ahb_environment::wrap_up();
  $display("%t: End of simulation, %d error%s",  
    $time, cfg.n_errors, cfg.n_errors==1 ? "" : "s");
    
  mscb.wrap_up;
  sscb.wrap_up;  

endfunction: wrap_up

