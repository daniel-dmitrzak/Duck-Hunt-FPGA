`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2017 01:25:15 PM
// Design Name: 
// Module Name: char_rom_16x16
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


module char_rom_16x16(
    input wire clk,
    input wire [7:0] char_xy,
    output reg [6:0] char_code
    );
    
    reg [6:0] char_code_nxt;
    
    always@(posedge clk)begin
        char_code <= char_code_nxt;
    end
    
    always@*
        case(char_xy)
            8'h00 : char_code_nxt = 6'h38;
            default: char_code_nxt = 6'h31;
        endcase
    
endmodule
