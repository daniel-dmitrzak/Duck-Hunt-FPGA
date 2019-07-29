`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2017 03:28:20 PM
// Design Name: 
// Module Name: duck
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
`include "video_bus.h"

module duck_img(
        input wire [38:0] video_bus_in,
        output wire [38:0] video_bus_out,
        input aclk
    );
    
    
    
    draw_sprite #(
        .XPOS(100),
        .YPOS(100),
        .FILE("C:/Users/Daniel_fixed/OneDrive/UEC/Duck Hunt/Grafika/sprites_128x128.jpg.data")
    ) duck_sprite(   
        .video_bus_in(video_bus_in),
        .video_bus_out(video_bus_out),
        .sprite_id(current_sprite)
    );
    
    
    
    
endmodule
