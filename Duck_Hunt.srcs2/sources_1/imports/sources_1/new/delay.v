`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2017 14:28:50
// Design Name: 
// Module Name: delay
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


module delay(
    
    input wire [11:0] xpos_in, ypos_in,
    output reg [11:0] xpos_out, ypos_out,
    
    input wire pclk
    );
    
    always @(posedge pclk)
    begin
        xpos_out <= xpos_in;
        ypos_out <= ypos_in;
    end
endmodule 