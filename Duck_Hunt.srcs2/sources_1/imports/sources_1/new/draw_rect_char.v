`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2017 18:05:21
// Design Name: 
// Module Name: draw_rect_char
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


module draw_rect_char(
         input wire pclk,
          
         input wire [10:0] vcount_in,
         input wire vsync_in,
         input wire vblnk_in,
         input wire [10:0] hcount_in,
         input wire hsync_in,
         input wire hblnk_in,
         input wire [11:0] rgb_in,
         input wire [7:0] char_pixel,
         
         output reg [10:0] vcount_out,
         output reg vsync_out,
         output reg vblnk_out,
         output reg [10:0] hcount_out,
         output reg hsync_out,
         output reg hblnk_out,
         output reg [11:0] rgb_out,    
         output reg [7:0] char_xy,
         output reg [3:0] char_line
    );
    
    localparam CHAR_SIZE_X = 8;
    localparam CHAR_SIZE_Y = 16;
    localparam CHARS_X = 16; 
    localparam CHARS_Y = 16;
    localparam BOX_SIZE_X = CHAR_SIZE_X * CHARS_X;
    localparam BOX_SIZE_Y = CHAR_SIZE_Y * CHARS_Y;
    localparam BOX_POS_X = 100;
    localparam BOX_POS_Y = 100;
    localparam CHAR_COLOR = 12'hf_0_0;
    
    reg [11:0] rgb_nxt;
    reg [7:0] char_xy_nxt = 0;
    reg [3:0] char_line_nxt = 0;    
    
    wire [11:0] rgb_in_d;
    wire [3:0] char_line_nxt_d;
    wire vsync_d, hsync_d, vblnk_d, hblnk_d;
    wire [10:0] vcount_d, hcount_d;
    
    delayup rgbin_delay(
        .clk(pclk),
        .din(rgb_in),
        .dout(rgb_in_d),
        .rst(1'b0)
    );
    
    delayup #(.WIDTH(11), .CLK_DEL(3)) hc_delay(
        .clk(pclk),
        .din(hcount_in),
        .dout(hcount_d),
        .rst(1'b0)
        );
    
    delayup #(.WIDTH(11), .CLK_DEL(3)) vc_delay(
        .clk(pclk),
        .din(vcount_in),
        .dout(vcount_d),
        .rst(1'b0)
        );
        
    delayup #(.WIDTH(4), .CLK_DEL(1)) line_delay(
        .clk(pclk),
        .din(char_line_nxt),
        .dout(char_line_nxt_d),
        .rst(1'b0)
        );
        
    
    delayup #(.WIDTH(4), .CLK_DEL(3)) sync_delay(
        .clk(pclk),
        .din({vsync_in, hsync_in, vblnk_in, hblnk_in}),
        .dout({vsync_d, hsync_d, vblnk_d, hblnk_d}),
        .rst(1'b0)
        );
    
    always@(posedge pclk) begin
        vsync_out <= vsync_d;
        hsync_out <= hsync_d;
        hblnk_out <= hblnk_d;
        vblnk_out <= vblnk_d;
        
        hcount_out <= hcount_d;
        vcount_out <= vcount_d;
        
        rgb_out   <= rgb_nxt;  
        char_xy <= char_xy_nxt;
        char_line <= char_line_nxt_d;
    end 
    
    reg [7:0] data;
    
    always@*begin
        rgb_nxt = rgb_in;
        char_xy_nxt = { hcount_in[7:3], vcount_in[7:4] };
        char_line_nxt = vcount_in[3:0] - 2;
        data = char_pixel[7 - hcount_d[2:0]];
        if( hcount_in >= BOX_POS_X && 
            hcount_in < BOX_POS_X + BOX_SIZE_X && 
            vcount_in >= BOX_POS_Y && 
            vcount_in < BOX_POS_Y + BOX_SIZE_Y && 
            data == 1'b1) begin 
                rgb_nxt = CHAR_COLOR;
        end
        else begin
            rgb_nxt = rgb_in_d;
        end
    end
    
endmodule
