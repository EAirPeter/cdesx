`timescale 1ns / 1ps

`include "h_cmax.v"

module buzzer(buz, tr_a, tr_b, clk, rst_n);
    parameter FLA_CMAX = `c_ms(100);
    output buz;
    input tr_a, tr_b;
    input clk, rst_n;

    wire buz_a, buz_b;
    assign buz = buz_a || buz_b;
    _buz_a #(
        .FLA_CMAX(FLA_CMAX)
    ) x_buz_a(
        .buz(buz_a),
        .tr_sig(tr_a),
        .clk(clk),
        .rst_n(rst_n)
    );
    _buz_b #(
        .FLA_CMAX(FLA_CMAX)
    ) x_buz_b(
        .buz(buz_b),
        .tr_sig(tr_b),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule

module _buz_a(buz, tr_sig, clk, rst_n);
    parameter FLA_CMAX = `c_ms(100);
    output buz;
    input tr_sig;
    input clk, rst_n;

    //   0  1  0
    //   >  +  -
    reg st = 'd0;
    wire tm_done;
    wire tm_clr = tr_sig;
    assign buz = st;
    always @(posedge clk, negedge rst_n)
        if (!rst_n)
            st <= 'd0;
        else if (tr_sig)
            st <= 'd1;
        else if (tm_done && st)
            st <= 'd0;
    timer #(
        .CMAX(FLA_CMAX)
    ) x_timer(
        .done(tm_done),
        .clr(tm_clr),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule

module _buz_b(buz, tr_sig, clk, rst_n);
    parameter FLA_CMAX = `c_ms(100);
    output buz;
    input tr_sig;
    input clk, rst_n;

    //   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21  0
    //   >  +  -  +  -  +  -  -  -  +  -  +  -  +  -  -  -  +  -  +  -  +  -
    reg [4:0] st = 'd0;
    wire tm_done;
    wire tm_clr = tr_sig;
    assign buz = st[0] && st != 7 && st != 15;
    always @(posedge clk, negedge rst_n)
        if (!rst_n)
            st <= 'd0;
        else if (tr_sig)
            st <= 'd1;
        else if (tm_done && st)
            st <= st == 'd21 ? 'd0 : st + 'd1;
    timer #(
        .CMAX(FLA_CMAX)
    ) x_timer(
        .done(tm_done),
        .clr(tm_clr),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule
