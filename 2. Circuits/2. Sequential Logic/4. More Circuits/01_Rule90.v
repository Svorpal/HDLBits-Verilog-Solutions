module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 
    
    reg[511:0] q_r;
    always @(posedge clk) begin
        if(load) begin
            q_r <= data;
        end
        else begin
            // q <= {1'b0,q[511:1]} ^ {q[510:0], 1'b0} ;
            q_r <= (q_r >> 1) ^ (q_r << 1);
        end
    end
    assign q = q_r;
endmodule

/*
module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);
	
	always @(posedge clk) begin
		if (load)
			q <= data;	// Load the DFFs with a value.
		else begin
            // At each clock, the DFF storing each bit position becomes the XOR of its left neighbour
			// and its right neighbour. Since the operation is the same for every
			// bit position, it can be written as a single operation on vectors.
			// The shifts are accomplished using part select and concatenation operators.
			
			//     left           right
			//  neighbour       neighbour
            q <= {1'b0,q[511:1]} ^ {q[510:0], 1'b0} ;
		end
	end
endmodule

*/
