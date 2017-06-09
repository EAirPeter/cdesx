`timescale 1ns / 1ps

`include "h_cmax.v"

module protector(lock, tr_lck, led_lck, a_lck, clk, rst_n);
    parameter TIM_CMAX = `c_ms(1000);
    parameter DEB_CMAX = `c_ms(5);
    output reg lock = 'b0;
    output tr_lck;
    output led_lck;
    input a_lck;
    input clk, rst_n;

    reg r_lock = 'b0;
    wire tm_done;
    wire lck, pe_lck;
    wire tm_clr = !lck || r_lock != lock;
    // reg lock
    assign tr_lck = tm_done;
    assign led_lck = lock;
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            lock <= 'b0;
            r_lock <= 'b0;
        end
        else if (tm_done)
            lock <= !lock;
        else if (pe_lck)
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
    ) x_deb_lck(
        .sig(lck),
        .pe_sig(pe_lck),
        .ne_sig(),
        .a_sig(a_lck),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule
