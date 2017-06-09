`timescale 1ns / 1ps

`include "h_cmax.v"

module display(seg_n, an_n, u_tot, u_cur, u_wat, fl_disp, clk_fl, clk, rst_n);
    parameter SCA_CMAX = `c_ms(1);
    output [7:0] seg_n, an_n;
    input [5:0] u_tot, u_cur, u_wat;
    input fl_disp;
    input clk_fl, clk, rst_n;
    
    wire clk_sca;
    wire [3:0] mem[7:0];
    assign mem[3] = 'b1111;
    assign mem[2] = 'b1111;
    wire [2:0] pos;
    // fwd seg_n
    assign an_n = ~((rst_n && (!fl_disp || clk_fl)) << pos);
    _disp_decimal x_dec_tot(
        .e1(mem[7]),
        .e0(mem[6]),
        .val(u_tot)
    );
    _disp_decimal x_dec_cur(
        .e1(mem[5]),
        .e0(mem[4]),
        .val(u_cur)
    );
    _disp_decimal x_dec_wat(
        .e1(mem[1]),
        .e0(mem[0]),
        .val(u_wat)
    );
    divider #(
        .CMAX(SCA_CMAX)
    ) x_divider(
        .clk_div(clk_sca),
        .clk(clk),
        .rst_n(rst_n)
    );
    _disp_counter8 x_counter(
        .cnt(pos),
        .clk(clk_sca),
        .rst_n(rst_n)
    );
    _disp_pattern x_pattern(
        .seg_n(seg_n),
        .val(mem[pos])
    );
endmodule

module _disp_decimal(e1, e0, val);
    output [3:0] e1, e0;
    input [5:0] val;
    assign e1 = val / 10;
    assign e0 = val % 10;
endmodule

module _disp_counter8(cnt, clk, rst_n);
    output reg [2:0] cnt = 'd0;
    input clk, rst_n;

    // reg cnt
    always @(posedge clk, negedge rst_n)
        if (!rst_n)
            cnt <= 'd0;
        else
            cnt <= cnt + 'd1;
endmodule

module _disp_pattern(seg_n, val);
    output reg [7:0] seg_n; // combinational
    input [3:0] val;
    always @(*)
        case (val)
            'd0:     seg_n <= 'b11000000;
            'd1:     seg_n <= 'b11111001;
            'd2:     seg_n <= 'b10100100;
            'd3:     seg_n <= 'b10110000;
            'd4:     seg_n <= 'b10011001;
            'd5:     seg_n <= 'b10010010;
            'd6:     seg_n <= 'b10000010;
            'd7:     seg_n <= 'b11111000;
            'd8:     seg_n <= 'b10000000;
            'd9:     seg_n <= 'b10010000;
            default: seg_n <= 'b11111111;
        endcase
endmodule
