`timescale 1ns / 1ps
`include "video_bus.h"
`define SIG_DELAY 3
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2017 15:00:46
// Design Name: 
// Module Name: draw_rect
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


module draw_rect
    #( parameter 
        WIDTH=48,
        HEIGHT=64,
        ALPHA=12'h0_0_0,
        TRANSPARENCY=0,
        ADDR_WIDTH_X=6,
        ADDR_WIDTH_Y=6,
        SCALE_X=1,
        SCALE_Y=1
    )(
        input wire [`BUS_WIDTH:0] video_bus_in,
        output wire [`BUS_WIDTH:0] video_bus_out,
        output reg [ADDR_WIDTH_X+ADDR_WIDTH_Y-1:0] pixel_addr,
        input wire [10:0] xpos,
        input wire [10:0] ypos,
        input wire [11:0] rgb_pixel,
        input wire invert
    );
    
    reg [11:0] rgb_nxt; 
    reg [ADDR_WIDTH_X-1:0] rect_x; 
    reg [ADDR_WIDTH_Y-1:0] rect_y;
    reg [ADDR_WIDTH_X+ADDR_WIDTH_Y-1:0] pixel_addr_nxt;
    wire [`BUS_WIDTH:0] video_bus_d;
    
    `MAKE_IN_SIGNALS
    `MAKE_OUT_SIGNALS
    `MAKE_IN_BUS(video_bus_in)
    `MAKE_OUT_BUS(video_bus_out)
    
    // OpóŸnianie magistrali w celu synchronizacji
    delayup #(.WIDTH(`BUS_WIDTH + 1), .CLK_DEL(`SIG_DELAY)) vbDelay(
    .clk(video_bus_in[`BUS_PCLK]),
    .rst(1'b0),
    .din(video_bus_in),
    .dout(video_bus_d)
    );
    
    always@(posedge pclk)
    begin      
      hcount_out <= video_bus_d[`BUS_HC];
      vcount_out <= video_bus_d[`BUS_VC];        
      
      rgb_out <= rgb_nxt;   
      pixel_addr <= pixel_addr_nxt;          
   end
   
           
    always@*begin
    
    if( (hcount_in >= xpos)&&(hcount_in < (xpos + WIDTH)) &&
        (vcount_in >= ypos ) && (vcount_in < (ypos + HEIGHT)))
    begin
        if (invert) rect_x = 2**ADDR_WIDTH_X - (hcount_in - xpos)/SCALE_X;
        else rect_x = (hcount_in - xpos)/SCALE_X;
        rect_y = (vcount_in - ypos)/SCALE_Y;
        if(rgb_pixel == ALPHA && TRANSPARENCY == 1) begin
            rgb_nxt = video_bus_d[`BUS_RGB];
        end 
        else begin
            rgb_nxt = rgb_pixel;
        end
    end  
    else begin
        rgb_nxt = video_bus_d[`BUS_RGB];
        rect_x = 0;
        rect_y = 0;
     end
     pixel_addr_nxt = {rect_y, rect_x};
    end
      
endmodule
