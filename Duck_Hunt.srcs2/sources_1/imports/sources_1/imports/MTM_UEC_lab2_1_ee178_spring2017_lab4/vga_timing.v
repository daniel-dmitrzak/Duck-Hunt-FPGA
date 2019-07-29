// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps
`include "video_bus.h"
`include "vesa_vga.vh"
// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (

  output [`BUS_WIDTH:0] video_bus_out,
  input wire pclk
  
  );
  
  `MAKE_OUT_SIGNALS
  `MAKE_OUT_BUS(video_bus_out)

  reg [10:0]  hcount_nxt = 0;
  reg [10:0]  vcount_nxt = 0;
  
  always @(posedge pclk) 
    begin
      hcount_out    <= hcount_nxt;
      vcount_out    <= vcount_nxt;
      rgb_out       <= 12'h0_0_0;
     end
  
  always@*
     begin
       if (hcount_out < `HC_MAX) begin 
           hcount_nxt = hcount_out+1;
           vcount_nxt = vcount_out;
           end
       else begin
           hcount_nxt = 0;
           if (vcount_out < `VC_MAX)begin 
               vcount_nxt = vcount_out+1;
              end
         else begin
            vcount_nxt = 0;
           end
        end   
     end
endmodule
