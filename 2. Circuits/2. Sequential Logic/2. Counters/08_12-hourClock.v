module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [2:0] ena_hms;  // Determines when to increment hh, mm, and ss

    // Enable signals for each counter
    assign ena_hms = {(ena && (mm == 8'h59) && (ss == 8'h59)), (ena && (ss == 8'h59)), ena};   
    
    // Seconds counter (00-59)
    count60 count_ss(
        .clk(clk),
        .reset(reset),
        .ena(ena_hms[0]),
        .q(ss)
    );

    // Minutes counter (00-59)
    count60 count_mm(
        .clk(clk),
        .reset(reset),
        .ena(ena_hms[1]),
        .q(mm)
    );

    // Hour and AM/PM logic
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12;  // Reset to 12:00 AM
            pm <= 0;
        end else if (ena_hms[2] && (mm == 8'h59) && (ss == 8'h59)) begin
            if (hh == 8'h12) begin
                hh <= 8'h01;  // 12 AM/PM rolls over to 1 AM/PM
            end else if (hh == 8'h11) begin
                hh <= 8'h12;  // 11 rolls over to 12
                pm <= ~pm;    // Toggle AM/PM only when moving from 11 to 12
            end else begin
                if (hh[3:0] == 4'h9) begin
                    hh[3:0] <= 4'h0;
                    hh[7:4] <= hh[7:4] + 1'h1;
                end else begin
                    hh[3:0] <= hh[3:0] + 1'h1;
                end
            end
        end
    end

endmodule

// Count60 module for seconds and minutes (00-59)
module count60(
    input clk,
    input reset,
    input ena,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'h00;
        end else if (ena) begin
            if (q[3:0] == 4'h9) begin
                if (q[7:4] == 4'h5) begin
                    q <= 8'h00;  // Roll over to 00 when 59 is reached
                end else begin
                    q[7:4] <= q[7:4] + 1'h1;
                    q[3:0] <= 4'h0;
                end
            end else begin
                q[3:0] <= q[3:0] + 1'h1;
            end
        end
    end
endmodule
