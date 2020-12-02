//////////////////////////////////////////////////////////////////////////////////
// File Name: 		AHB_package.sv
// Project Name:	AHB_Gen
// Email:         quanghungbk1999@gmail.com
// Version    Date      Author      Description
// v0.0       14/11/2020 Quang Hung  First Creation
//////////////////////////////////////////////////////////////////////////////////

package AHB_package;
  typedef enum logic [1:0]
  {
    IDLE = 2'b00,
    BUSY = 2'b01,
    NONSEQ = 2'b10,
    SEQ = 2'b11
  } htrans_type;

  typedef enum logic [2:0]
  {
    BYTE,
    HALFWORD,
    WORD,
    DOUBLEWORD,
    FOURWORDLINE,
    EIGHTWORDLINE,
    SIXTEENWORDLINE,
    THIRTY2WORDLINE
  } hsize_type;

  typedef enum logic [2:0] 
  {
    SINGLE,
    INCR,
    WRAP4,
    INCR4,
    WRAP8,
    INCR8,
    WRAP16,
    INCR16
  } hburst_type;

  interface master_itf (input hclk);
    logic [31:0] haddr;
    logic        hwrite;
    hsize_type   hsize;
    hburst_type  hburst;
    logic [3:0]  hprot;
    htrans_type  htrans;
    logic        hmastlock;
    logic [31:0] hwdata;
    logic        hready;
    logic        hresetn;
    logic [31:0] hrdate;

    modport mas(
      output  haddr,
              hwrite,
              hsize,
              hburst,
              hprot,
              htrans,
              hmastlock,
              hwdata,
      input   hready,
              hresetn,
              hrdata
    );
  endinterface: ahb_itf

endpackage: AHB_package
