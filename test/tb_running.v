`timescale 1ns / 1ps

module tb_running();
`include "tb_h_common.v"
    reg a_pau = 0;
    reg a_clr = 1;
    reg [2:0] init = 'b111;
    reg [5:0] u_wat = 3;
    initial begin
        `us(1)   a_clr = 0;
        `us(800) a_clr = 1;
        `us(1)   init = 'b011;
        `us(1)   a_clr = 0;
        `us(82)  a_pau = 1;
        `us(800) a_pau = 0;
    end
    wire pau, clr;
    run_mode #(
        .TIM_CMAX(`c_us(10))
    ) x_dut(
        .u_wat(u_wat),
        .init(init),
        .pau(pau),
        .clr(clr),
        .clk(clk),
        .rst_n('b1)
    );
    debouncer #(
        .DEB_CMAX(`c_cp(10))
    ) x_deb_pau(
        .sig(pau),
        .a_sig(a_pau),
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
