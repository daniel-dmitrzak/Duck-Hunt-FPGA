`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
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
        input wire clk,
        input wire mouse_left,
        input wire [11:0]mouse_xpos,
        input wire [11:0]mouse_ypos,
        output reg [11:0]xpos,
        output reg [11:0]ypos
    );

    localparam stop_falling = 600 - 64;
    //falling speed
    reg [26:0] cnt_pps, cnt_pps_nxt;
    reg [15:0] speed_pps = 100, speed_pps_nxt;
    //falling accel
    reg [26:0] cnt_accel, cnt_accel_nxt;
    reg [15:0] acceleration = 80;
    reg [11:0] ypos_nxt = 0, xpos_nxt = 0;
    
    //rising edge detection
    reg p_mouse_left;

    always @(posedge clk)begin
        p_mouse_left <= mouse_left;
        ypos <= ypos_nxt;
        xpos <= xpos_nxt;
        cnt_pps <= cnt_pps_nxt;
        cnt_accel <= cnt_accel_nxt;
        speed_pps <= speed_pps_nxt;
        start_falling <= start_falling_nxt;
    end
    
    reg start_falling = 0, start_falling_nxt;
    
    always @*begin
        if (p_mouse_left == 0 && mouse_left == 1) begin
            start_falling_nxt = 1;
        end 
        else begin
            start_falling_nxt = start_falling;
        end 
        
        
        if (start_falling == 0) begin
            xpos_nxt = mouse_xpos;
            ypos_nxt = mouse_ypos;
            cnt_pps_nxt = cnt_pps;
            cnt_accel_nxt = cnt_accel;
            speed_pps_nxt = speed_pps;
        end
        else begin
            
            
            if(p_mouse_left == 0 && mouse_left == 1 && ypos >= stop_falling) begin
                xpos_nxt = mouse_xpos;
                ypos_nxt = mouse_ypos;
                cnt_pps_nxt = 0;
                cnt_accel_nxt = 0;
                speed_pps_nxt = 100;
            end 
            else begin
                xpos_nxt = xpos;
                cnt_pps_nxt = cnt_pps[25:0] + speed_pps;
                cnt_accel_nxt = cnt_accel[25:0] + acceleration;
                if (cnt_accel[26] == 1) begin
                    speed_pps_nxt = speed_pps + 10;
                end 
                else begin
                    speed_pps_nxt = speed_pps;
                end
                if (cnt_pps[26] == 1 && ypos < stop_falling) begin
                    ypos_nxt = ypos + 1;
                end 
                else begin
                    ypos_nxt = ypos;
                end
            end
            
            
            
        end
    end
    
endmodule