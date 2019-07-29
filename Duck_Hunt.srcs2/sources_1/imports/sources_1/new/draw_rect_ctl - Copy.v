`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2017 13:30:45
// Design Name: 
// Module Name: draw_rect_ctl
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


module draw_rect_ctl(
        input wire mouse_left,
        input wire [11:0] mouse_xpos, 
        input wire [11:0] mouse_ypos, 
        input wire clk,
        output reg [11:0] xpos,
        output reg [11:0] ypos
    );
    
    localparam HEIGTH = 20; // Wysokoœæ ekranu w centymetrach 
    localparam HEIGTH_MM = HEIGTH * 10; // Wysokoœc ekranu w milimetrach 
    localparam V_RESOLUTION = 600; // Rozdzielczoœæ pionowa ekranu 
    localparam FREQUENCY = 100_000_000; // Czêstotliwoœæ zegara wejœciowego (clk) 
    localparam PIC_HEIGTH = 64; 
    
    // at^2/2     
    reg [11:0] xpos_nxt, ypos_nxt, ypos0, xpos0;
    reg moving = 1'b0; 
    reg [15:0] mseconds_elapsed = 0;
    reg [20:0] clk_counter = 0, clk_counter_nxt = 0;
    
    localparam IDLE = 2'd0;
    localparam FALLING = 2'd1;
    localparam DOWN = 2'd2; 
    reg [1:0] STATE = IDLE; 
    
    always@(posedge clk)
    begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt; 
        clk_counter <= clk_counter_nxt; 
    end
    
    always@*
    begin
        case (STATE)
            IDLE : begin
                        xpos_nxt = mouse_xpos;
                        ypos_nxt = mouse_ypos; 
                        clk_counter_nxt = 0;
                        mseconds_elapsed = 0;
                        ypos0 = mouse_ypos;
                        xpos0 = mouse_xpos;
                        if(mouse_left == 1'b1) begin
                            STATE = FALLING;
                        end 
                    end
            FALLING : begin
                        if(clk_counter < FREQUENCY / 1000) begin
                            clk_counter_nxt = clk_counter + 1; 
                            mseconds_elapsed = mseconds_elapsed;
                        end
                        else begin
                            clk_counter_nxt = 0;
                            mseconds_elapsed = mseconds_elapsed + 1; 
                        end
                        
                        xpos_nxt = xpos0;
                        if (ypos >= V_RESOLUTION - PIC_HEIGTH) begin
                            ypos_nxt = V_RESOLUTION - PIC_HEIGTH;
                            STATE = DOWN;
                        end 
                        else begin
                            ypos_nxt = ypos0 + (mseconds_elapsed**2)*3/100;
                        end
                    end
            DOWN : begin
                        xpos_nxt = xpos0;
                        ypos_nxt = V_RESOLUTION - PIC_HEIGTH;
                        clk_counter_nxt = 0;
                        mseconds_elapsed = 0;
                        if (mouse_left == 1'b1) begin
                            xpos0 = mouse_xpos;
                            ypos0 = mouse_ypos;
                            STATE = FALLING;
                        end 
                    end
            2'd3 : begin
                    STATE = IDLE;
                    end
            default : begin
                    end
        endcase
    end
endmodule
