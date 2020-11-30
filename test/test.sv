interface itf (input clk);
  parameter WITH = 3;
  logic [WIDTH-1:0] req;
  logic [WIDTH-1:0] grant;
  modport itf (
  input req,
  output grant
  );
endinterface: itf

module test
#(
 WIDTH = 5 
)
(
  itf.rtl test_int
);

  assign test_int.grant = test_int.req;

endmodule
