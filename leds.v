`timescale 1ns / 1ps

`include "h_cmax.v"

module leds(
    led_dry, led_rin, led_was,
    led_fil, led_spi, led_dra,
    ld_drw, fl_drw, ld_fsd,
    clk, rst_n
);
    parameter FLA_CMAX = `c_ms(500);
    output led_dry, led_rin, led_was;
    output led_fil, led_spi, led_dra;
    input [2:0] ld_drw, fl_drw, ld_fsd;
    input clk, rst_n;

    wire clk_div;
    // fwd led_dry
    // fwd led_rin
    // fwd led_was
    // fwd led_fil
    // fwd led_fil
    // fwd led_spi
    // fwd led_dra
    divider #(
        .CMAX(FLA_CMAX)
    ) x_divider(
        .clk_div(clk_div),
        .clk(clk),
        .rst_n(rst_n)
    );
    _led x_led_dry(
        .led(led_dry),
        .ld(ld_drw[2]),
        .fl(fl_drw[2]),
        .clk(clk_div),
        .rst_n(rst_n)
    );
    _led x_led_rin(
        .led(led_rin),
        .ld(ld_drw[1]),
        .fl(fl_drw[1]),
        .clk(clk_div),
        .rst_n(rst_n)
    );
    _led x_led_was(
        .led(led_was),
        .ld(ld_drw[0]),
        .fl(fl_drw[0]),
        .clk(clk_div),
        .rst_n(rst_n)
    );
    _led x_led_fil(
        .led(led_fil),
        .ld(ld_fsd[2]),
        .fl('b0),
        .clk(clk_div),
        .rst_n(rst_n)
    );
    _led x_led_spi(
        .led(led_spi),
        .ld(ld_fsd[1]),
        .fl('b0),
        .clk(clk_div),
        .rst_n(rst_n)
    );
    _led x_led_dra(
        .led(led_dra),
        .ld(ld_fsd[0]),
        .fl('b0),
        .clk(clk_div),
        .rst_n(rst_n)
    );
endmodule

module _led(led, ld, fl, clk, rst_n);
    output led;
    input ld, fl;
    input clk, rst_n;

    assign led = rst_n && (fl ? clk : ld);
endmodule
