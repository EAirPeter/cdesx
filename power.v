`timescale 1ns / 1ps

`include "h_cmax.v"

module power(rst_n, led_pwr, a_pwr, main_done, lock, clk);
    parameter DEB_CMAX = `c_ms(5);
    output reg rst_n = 'b0;
    output led_pwr;
    input a_pwr;
    input main_done;
    input lock, clk;

    wire tr_pwr;
    // reg rst_n
    assign led_pwr = rst_n;
    always @(posedge clk)
        if (tr_pwr)
            rst_n <= !rst_n;
        else if (main_done)
            rst_n <= 'b0;
    button #(
        .DEB_CMAX(DEB_CMAX)
    ) x_btn_pwr(
        .tr_btn(tr_pwr),
        .a_btn(a_pwr),
        .lock(lock),
        .clk(clk),
        .rst_n('b1)
    );
endmodule
