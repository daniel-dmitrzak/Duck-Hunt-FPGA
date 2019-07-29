`timescale 1ns / 1ps
/*
    Modu³ sterowania kaczk¹. Ka¿da kaczka jest prost¹ maszyn¹ stanów.
*/


module duck_ctl(
        input aclk, sclk, rst,  
        output reg [10:0] x,    // Pozycja X kaczki
        output reg [10:0] y,    // Pozycja Y kaczki
        output reg [1:0] sprite,// Aktualny sprite (wiêcej info w module draw_sprite)
        output reg [1:0] frame, // Aktualna klatka animacji
        output reg [2:0] state, // Aktualny stan
        output reg invert,      // Odwrócenie sprite'a (wiêcej info w module draw_sprite)
        input wire shot         // Trafienie kaczki
    );
    
    // Poszczególne stany kaczki
    localparam DIR_UP = 3'b000;     // Lot w górê
    localparam DIR_RUP = 3'b001;    // Lot po skosie w prawo
    localparam DIR_LUP = 3'b010;    // Lot po skosie w lewo
    localparam DIR_RIGHT = 3'b011;  // Lot w prawo
    localparam DIR_LEFT = 3'b100;   // Lot w lewo
    localparam SHOT = 3'b101;       // Zestrzelenie
    localparam FALLING = 3'b110;    // Spadanie
    
    // Prêdkoœci poruszania siê kaczki
    localparam VER_SPEED = 10;
    localparam HOR_SPEED = 20;
    
    reg [2:0] state_nxt = 0;
    reg [1:0] frame_nxt = 0;
    reg [1:0] sprite_nxt = 0;
    wire [2:0] random;
    reg [10:0] x_nxt = 0, y_nxt = 0;
    reg [4:0] shot_count, shot_count_nxt;
    reg fall, fall_nxt = 1'b0;
    
    // Generator liczb pseudolosowych. Liczba wynikowa ograniczona jest do wartoœci z przedzia³u 0 - 4
    // poniewa¿ te wartoœci odpowiadaj¹ za stany kaczki "¿ywej".
    lfsr_updown  #(.MAX(4), .BITS(3)) flight (
        .clk(sclk),
        .reset(1'b0),
        .enable(1'b1),
        .up_down(1'b1),
        .count(),
        .countMinMax(random)
    );
    
    always@(posedge aclk or posedge shot)
    begin
        x <= x_nxt;
        y <= y_nxt;
        sprite <= sprite_nxt;
        frame <= frame_nxt; 
        shot_count <= shot_count_nxt;
        fall <= fall_nxt;
        if(shot) begin // Wymagane poniewa¿ zestrzelenie musi nastêpowaæ asynchronicznie. 
            state <= SHOT;
        end
        else begin; 
            state <= state_nxt;
        end
    end
    
    always@*begin
        shot_count_nxt = 0;
        frame_nxt = ( frame + 1 ) % 3; 
        fall_nxt = 1'b0;
        if(rst) begin
            x_nxt = 11'd400;
            y_nxt = 11'd300;
            state_nxt = 0;
            invert = 0;
            sprite_nxt = 2'd0;
        end else begin
            case(state)
                DIR_UP :    begin
                                if(y <= 0) begin
                                    y_nxt = 420;
                                    x_nxt = 400;
                                end
                                else begin 
                                    y_nxt = y - VER_SPEED;
                                    x_nxt = x; 
                                end
                                if(shot) state_nxt = SHOT;
                                else state_nxt = random; 
                                invert = 0;
                                sprite_nxt = 2'd0;
                            end
                DIR_LUP :   begin
                                if(y <= 0) begin
                                    y_nxt = 420;
                                    x_nxt = 400;
                                end
                                else begin 
                                    y_nxt = y - VER_SPEED;
                                    x_nxt = x - HOR_SPEED; 
                                end
                                if(shot) state_nxt = SHOT;
                                else begin
                                    if(x > 74) state_nxt = random;
                                    else       state_nxt = DIR_RIGHT;
                                end
                                invert = 1;
                                sprite_nxt = 2'd1;
                            end
                DIR_RUP :   begin
                                if(y <= 0) begin
                                    y_nxt = 420;
                                    x_nxt = 400;
                                end
                                else begin 
                                    y_nxt = y - VER_SPEED;
                                    x_nxt = x + HOR_SPEED; 
                                end
                                if(shot) state_nxt = SHOT;
                                else begin
                                    if(x < 700) state_nxt = random;
                                    else        state_nxt = DIR_LEFT;
                                end
                                invert = 0;
                                sprite_nxt = 2'd1;
                            end
                DIR_RIGHT : begin
                                y_nxt = y;
                                x_nxt = x + HOR_SPEED;
                                if(shot) state_nxt = SHOT;
                                else begin
                                    if(x < 700) state_nxt = random;
                                    else        state_nxt = DIR_LUP;
                                end
                                invert = 0;
                                sprite_nxt = 2'd2;
                            end
                DIR_LEFT :  begin
                                y_nxt = y;
                                x_nxt = x - HOR_SPEED;
                                if(shot) state_nxt = SHOT;
                                else begin
                                    if(x > 80) state_nxt = random;
                                    else       state_nxt = DIR_RUP;
                                end
                                invert = 1;
                                sprite_nxt = 2'd2;
                            end
                SHOT    :   begin   
                                x_nxt = x;
                                y_nxt = y;
                                invert = 0;
                                sprite_nxt = 2'd3;
                                frame_nxt = 2'd0;
                                if(shot_count >= 10) state_nxt = FALLING;
                                else begin
                                    state_nxt = state;
                                    shot_count_nxt = shot_count + 1;
                                end
                            end
                FALLING :   begin
                                x_nxt = x;
                                y_nxt = y;
                                state_nxt = state;
                                if(y >= 420) state_nxt = random;
                                else y_nxt = y + VER_SPEED;
                                fall_nxt = ~fall;
                                frame_nxt = {~fall, fall};
                                sprite_nxt = 2'd3;
                                invert = 0;
                            end
                default :   begin
                                y_nxt = y;
                                x_nxt = x;
                                state_nxt = DIR_UP;
                                invert = 0;
                                sprite_nxt = 2'd0;
                            end
            endcase
        end
    end
    
endmodule
