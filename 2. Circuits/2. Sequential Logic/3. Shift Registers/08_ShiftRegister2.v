module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //
    wire clk = KEY[0];
    wire E = KEY[1];
    wire L = KEY[2];
    wire w = KEY[3];
    wire [3:0] w_input = {KEY[3],LEDR[3],LEDR[2],LEDR[1]};
    genvar i;
    generate 
        for (i = 0; i < 4; i++) begin : mux_dff
            MUXDFF muxdff(
                .clk(clk),
                .w(w_input[i]),
                .R(SW[i]),
                .E(E),
                .L(L),
                .Q(LEDR[i])
            );
        end
    endgenerate

    
endmodule

module MUXDFF (
    input clk,
    input w, R, E, L,
    output Q
);
	reg Q_r;
    always @(posedge clk) begin
        if (L) begin
            Q_r <= R;
        end
        else begin
            if(E) begin
                Q_r <= w;
            end
            else begin
                Q_r <= Q_r;
            end
        end
    end
    assign Q = Q_r;
endmodule

/*


*/
