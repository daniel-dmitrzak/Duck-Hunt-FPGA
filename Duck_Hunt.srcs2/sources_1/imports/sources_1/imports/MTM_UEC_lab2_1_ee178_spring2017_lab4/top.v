// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps
`include "video_bus.h"
// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module top (
        input wire clk,
        input wire [15:0] sw,
        output vs,
        output hs,
        output [3:0] r,
        output [3:0] g,
        output [3:0] b,
        input wire btnC,
        output wire [15:0] led,
        input [7:0] JXADC
    );
    
    wire trigger;
    wire sensor;  
    wire blanking;
    assign sensor = JXADC[7];
    assign led[13] = sensor;
    assign led[12] = trigger;
    
    // Generowanie zegara 40MHz
    wire clk_in, locked, clk_fb, clk_ss, clk_out, pclk, clk100MHz;
    (* KEEP = "TRUE" *) 
    (* ASYNC_REG = "TRUE" *)
    reg [7:0] safe_start = 0;
    clk_wiz_0 my_clk_ctrl (
          .clk100MHz(clk100MHz),
          .clk40MHz(pclk),
          .reset(1'b0),
          .clk(clk),
          .locked()
      );  
    
    // Magistrale video dla poszczególnych modu³ów
    wire [`BUS_WIDTH:0] bus_timing, bus_bg, bus_fg, bus_cnc, bus_tree, bus_bush, bus_blnk;
    
    // Debouncing spustu pistoletu 
    debounce trigger_db(
        .clk(pclk),
        .sw(JXADC[4]),
        .db_level(trigger),
        .db_tick(),
        .reset(1'b0)
    );
    
    // Timing
    vga_timing my_timing (
        .video_bus_out(bus_timing),
        .pclk(pclk)
    );
    
    // T³o/niebo
    draw_background my_background(
        .video_bus_in(bus_timing),
        .video_bus_out(bus_bg)
    );
    
    // Command and Control wszystkich kaczek
    wire [10:0] x1, y1;
    duck_cnc main_cnc(
        .video_bus_in(bus_bg),
        .video_bus_out(bus_cnc),
        .aPeriod({5'b0, sw[2:0]}),
        .sPeriod(sw[15:8]),
        .resetDucks(btnC),
        .stateMon(led[2:0]),
        .frameMon(led[4:3]),
        .sclkMon(led[15]),
        .aclkMon(led[14]),
        .blanking(blanking),
        .sensor(sensor),
        .x1(x1),
        .y1(y1)
    );
    
    // Rysowanie grafik: drzewo, krzak, pierwszy plan
    draw_image #(
        .WIDTH(256),
        .HEIGHT(256),
        .ALPHA(12'H0_0_9),
        .TRANSPARENCY(1),
        .ADDR_WIDTH_X(8),
        .ADDR_WIDTH_Y(8),
        .XPOS(50),
        .YPOS(160),
        .FILE("tree_256x256.jpg.data"),
        .FILE_X(256),
        .FILE_Y(256)
    ) tree(   
        .video_bus_in(bus_cnc),
        .video_bus_out(bus_tree),
        .invert(1'b0)
    );
        
    draw_image #(
        .WIDTH(128),
        .HEIGHT(128),
        .ALPHA(12'H0_0_9),
        .TRANSPARENCY(1),
        .ADDR_WIDTH_X(7),
        .ADDR_WIDTH_Y(7),
        .XPOS(670),
        .YPOS(300),
        .FILE("bush_128x128.jpg.data"),
        .FILE_X(128),
        .FILE_Y(128)
    ) bush(   
        .video_bus_in(bus_tree),
        .video_bus_out(bus_bush),
        .invert(1'b0)
    );
    
    draw_image #(
        .WIDTH(800),
        .HEIGHT(128*2),
        .ALPHA(12'H0_0_9),
        .TRANSPARENCY(1),
        .ADDR_WIDTH_X(8),
        .ADDR_WIDTH_Y(7),
        .SCALE_X(2),
        .SCALE_Y(2),
        .XPOS(0),
        .YPOS(400),
        .FILE("foreground_256x128.jpg.data"),
        .FILE_X(256),
        .FILE_Y(128)
    ) foreground(   
        .video_bus_in(bus_bush),
        .video_bus_out(bus_fg),
        .invert(1'b0)
    );
    
    // Wygaszanie ekranu i wyœwietlanie bia³ego prostok¹ta w miejscu 
    // kaczki 
    blanker gun_blanker(
        .video_bus_in(bus_fg),
        .video_bus_out(bus_blnk),
        .trigger(trigger),
        .blanking(blanking),
        .x1(x1),
        .y1(y1),
        .callib(sw[3])
    );
    
    // Tworzenie brakuj¹cych sygna³ów niezbêdnych do obs³ugi VGA
    // t.j. Vsync, Hsync, Vblank, Hblank
    sync_and_blank finish_signals(
        .video_bus_in(bus_blnk),
        .rgb_out({r,g,b}),
        .vsync_out(vs),
        .hsync_out(hs)
    );        
    
endmodule
