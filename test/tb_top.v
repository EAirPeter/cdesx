`timescale 1ns / 1ps

module tb_top();
`include "tb_h_common.v"
`define press(x) begin `us(2) x = 1; `us(1) x = 0; end
    wire pwr;
    reg a_mod = 0;
    reg a_run = 0;
    reg a_wat = 0;
    reg a_pwr = 0;
    initial begin
        `press(a_pwr);
        repeat (6) `press(a_mod);
        repeat (4) `press(a_wat);
        `press(a_run);
        `us(20) a_mod = 1;
        `us(4)  a_wat = 1;
        `us(20) a_wat = 0;
        `us(6)  a_mod = 0;
        @(!pwr);
        `us(50) `press(a_pwr);
        repeat (3) `press(a_wat);
        `press(a_run);
        `us(40) `press(a_run);
        `us(40) `press(a_run);
        `us(20) a_mod = 1;
        `us(4)  a_wat = 1;
        `us(12) a_mod = 0;
        `us(2)  a_wat = 0;
        `press(a_run);
        `press(a_pwr);
        `us(20) a_mod = 1;
        `us(4)  a_wat = 1;
        `us(12) a_mod = 0;
        `us(4)  a_wat = 0;
        `press(a_run);
        `press(a_mod);
        `press(a_wat);
        `press(a_pwr);
        @(!pwr);
        `us(50)  `press(a_pwr);
        `us(120) `press(a_pwr);
    end
    top #(
        .TIM_UNIT(`c_us(10)),
        .END_WAIT(`c_us(100)),
        .DEB_WAIT(`c_cp(5)),
        .LCK_WAIT(`c_us(10)),
        .BUZ_INTV(`c_us(1)),
        .LED_INTV(`c_us(5)),
        .DIS_INTV(`c_cp(1))
    ) x_dut(
        .led_pwr(pwr),
        .a_mod(a_mod),
        .a_run(a_run),
        .a_wat(a_wat),
        .a_pwr(a_pwr),
        .clk(clk)
    );
endmodule
