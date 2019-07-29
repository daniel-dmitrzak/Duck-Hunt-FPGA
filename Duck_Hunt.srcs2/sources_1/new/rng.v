`timescale 1ns / 1ps
`define WIDTH 8 
// Generator liczb pseudolosowych typu Line Feedback Shift Register (LFSR)

module lfsr_updown #(parameter BITS=`WIDTH, MIN=0, MAX=2**`WIDTH) (
        input clk,
        input reset,
        input enable,
        input up_down,                      // Wejœcie wybieraj¹ce kierunek zliczania
        output reg [`WIDTH-1 : 0] count,    // Wyjœcie liczby losowej
        output wire [BITS-1:0] countMinMax  // Wyjœcie liczby losowej ograniczonej parametrami MIN i MAX
    );
    
    wire overflow; 
    assign overflow = (up_down) ? (count == {{`WIDTH-1{1'b0}}, 1'b1}) : 
                                    (count == {1'b1, {`WIDTH-1{1'b0}}}) ;
    assign countMinMax = (count % MAX) | MIN;
    
    always @(posedge clk)
        if (reset) 
            count <= {`WIDTH{1'b0}};
        else if (enable) begin
            if (up_down) begin
                count <= {~(^(count & `WIDTH'b01100011)),count[`WIDTH-1:1]};
            end else begin
                count <= {count[`WIDTH-2:0],~(^(count &  `WIDTH'b10110001))};
        end
    end

endmodule