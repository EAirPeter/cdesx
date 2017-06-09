`timescale 1ns / 1ps

module tb_debouncer();
`include "tb_h_common.v"
    reg a_sig = 'b0;
    initial begin
        `us(10)   a_sig = 1;
        `us(7)    a_sig = 0;
        `us(12)   a_sig = 1;
        `us(43)   a_sig = 0;
        `us(9.9)  a_sig = 1;
        `us(72)   a_sig = 0;
        `us(10.1) a_sig = 1;
        `us(10.1) a_sig = 0;
    end
    debouncer #(
        .DEB_CMAX(`c_us(10))
    ) x_dut(
        .a_sig(a_sig),
        .clk(clk),
        .rst_n('b1)
    );
endmodule
