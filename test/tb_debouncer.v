`timescale 1ns / 1ps

module tb_debouncer();
`include "tb_h_common.v"
    reg a_sig = 'b0;
    initial begin
        `cp(1.3)  a_sig = 1;
        `cp(10.1) a_sig = 0;
        `cp(9.9)  a_sig = 1;
        `cp(2.8)  a_sig = 0;
        `cp(10.1) a_sig = 1;
        `cp(9.9)  a_sig = 0;
    end
    debouncer #(
        .DEB_CMAX(`c_cp(10))
    ) x_dut(
        .a_sig(a_sig),
        .clk(clk),
        .rst_n('b1)
    );
endmodule
