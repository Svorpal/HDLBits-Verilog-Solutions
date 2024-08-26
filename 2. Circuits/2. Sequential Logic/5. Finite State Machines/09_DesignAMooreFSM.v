module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 

    localparam A = 3'd0,   // water level below S1
                B0 = 3'd1, // water level between S1 and S2, prev level was higher 
                B1 = 3'd2, // water level between S1 and S2, prev level was lower
                C0 = 3'd3, // water level between S2 and S3, prev level was higher 
                C1 = 3'd4, // water level between S2 and S3, prev level was lower
                D = 3'd5;  // water level below S3
    reg [2:0] state, next_state;
    
    always @(posedge clk) begin
        if(reset) begin
            state <= A;
        end 
        else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        case(state)
            A: next_state  = (s[1]) ? B1 : A;
            B0: next_state = (s[2]) ? C1: ((s[1])? B0: A);
            B1: next_state = (s[2]) ? C1 : ((s[1])? B1: A);
            C0: next_state = (s[3]) ? D : ((s[2])? C0: B0);
            C1: next_state = (s[3]) ? D : ((s[2])? C1: B0);
            D: next_state =  (s[3])? D : C0;
            default: next_state = 3'bxxx;
        endcase
    end
    
    always @(*) begin
        case(state) 
            A  : {fr3, fr2, fr1, dfr} = 4'b1111;
            B0 : {fr3, fr2, fr1, dfr} = 4'b0111;
            B1 : {fr3, fr2, fr1, dfr} = 4'b0110;
            C0 : {fr3, fr2, fr1, dfr} = 4'b0011;
            C1 : {fr3, fr2, fr1, dfr} = 4'b0010;
            D  : {fr3, fr2, fr1, dfr} = 4'b0000;
			default : {fr3, fr2, fr1, dfr} = 4'bxxxx;
        endcase
    end
    
endmodule
