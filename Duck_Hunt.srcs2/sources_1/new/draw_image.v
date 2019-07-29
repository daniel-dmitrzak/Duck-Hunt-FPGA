`include "video_bus.h"
`timescale 1 ns / 1 ps

module draw_image
#( parameter 
        WIDTH=48,
        HEIGHT=64,
        ALPHA=12'h0_0_0,
        TRANSPARENCY=0,
        ADDR_WIDTH_X=6,
        ADDR_WIDTH_Y=6,
        SCALE_X_BITS=0,
        SCALE_Y_BITS=0,
        XPOS=0,
        YPOS=0,
        FILE=0,
        FILE_X=0,
        FILE_Y=0
        )
    (

  input [`BUS_WIDTH:0] video_bus_in,
  output wire [`BUS_WIDTH:0] video_bus_out,
  input wire invert
);
 wire [10:0] hcount_out, vcount_out; 
 wire [11:0] rgb_out; 
 wire vsync_out, hsync_out;
 wire vblnk_out, hblnk_out;
 `MAKE_IN_SIGNALS
 `MAKE_IN_BUS(video_bus_in)
 `MAKE_OUT_BUS(video_bus_out)
 
     
 wire [11:0] sprite_rgb;
 wire [ADDR_WIDTH_X+ADDR_WIDTH_Y-1:0] sprite_addr;

 draw_rect #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT),
        .ADDR_WIDTH_X(ADDR_WIDTH_X),
        .ADDR_WIDTH_Y(ADDR_WIDTH_Y),
        .SCALE_X_BITS(SCALE_X_BITS),
        .SCALE_Y_BITS(SCALE_Y_BITS),
        .TRANSPARENCY(TRANSPARENCY),
        .ALPHA(ALPHA)
        )
    draw_image_rect (
        .pclk(pclk),
        .vcount_in(vcount_in),
        .vsync_in(vsync_in),
        .vblnk_in(vblnk_in),
        .hcount_in(hcount_in),
        .hsync_in(hsync_in),
        .hblnk_in(hblnk_in),
        .rgb_in(rgb_in),
        
        .vcount_out(vcount_out),
        .vsync_out(vsync_out),
        .vblnk_out(vblnk_out),
        .hcount_out(hcount_out),
        .hsync_out(hsync_out),
        .hblnk_out(hblnk_out),
        .rgb_out(rgb_out),
        
        .xpos(XPOS),
        .ypos(YPOS),
        .rgb_pixel(sprite_rgb),
        .pixel_addr(sprite_addr),
        .invert(invert)
    );
    
    image_rom #(
        .SIZEX(FILE_X),
        .SIZEY(FILE_Y),
        .FILE(FILE),
        .ADDR_WIDTH_X(ADDR_WIDTH_X),
        .ADDR_WIDTH_Y(ADDR_WIDTH_Y)
    )
    
    my_image_rom(
        .clk(pclk),
        .address(sprite_addr),
        .rgb(sprite_rgb)
    );
    
endmodule