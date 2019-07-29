`timescale 1ns / 1ps
`include "video_bus.h"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2017 01:47:52 PM
// Design Name: 
// Module Name: sync_gen
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


module sync_gen #(
    parameter
    START=0,
    END=0,
    WIDTH=11)(
    input [WIDTH-1:0] din,
    output reg sync_out
    );
     
    always@(*)begin
        if(din < START) sync_out = 1'b0;
        else if(din >= START && din < END) sync_out = 1'b1;
        else if(din >= END) sync_out = 1'b0;
        else sync_out = 1'b0;
    end
    
endmodule
