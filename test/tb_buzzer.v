`timescale 1ns / 1ps

module tb_buzzer();
`include "tb_h_common.v"
`define press(x) begin `us(2) x = 1; `us(1) x = 0; end
    reg a_a = 0;
    reg a_b = 0;
    initial begin
        `press(a_a);
        `us(10)  `press(a_b);
        `us(4.7) `press(a_a);
        `us(120) `press(a_b);
        `us(12)  `press(a_a);
    end
    wire tr_a, tr_b;
    buzzer #(
        .FLA_CMAX(`c_us(5))
    ) x_dut(
        .tr_a(tr_a),
        .tr_b(tr_b),
        .clk(clk),
        .rst_n('b1)
    );
    button #(
        .DEB_CMAX(`c_cp(10))
    ) x_btn_a(
        .tr_btn(tr_a),
        .a_btn(a_a),
        .lock('b0),
        .clk(clk),
        .rst_n('b1)
    );
    button #(
        .DEB_CMAX(`c_cp(10))
    ) x_btn_b(
        .tr_btn(tr_b),
        .a_btn(a_b),
        .lock('b0),
        .clk(clk),
        .rst_n('b1)
    );
endmodule
