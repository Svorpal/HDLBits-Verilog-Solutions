module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    localparam LEFT = 0, RIGHT = 1, FALL_LEFT = 2, FALL_RIGHT = 3, DIG_LEFT = 4, DIG_RIGHT = 5;
    reg [2:0] state, next;
    
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= LEFT;
        end
        else begin
            state <= next;
        end
    end
    
    always @(*) begin
        case(state) 
            LEFT: next = (ground) ? ((dig) ? DIG_LEFT : ((bump_left) ? RIGHT: LEFT)) : FALL_LEFT;
            RIGHT: next = (ground) ? ((dig) ? DIG_RIGHT : ((bump_right) ? LEFT: RIGHT)) : FALL_RIGHT;
            DIG_LEFT: next = (ground) ? DIG_LEFT : FALL_LEFT;
            DIG_RIGHT: next = (ground) ? DIG_RIGHT : FALL_RIGHT;
            FALL_LEFT: next = (ground) ? LEFT: FALL_LEFT;
            FALL_RIGHT: next = (ground) ? RIGHT : FALL_RIGHT;
        endcase
    end
    
    always @(*) begin
        walk_left = (state == LEFT);
        walk_right = (state == RIGHT);
        aaah = (state == FALL_LEFT) || (state == FALL_RIGHT);
        digging = (state == DIG_LEFT) || (state == DIG_RIGHT);
    end
endmodule
