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
        SCALE_X=1,
        SCALE_Y=1,
        XPOS=0,
        YPOS=0,
        FILE=0,
        FILE_X=0,
        FILE_Y=0
    )(
        input  wire [`BUS_WIDTH:0] video_bus_in,
        output wire [`BUS_WIDTH:0] video_bus_out,
        input  wire invert
    );
    
    wire [11:0] sprite_rgb;
    wire [ADDR_WIDTH_X+ADDR_WIDTH_Y-1:0] sprite_addr;
    
    draw_rect #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT),
        .ADDR_WIDTH_X(ADDR_WIDTH_X),
        .ADDR_WIDTH_Y(ADDR_WIDTH_Y),
        .SCALE_X(SCALE_X),
        .SCALE_Y(SCALE_Y),
        .TRANSPARENCY(TRANSPARENCY),
        .ALPHA(ALPHA))
    draw_image_rect (
        .video_bus_in(video_bus_in),
        .video_bus_out(video_bus_out),
        
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
        .ADDR_WIDTH_Y(ADDR_WIDTH_Y))
    my_image_rom(
        .clk(video_bus_in[`BUS_PCLK]),
        .address(sprite_addr),
        .rgb(sprite_rgb)
    );

endmodule