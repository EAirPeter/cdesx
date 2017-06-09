`timescale 1ns / 1ps

`include "h_cmax.v"

module debouncer(sig, pe_sig, ne_sig, a_sig, clk, rst_n);
    parameter DEB_CMAX = `c_ms(5);
    output reg sig = 'b0;
    output pe_sig, ne_sig;
    input a_sig;
    input clk, rst_n;

    reg r_a_sig = 'b0;
    wire tm_done;
    wire tm_clr = sig == r_a_sig;
    // reg sig
    assign pe_sig = tm_done && !sig;
    assign ne_sig = tm_done && sig;
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            sig <= 'b0;
            r_a_sig <= 'b0;
        end
        else begin
            r_a_sig <= a_sig;
            if (tm_done)
                sig <= !sig;
        end
    timer #(
        .CMAX(DEB_CMAX)
    ) x_timer(
        .done(tm_done),
        .clr(tm_clr),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule
