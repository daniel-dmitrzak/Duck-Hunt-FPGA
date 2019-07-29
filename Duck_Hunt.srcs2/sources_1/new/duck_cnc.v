`timescale 1ns / 1ps
`include "video_bus.h"
`include "vesa_vga.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2017 07:25:46 PM
// Design Name: 
// Module Name: duck_cnc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Tutaj g³ównie ³¹czymy modu³y. 
// 
//////////////////////////////////////////////////////////////////////////////////


module duck_cnc(
    input  [`BUS_WIDTH:0] video_bus_in,
    output [`BUS_WIDTH:0] video_bus_out,
    input [7:0] aPeriod,
    input [7:0] sPeriod,
    input resetDucks,
    output [2:0] stateMon,
    output [1:0] frameMon,
    output aclkMon,
    output sclkMon,
    input sensor,
    input blanking,
    output [10:0] x1,
    output [10:0] y1
    );
    
    wire aclk, sclk;
    wire [1:0] sprite;
    wire [2:0] state;
    wire [1:0] frame;
    wire invert;
    
    assign stateMon = state;
    assign frameMon = frame;
    assign aclkMon = aclk;
    assign sclkMon = sclk;
    
    `MAKE_VSYNC(video_bus_in)
    
    frame_clock anim_clock(
        .vsync(vsync),
        .period(aPeriod),
        .clkout(aclk)
    );
    
    frame_clock state_clock(
        .vsync(vsync),
        .period(sPeriod),
        .clkout(sclk)
    );
    
    duck_ctl duck1_ctl(
        .aclk(aclk),
        .sclk(sclk),
        .x(x1),
        .y(y1),
        .sprite(sprite),
        .state(state),
        .frame(frame),
        .rst(resetDucks),
        .invert(invert),
        .shot(blanking & sensor)
    );
    
    draw_sprite #(
            .FILE("sprites_128x128.jpg.data"),
            .SCALE_X(2),
            .SCALE_Y(2),
            .WIDTH(64),
            .HEIGHT(64)
        ) duck1_sprite (   
            .video_bus_in(video_bus_in),
            .video_bus_out(video_bus_out),
            .sprite_id({sprite, frame}),
            .x(x1),
            .y(y1),
            .invert(invert)
        );
endmodule
