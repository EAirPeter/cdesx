`timescale 1ns / 1ps

`include "h_cmax.v"

module button(tr_btn, a_btn, lock, clk, rst_n);
    parameter DEB_CMAX = `c_ms(5);
    output tr_btn;
    input a_btn;
    input lock, clk, rst_n;

    reg r_lock = 'b0;
    wire pe_btn, ne_btn;
    assign tr_btn = ne_btn && !r_lock && !lock;
    always @(posedge clk)
        if (!rst_n)
            r_lock <= 'b0;
        else if (pe_btn)
            r_lock <= lock;
    debouncer #(
        .DEB_CMAX(DEB_CMAX)
    ) x_deb(
        .sig(),
        .pe_sig(pe_btn),
        .ne_sig(ne_btn),
        .a_sig(a_btn),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule
