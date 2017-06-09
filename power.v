`timescale 1ns / 1ps

`include "h_cmax.v"

module power(rst_n, tr_pwr, led_pwr, a_pwr, main_done, lock, clk);
    parameter TIM_CMAX = `c_ms(2000);
    parameter DEB_CMAX = `c_ms(5);
    output reg rst_n = 'b0;
    output tr_pwr;
    output led_pwr;
    input a_pwr;
    input main_done;
    input lock, clk;

    // power button with lock
    reg r_lock = 'b0;
    wire tm_done;
    wire tm_clr = !pwr;
    // forcing poweroff
    reg r_rst_n = 'b0;
    wire pwr, pe_pwr, ne_pwr;
    // reg rst_n
    assign tr_pwr = ne_pwr && !r_lock && !lock && r_rst_n == rst_n;
    assign led_pwr = rst_n;
    always @(posedge clk)
        if (tm_done || main_done)
            rst_n <= 'b0;
        else if (!rst_n && tr_pwr)
            rst_n <= 'b1;
        else if (pe_pwr)
            r_rst_n <= rst_n;
    always @(posedge clk, negedge rst_n)
        if (!rst_n)
            r_lock <= 'b0;
        else if (pe_pwr)
            r_lock <= lock;
    timer #(
        .CMAX(TIM_CMAX)
    ) x_timer(
        .done(tm_done),
        .clr(tm_clr),
        .clk(clk),
        .rst_n(rst_n)
    );
    debouncer #(
        .DEB_CMAX(DEB_CMAX)
    ) x_deb_pwr(
        .sig(pwr),
        .pe_sig(pe_pwr),
        .ne_sig(ne_pwr),
        .a_sig(a_pwr),
        .clk(clk),
        .rst_n('b1)
    );
endmodule
