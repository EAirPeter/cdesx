`timescale 1ns / 1ps

module tb_setting();
`include "tb_h_common.v"
`define press(x) begin `us(2) x = 1; `us(1) x = 0; end
    reg a_mod = 0;
    reg a_run = 0;
    reg a_wat = 0;
    reg a_clr = 0;
    initial begin
        `press(a_clr);
        repeat (6) `press(a_mod);
        repeat (4) `press(a_wat);
        `us(10) `press(a_clr);
        `press(a_wat);
        `press(a_mod);
        `us(10) a_clr = 1;
    end
    wire tr_mod, tr_run, tr_wat, clr;
    setting x_dut(
        .tr_mod(tr_mod),
        .tr_run(tr_run),
        .tr_wat(tr_wat),
        .clr(clr),
        .clk(clk),
        .rst_n('b1)
    );
    button #(
        .DEB_CMAX(`c_cp(10))
    ) x_btn_mod(
        .tr_btn(tr_mod),
        .a_btn(a_mod),
        .lock('b0),
        .clk(clk),
        .rst_n('b1)
    );
    button #(
        .DEB_CMAX(`c_cp(10))
    ) x_btn_run(
        .tr_btn(tr_run),
        .a_btn(a_run),
        .lock('b0),
        .clk(clk),
        .rst_n('b1)
    );
    button #(
        .DEB_CMAX(`c_cp(10))
    ) x_btn_wat(
        .tr_btn(tr_wat),
        .a_btn(a_wat),
        .lock('b0),
        .clk(clk),
        .rst_n('b1)
    );
    debouncer #(
        .DEB_CMAX(`c_cp(10))
    ) x_deb_clr(
        .sig(clr),
        .a_sig(a_clr),
        .clk(clk),
        .rst_n('b1)
    );
endmodule
