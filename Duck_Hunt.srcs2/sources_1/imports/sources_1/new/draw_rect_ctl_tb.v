`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2017 13:21:25
// Design Name: 
// Module Name: draw_rect_ctl_tb
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


module draw_rect_ctl_tb(
        output reg mouse_left, 
        output reg [11:0] mouse_xpos,
        output reg [11:0] mouse_ypos,
        input wire clk
    );
    reg [11:0] mouse_xpos_nxt = 0, mouse_ypos_nxt = 0;
    reg mouse_left_nxt = 1; 
    always@(posedge clk)
    begin
        mouse_left <= mouse_left_nxt;
        mouse_xpos <= mouse_xpos_nxt;
        mouse_ypos <= mouse_ypos_nxt;
    end
    
    always@*
    begin
        mouse_xpos_nxt = 12'b0;
        mouse_ypos_nxt = 12'b0;
        mouse_left_nxt = 1'b1;
    end
    
endmodule
