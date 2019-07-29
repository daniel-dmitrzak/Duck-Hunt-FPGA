`timescale 1ns / 1ps
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
        )
    (

  input wire pclk,
  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [11:0] rgb_in,
  
  output reg [10:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [10:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg [11:0] rgb_out,    
  
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
  wire [11:0] rgb_in_d;
  wire vblnk_in_d, hblnk_in_d, hsync_in_d, vsync_in_d;
  wire [10:0] hcount_in_d, vcount_in_d;
  
  delayup #(.WIDTH(12), .CLK_DEL(`SIG_DELAY)) rgbDelay(
    .clk(pclk),
    .rst(1'b0),
    .din(rgb_in),
    .dout(rgb_in_d)
  );
  
  delayup #(.WIDTH(4), .CLK_DEL(`SIG_DELAY)) syncDelay(
    .clk(pclk),
    .rst(1'b0),
    .din({vblnk_in, hblnk_in, hsync_in, vsync_in}),
    .dout({vblnk_in_d, hblnk_in_d, hsync_in_d, vsync_in_d})
  );
  
  delayup #(.WIDTH(11), .CLK_DEL(`SIG_DELAY)) hcDelay(
    .clk(pclk),
    .rst(1'b0),
    .din(hcount_in),
    .dout(hcount_in_d)
  );
  
  delayup #(.WIDTH(11), .CLK_DEL(`SIG_DELAY)) vcDelay(
    .clk(pclk),
    .rst(1'b0),
    .din(vcount_in),
    .dout(vcount_in_d)
  );
  
    always@(posedge pclk)
            begin      
              hsync_out <= hsync_in_d;
              vsync_out <= vsync_in_d;
              hblnk_out <= hblnk_in_d;
              vblnk_out <= vblnk_in_d;
      
              hcount_out <= hcount_in_d;
              vcount_out <= vcount_in_d;        
              
              rgb_out <= rgb_nxt;   
              pixel_addr <= pixel_addr_nxt;          
           end
           
           
    always@*begin
    
    if( (hcount_in > xpos)&&(hcount_in < (xpos + WIDTH)) &&
        (vcount_in >= ypos ) && (vcount_in < (ypos + HEIGHT)) && 
        ( hblnk_in == 0 )&& (vblnk_in == 0) )
    begin
        if (invert) rect_x = 2**ADDR_WIDTH_X - (hcount_in - xpos)/SCALE_X;
        else rect_x = (hcount_in - xpos)/SCALE_X;
        rect_y = (vcount_in - ypos)/SCALE_Y;
        if(rgb_pixel == ALPHA && TRANSPARENCY == 1) begin
            rgb_nxt = rgb_in_d;
        end 
        else begin
            rgb_nxt = rgb_pixel;
        end
    end  
    else begin
        rgb_nxt = rgb_in_d;
        rect_x = 0;
        rect_y = 0;
     end
     pixel_addr_nxt = {rect_y, rect_x};
  end
      
endmodule
