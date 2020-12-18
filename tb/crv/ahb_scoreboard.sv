/*********************************************************************************
 * File Name: 		ahb_scoreboard.sv
 * Project Name:	AHB_Gen
 * Email:         quanghungbk1999@gmail.com
 * Version    Date      Author      Description
 * v0.0       2/10/2020 Quang Hung  First Creation
 *********************************************************************************/

//--------------------------------------------------------------------------------

class Expected_scells;
  Slave sq[$];
  int iexpect, iactual;

endclass: Expected_scells

//--------------------------------------------------------------------------------

class Ahb_mscoreboard;
  Ahb_config cfg;
  Expected_scells expect_cells[];    
  Slave sq[$];
  int iexpect, iactual;
  
  extern function new(Ahb_config cfg);
  extern virtual function void wrap_up();
  extern function void save_expected(Slave s);  
  extern function void check_actual(input Slave s, input int portn);
  extern function void display(string data);

endclass: Ahb_mscoreboard

//--------------------------------------------------------------------------------

function Ahb_mscoreboard::new(Ahb_config cfg);
  this.cfg = cfg;
  expect_cells = new[cfg.slvnum];
  foreach(expect_cells[i])
    expect_cells[i] = new();

endfunction: new

//--------------------------------------------------------------------------------

function Ahb_mscoreboard::save_expected(Slave s);
  $display("%t: Master_Scb Saved", $time);

endfunction: Ahb_mscoreboard
