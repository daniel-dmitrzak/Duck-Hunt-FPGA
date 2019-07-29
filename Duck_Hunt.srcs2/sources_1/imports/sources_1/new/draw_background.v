`timescale 1ns / 1ps
`include "video_bus.h"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Design Name: 
// Module Name: draw_background
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define BG_COLOR 12'h1_3_5

module draw_background(
  input [`BUS_WIDTH:0] video_bus_in,
  output [`BUS_WIDTH:0] video_bus_out
    );
  
  
  `MAKE_IN_SIGNALS
  `MAKE_OUT_SIGNALS
  `MAKE_IN_BUS(video_bus_in)
  `MAKE_OUT_BUS(video_bus_out)
  
  reg [11:0] rgb_out_nxt;
  
  always@(posedge pclk)
        begin
          hcount_out <= hcount_in;
          vcount_out <= vcount_in;
          
          rgb_out <= rgb_out_nxt;
       end
       
        always @(*)
        begin        
             rgb_out_nxt = `BG_COLOR;
        end
endmodule
