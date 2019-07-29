`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2017 04:42:35 PM
// Design Name: 
// Module Name: duck_ctl
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


module duck_ctl(
    input aclk, sclk, rst,
    output reg [10:0] x,
    output reg [10:0] y,
    output reg [2:0] state,
    output reg [1:0] frame
    );
    
    localparam DIR_UP = 3'bx00;
    localparam DIR_RUP = 3'b001;
    localparam DIR_RIGHT = 3'b010;
    localparam SHOT = 3'bx11;
    localparam DIR_LUP = 3'b101;
    localparam DIR_LEFT = 3'b110;
    localparam FALLING = 3'b111;
    localparam VER_SPEED = 10;
    localparam HOR_SPEED = 10;
    
    reg [2:0] state_nxt = 0;
    reg [1:0] frame_nxt = 0;
    reg [3:0] current_sprite = 0, current_sprite_nxt = 0;
    wire [2:0] random;
    reg fclk, fclk_nxt;
    reg [1:0] fcnt = 0, fcnt_nxt = 0;
    reg [10:0] x_nxt = 0, y_nxt = 0;
    wire nUp, nSid;
    reg [1:0] sprite_nxt;
    
    assign inv = state[2];
    assign nUp = state[1];
    assign nSid = state[0];
    
    
    rng  #(.BITS(3)) flight (
        .clk(sclk),
        .rst(1'b0),
        .rnd(random)
    );
    
    always@(posedge aclk)
    begin
        x <= x_nxt;
        y <= y_nxt;
        
        frame <= frame_nxt; 
    end
    
    always@(posedge sclk)
    begin
        state <= state_nxt;
    end
    
    always@*begin
        
        if(rst) begin
            x_nxt = 11'd400;
            y_nxt = 11'd300;
            state_nxt = 0;
        end else begin
            frame_nxt = ( frame + 1 ) % 3;
            
            if(state == DIR_RIGHT || state == DIR_RUP) x_nxt = x + HOR_SPEED;
            else if(state == DIR_LEFT || state == DIR_LUP) x_nxt = x - HOR_SPEED;
            else x_nxt = x;
            
            if (nUp == 0) 
                if( y <= -64) y_nxt = 600;
                else y_nxt = y - VER_SPEED;
            else y_nxt = y;    
             
            // Ograniczenie mo¿liwych stanów kaczki 
           
            if      (random[1:0] == 2'b11) state_nxt = {random[2], 2'b10};
            else if ( x > 750) state_nxt = {1'b1, random[2], ~random[2]};
            else if ( x <  50) state_nxt =  {1'b0, random[2], ~random[2]};
            else if (random == DIR_UP ) state_nxt = 3'b000;
            else state_nxt = random;
            
            if(state == SHOT) begin
                state_nxt = state;
                x_nxt = x;
                y_nxt = y;
            end
        end
    end
    
endmodule
