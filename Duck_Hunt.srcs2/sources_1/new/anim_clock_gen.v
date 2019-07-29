`timescale 1ns / 1ps
/*
    Modu� do tworzenia sygna��w zegara na podstawie sygna�u vsync. 
    Pozwala na timing w oparciu i liczb� klatek.
*/
module frame_clock(
    input vsync,
    output clkout,
    input [7:0] period
    );
    
    reg clktest = 1'b0;
    reg aclk_nxt = 1'b0;
    reg [7:0] counter = 0, counter_nxt = 0;
    
    always@(posedge vsync)begin
        clktest <= aclk_nxt;
        counter <= counter_nxt;
    end
    
    always@*begin
        if(counter == 0) aclk_nxt = ~clkout;
        else aclk_nxt = clkout;
        counter_nxt = ( counter + 1 ) % period; 
    end
    
    assign clkout = clktest;
    
endmodule
