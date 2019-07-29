`timescale 1ns / 1ps
`include "video_bus.h"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2017 01:57:42 PM
// Design Name: 
// Module Name: sync_and_blank
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


module sync_and_blank(
    input [`BUS_WIDTH:0] video_bus_in,
    output reg hsync_out,
    output reg vsync_out,
    output reg [11:0] rgb_out
    );
    
    wire pclk;
    assign pclk = video_bus_in[`BUS_PCLK];
    reg [11:0] rgb_out_nxt;
    
    `MAKE_VSYNC(video_bus_in)
    `MAKE_HSYNC(video_bus_in)
    `MAKE_VBLNK(video_bus_in)
    `MAKE_HBLNK(video_bus_in)
    
    always@(posedge pclk)begin
        rgb_out <= rgb_out_nxt;
        vsync_out <= vsync;
        hsync_out <= hsync;
    end
    
    always@*begin
        if(hblnk || vblnk) rgb_out_nxt = 12'h0_0_0;
        else rgb_out_nxt = video_bus_in[`BUS_RGB];
    end
    
endmodule
