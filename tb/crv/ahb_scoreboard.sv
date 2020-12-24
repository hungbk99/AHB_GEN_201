/*********************************************************************************
 * File Name: 		ahb_scoreboard.sv
 * Project Name:	AHB_Gen
 * Email:         quanghungbk1999@gmail.com
 * Version    Date      Author      Description
 * v0.0       2/10/2020 Quang Hung  First Creation
 *********************************************************************************/

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
  
  extern function new(input Config cfg);
  extern virtual function void wrap_up();
  extern function void save_expected(Master m);  
  extern function void check_actual(input Master m, input int portID);
  extern function void display(string prefix="");

endclass: Mas_scoreboard

//--------------------------------------------------------------------------------

function Mas_scoreboard::new(input Config cfg);
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
  $display("%t: Master_Scb Saved", $time);
  expect_cells[m.hwdata].mq.push_back(m);
  expect_cells[m.hwdata].iexpect++;
  iexpect++;
  m.display($sformatf("%t: Mas scoreboard Saved:", $time)); 
endfunction: save_expected

//--------------------------------------------------------------------------------
// hwdata: the master identify --> monitor has to know which scoreboard must be 
// check
//--------------------------------------------------------------------------------

function void Mas_scoreboard::check_actual(input Master m, input portID);
  m.display($sformatf("%t: Scoreboard Check.......", $time));
   
  if(expect_cells[m.hwdata].mq.size() == 0) begin
    $display("%t: ERROR: Cell not found because the scoreboard for Master %d empty", m.hwdata);
  end

  expect_cells[m.hwdata].iactual++;
  iactual++; 
  foreach(expect_cells[m.hwdata].mq[i]) begin 
    if(expect_cells[m.hwdata].mq[i].compare(m)) begin
      $display("%t: Master Cells Match............");
      expect_cells[m.hwdata].mq.delete(i);  
    end
    else begin
      $display("%t: ERROR: Master Cells Miss............");
      cfg.n_errros++;
    end
  end
 
endfunction: check_actual

//--------------------------------------------------------------------------------

function void Mas_scoreboard::display(input string prefix="");
  $display("%t: Total expected cells sent %d, Total actual cells received %d", iexpect, iactual);
  foreach(expect_cells[i]) begin
    $display("Master: %d, expected: %d, actual: %d", i, expect_cells[i].iexpect, expect_cells[i].iactual);
    foreach (expect_cells[i].mq[j])
      expect_cells[i].mq[j].display($sformatf("%s Scoreboard: Master %d", prefix, i));
  end

endfunction: display

//--------------------------------------------------------------------------------

function void Mas_scoreboard::wrap_up();
  $display("%t: WRAP: Total expected cells sent %d, Total actual cells received %d", iexpect, iactual);
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
  $display("%t: Slave_Scb Saved", $time);
  expect_cells[s.hrdata].sq.push_back(s);
  expect_cells[s.hrdata].iexpect++;
  iexpect++;
  s.display($sformatf("%t: Slv scoreboard Saved:", $time)); 
endfunction: save_expected

//--------------------------------------------------------------------------------
// hwdata: the master identify --> monitor has to know which scoreboard must be 
// check
//--------------------------------------------------------------------------------

function void Slv_scoreboard::check_actual(input Slave s, input portID);
  m.display($sformatf("%t: Scoreboard Check.......", $time));
   
  if(expect_cells[s.hrdata].sq.size() == 0) begin
    $display("%t: ERROR: Cell not found because the scoreboard for Master %d empty", m.hwdata);
  end

  expect_cells[s.hrdata].iactual++;
  iactual++; 
  foreach(expect_cells[s.hrdata].sq[i]) begin 
    if(expect_cells[s.hrdata].sq[i].compare(s)) begin
      $display("%t: Slave Cells Match............");
      expect_cells[s.hrdata].sq.delete(i);  
    end
    else begin
      $display("%t: ERROR: Master Cells Miss............");
      cfg.n_errros++;
    end
  end
 
endfunction: check_actual

//--------------------------------------------------------------------------------

function void Slv_scoreboard::display(input string prefix="");
  $display("%t: Total expected cells sent %d, Total actual cells received %d", iexpect, iactual);
  foreach(expect_cells[i]) begin
    $display("Slave: %d, expected: %d, actual: %d", i, expect_cells[i].iexpect, expect_cells[i].iactual);
    foreach (expect_cells[i].sq[j])
      expect_cells[i].sq[j].display($sformatf("%s Scoreboard: Slave %d", prefix, i));
  end

endfunction: display

//--------------------------------------------------------------------------------

function void Slv_scoreboard::wrap_up();
  $display("%t: WRAP: Total expected cells sent %d, Total actual cells received %d", iexpect, iactual);
  foreach(expect_cells[i]) begin
    if(expect_cells[i].sq.size()) begin
      $display("%t: ERROR:WRAP: cells remaining in Slave[%d] scoreboard at the end of the test", $time, i);
      cfg.n_errors++;
    end
  end

endfunction: wrap_up

