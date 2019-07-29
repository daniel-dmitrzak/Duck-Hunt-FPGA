`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2017 09:34:09 PM
// Design Name: 
// Module Name: blanker
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
`include "vesa_vga.vh"
`define BLANK_FRAMES 6
`define BLANK_WAIT 10

module blanker
    #(parameter BOX_WIDTH=64, BOX_HEIGHT=64)
    (
        input [`BUS_WIDTH:0] video_bus_in,
        output [`BUS_WIDTH:0] video_bus_out,
        input [10:0] x1,
        input [10:0] y1,
        input trigger,
        output reg blanking,
        input callib
    );
    
    `MAKE_IN_SIGNALS
    `MAKE_OUT_SIGNALS
    `MAKE_IN_BUS(video_bus_in)
    `MAKE_OUT_BUS(video_bus_out)
    
    reg trigger_p = 1'b0;
    reg [11:0] rgb_out_nxt;
    reg [5:0] blnk_count, blnk_count_nxt;
    reg vsync_p;
    reg blanking_nxt;
    reg [5:0] read_delay, read_delay_nxt = 0;
    
    localparam IDLE  = 2'b00;
    localparam WAIT  = 2'b01;
    localparam BLANK = 2'b10;
    localparam READ  = 2'b11;
    reg [1:0] state = IDLE, state_nxt; 
    
    `MAKE_VSYNC(video_bus_in)
    
    always@(posedge pclk)begin
        rgb_out     <= rgb_out_nxt;
        hcount_out  <= hcount_in;
        vcount_out  <= vcount_in;
        vsync_p     <= vsync;
        trigger_p   <= trigger;
        blnk_count  <= blnk_count_nxt;
        state       <= state_nxt;
        blanking    <= blanking_nxt;
        read_delay  <= read_delay_nxt;
    end
    
    always@*begin
        blnk_count_nxt = 0;
        read_delay_nxt = read_delay;
        if(callib) begin
            if(trigger == 1'b0) rgb_out_nxt = 12'hF_F_F;
            else rgb_out_nxt = 12'h0_0_0;
            blanking_nxt = 1'b0;
            state_nxt = IDLE;
        end
        else begin
            case(state)
                IDLE :  begin
                            blanking_nxt = 1'b0;
                            rgb_out_nxt = rgb_in;
                            if(trigger_p == 1'b1 && trigger == 1'b0) state_nxt = WAIT;
                            else state_nxt = state;
                        end
                WAIT :  begin
                            blanking_nxt = 1'b0;
                            rgb_out_nxt = rgb_in;
                            if(vsync == 1'b1) state_nxt = BLANK;
                            else state_nxt = state;
                        end
                BLANK:  begin
                            if(blnk_count == read_delay) blanking_nxt = 1'b1;
                            else blanking_nxt = 1'b0;
                            if( hcount_in >= x1 && hcount_in < x1 + BOX_WIDTH &&
                                vcount_in >= y1 && vcount_in < y1 + BOX_HEIGHT)
                                rgb_out_nxt = 12'hF_F_F;
                            else
                                rgb_out_nxt = 12'h0_0_0;
                                
                            if(blnk_count < `BLANK_FRAMES) begin
                                if(vsync_p == 1'b1 && vsync == 1'b0) blnk_count_nxt = blnk_count + 1;
                                else blnk_count_nxt = blnk_count;
                                state_nxt = state; 
                            end 
                            else state_nxt = READ;          
                        end
                READ :  begin
                            if(blnk_count == read_delay) blanking_nxt = 1'b1;
                            else blanking_nxt = 1'b0;
                            rgb_out_nxt = rgb_in;
                            if(blnk_count < `BLANK_WAIT) begin
                                if(vsync_p == 1'b1 && vsync == 1'b0) blnk_count_nxt = blnk_count + 1;
                                else blnk_count_nxt = blnk_count;
                                state_nxt = state; 
                            end
                            else state_nxt = IDLE;
                        end
                default:begin
                            rgb_out_nxt = rgb_in;
                            state_nxt = IDLE;
                            blanking_nxt = 1'b0;
                        end
            endcase
        end
    end
endmodule
