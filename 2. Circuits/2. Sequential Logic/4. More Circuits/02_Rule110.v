module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
); 
    reg [511:0] q_r;
    always @(posedge clk) begin
        if(load)
            q_r <= data;
        else
            // (C+R) * (L'+C'+R')
            q_r <= ((q_r)|({q_r[510:0], 1'b0})) & (~({1'b0, q_r[511:1]}) | ~(q_r) | ~({q_r[510:0], 1'b0}));
    end
	assign q = q_r;
endmodule
