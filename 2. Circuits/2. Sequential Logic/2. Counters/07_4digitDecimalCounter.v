module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
	
    reg[3:0] q3, q2, q1, q0;
    decade_counter dc0(clk, reset, 1'b1,q0);
    decade_counter dc1(clk, reset, ena[1],q1);
    decade_counter dc2(clk, reset, ena[2],q2);
    decade_counter dc3(clk, reset, ena[3],q3);

    assign ena = {(q0 == 4'd9 & q1 == 4'd9 & q2 == 4'd9),(q0 == 4'd9 & q1 == 4'd9),(q0 == 4'd9)};
    assign q = {{q3, q2, q1, q0}};
endmodule

module decade_counter(
	input clk,
	input reset,
    input enable,
	output reg [3:0] q);
	
	always @(posedge clk)
        if (reset || (q == 9 & enable))	// Count to 10 requires rolling over 9->0 instead of the more natural 15->0
			q <= 0;
    	else if (enable)
			q <= q+1;
	
endmodule

