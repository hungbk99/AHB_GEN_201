/*********************************************************************************
 * File Name: 		ahb_scoreboard.sv
 * Project Name:	AHB_Gen
 * Email:         quanghungbk1999@gmail.com
 * Version    Date      Author      Description
 * v0.0       2/10/2020 Quang Hung  First Creation
 *********************************************************************************/

//`include "D:/Project/AMBA_BUS/AHB_GEN_201/tb/crv/ahb_cells.sv"
//`include "D:/Project/AMBA_BUS/AHB_GEN_201/tb/crv/config.sv"

//--------------------------------------------------------------------------------

class Mas_expected_cells;
  Master mq[$];
  int iexpect, iactual;

endclass: Mas_expected_cells

//--------------------------------------------------------------------------------

class Mas_scoreboard;
  Config cfg;
  Mas_expected_cells expect_cells[];    
  //Master mq[$];
  int iexpect, iactual;                //Global counter
  
  extern function new(Config cfg);
  extern virtual function void wrap_up();
  extern function void save_expected(Master m);  
  extern function void check_actual(input Master m, input int portID);
  extern function void display(string prefix="");

endclass: Mas_scoreboard

//--------------------------------------------------------------------------------

function Mas_scoreboard::new(Config cfg);
    //Hung mod 1_1_2020 
    this.cfg = cfg;
  expect_cells = new[cfg.masnum];
  foreach(expect_cells[i])
    expect_cells[i] = new();

endfunction: new
//function Mas_scoreboard::new();
//  expect_cells = new();
//
//endfunction: new


//--------------------------------------------------------------------------------

function void Mas_scoreboard::save_expected(Master m);
  $display("============================================================================================================");
  $display("%t: Master Scoreboard Saved", $time);
  expect_cells[m.hwdata].mq.push_back(m);
  expect_cells[m.hwdata].iexpect++;
  iexpect++;
  m.display($sformatf("%t: Mas scoreboard Saved:", $time)); 
  $display("============================================================================================================");
endfunction: save_expected

//--------------------------------------------------------------------------------
// hwdata: the master identify --> monitor has to know which scoreboard must be 
// check
//--------------------------------------------------------------------------------

function void Mas_scoreboard::check_actual(input Master m, input int portID);
  $display("============================================================================================================");
  m.display($sformatf("%t:Master Scoreboard Check.......", $time));
  $display("Slave: %0d", portID); 
   
  if(expect_cells[m.hwdata].mq.size() == 0) begin
    $display("%t: ERROR: Cell not found because the scoreboard for Master %d empty", $time, m.hwdata);
  end

  expect_cells[m.hwdata].iactual++;
  iactual++; 
  foreach(expect_cells[m.hwdata].mq[i]) begin 
    //Hung mod 6_1_2021
    expect_cells[m.hwdata].mq[i].display($sformatf("INFO: mq[%0d]", i));
    m.display();
    if(expect_cells[m.hwdata].mq[i].compare(m)) begin
      $display("%t: PASS:: Master Cells Match............", $time);
      expect_cells[m.hwdata].mq.delete(i);  
    end
    else begin
      $display("%t: ERROR: Master Cells Miss............", $time);
      //Hung mod 1_1_2020 
      cfg.n_errors++;
    end
  end
  $display("============================================================================================================");
 
endfunction: check_actual

//--------------------------------------------------------------------------------

function void Mas_scoreboard::display(input string prefix="");
  $display("%t: Total expected cells sent %d, Total actual cells received %d", $time, iexpect, iactual);
  foreach(expect_cells[i]) begin
    $display("Master: %d, expected: %d, actual: %d", i, expect_cells[i].iexpect, expect_cells[i].iactual);
    foreach (expect_cells[i].mq[j])
      expect_cells[i].mq[j].display($sformatf("%s Scoreboard: Master %d", prefix, i));
  end

endfunction: display

//--------------------------------------------------------------------------------

function void Mas_scoreboard::wrap_up();
  $display("%t: WRAP: Total expected cells sent %d, Total actual cells received %d", $time, iexpect, iactual);
  foreach(expect_cells[i]) begin
    if(expect_cells[i].mq.size()) begin
      $display("%t: ERROR:WRAP: cells remaining in Master[%d] scoreboard at the end of the test", $time, i);
      cfg.n_errors++;
    end
  end

endfunction: wrap_up

//--------------------------------------------------------------------------------
//================================================================================
//--------------------------------------------------------------------------------

class Slv_expected_cells;
  Slave sq[$];
  int iexpect, iactual;

endclass: Slv_expected_cells

//--------------------------------------------------------------------------------

class Slv_scoreboard;
  Config cfg;
  Slv_expected_cells expect_cells[];    
  //Master mq[$];
  int iexpect, iactual;                //Global counter
  
  extern function new(input Config cfg);
  extern virtual function void wrap_up();
  extern function void save_expected(Slave s);  
  extern function void check_actual(input Slave s, input int portID);
  extern function void display(string prefix="");

endclass: Slv_scoreboard

//--------------------------------------------------------------------------------

function Slv_scoreboard::new(input Config cfg);
    //Hung mod 1_1_2020 
    this.cfg = cfg;
  expect_cells = new[cfg.masnum];
  foreach(expect_cells[i])
    expect_cells[i] = new();

endfunction: new
//function Mas_scoreboard::new();
//  expect_cells = new();
//
//endfunction: new


//--------------------------------------------------------------------------------

function void Slv_scoreboard::save_expected(Slave s);
  $display("============================================================================================================");
  $display("%t: Slave Scoreboard Saved", $time);
  expect_cells[s.hrdata].sq.push_back(s);
  expect_cells[s.hrdata].iexpect++;
  iexpect++;
  s.display($sformatf("%t: Slv scoreboard Saved:", $time)); 
  $display("============================================================================================================");
endfunction: save_expected

//--------------------------------------------------------------------------------
// hwdata: the master identify --> monitor has to know which scoreboard must be 
// check
//--------------------------------------------------------------------------------

function void Slv_scoreboard::check_actual(input Slave s, input int portID);
  $display("============================================================================================================");
  s.display($sformatf("%t: Slave Scoreboard Check.......", $time));
  $display("Master: %0d", portID); 
  if(expect_cells[s.hrdata].sq.size() == 0) begin
    $display("%t: ERROR: Cell not found because the scoreboard for Slave %0d empty", $time, s.hrdata);
  end

  //Hung db 2_1_2020 expect_cells[s.hrdata].iactual++;
  expect_cells[s.hrdata].iactual++;
  iactual++; 
  foreach(expect_cells[s.hrdata].sq[i]) begin 
    //Hung mod 6_1_2021
    expect_cells[s.hrdata].sq[i].display($sformatf("INFO: mq[%0d]", i));
    s.display();
    if(expect_cells[s.hrdata].sq[i].compare(s)) begin
      $display("%t: PASS:: Master Cells Match............", $time);
      expect_cells[s.hrdata].sq.delete(i);  
    end
    else begin
      $display("%t: ERROR: Master Cells Miss............", $time);
      cfg.n_errors++;
    end
  end
  $display("============================================================================================================");
 
endfunction: check_actual

//--------------------------------------------------------------------------------

function void Slv_scoreboard::display(input string prefix="");
  $display("%t: Total expected cells sent %d, Total actual cells received %0d", $time, iexpect, iactual);
  foreach(expect_cells[i]) begin
    $display("Slave: %0d, expected: %d, actual: %0d", i, expect_cells[i].iexpect, expect_cells[i].iactual);
    foreach (expect_cells[i].sq[j])
      expect_cells[i].sq[j].display($sformatf("%s Scoreboard: Slave %0d", prefix, i));
  end

endfunction: display

//--------------------------------------------------------------------------------

function void Slv_scoreboard::wrap_up();
  $display("%t: WRAP: Total expected cells sent %d, Total actual cells received %d", $time, iexpect, iactual);
  foreach(expect_cells[i]) begin
    if(expect_cells[i].sq.size()) begin
      $display("%t: ERROR:WRAP: cells remaining in Slave[%d] scoreboard at the end of the test", $time, i);
      cfg.n_errors++;
    end
  end

endfunction: wrap_up

