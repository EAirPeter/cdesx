`timescale 1ns / 1ps

`include "h_cmax.v"

module timer_nested(done, rema, init, pau, clr, clk, rst_n);
    parameter CBIT = 6;
    parameter INNER_CMAX = `c_ms(1000);
    output done;
    output reg [CBIT - 1:0] rema = 'd0;
    input [CBIT - 1:0] init;
    input pau, clr, clk, rst_n;

    wire ok = !rema;
    wire tm_done;
    reg r_tm_done = 'b0;
    assign done = r_tm_done && ok;
    // reg rema
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            rema <= 'd0;
            r_tm_done <= 'b0;
        end
        else if (!pau) begin
            r_tm_done <= tm_done;
            if (clr)
                rema <= init;
            else if (tm_done)
                rema <= (ok ? init : rema) - 1;
        end
    timer #(
        .CMAX(INNER_CMAX)
    ) x_timer(
        .done(tm_done),
        .clr(clr),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule
