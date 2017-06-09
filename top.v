`timescale 1ns / 1ps

`include "h_cmax.v"

module top(
    buz,
    led_pwr, led_lck,
    led_dry, led_rin, led_was,
    led_fil, led_spi, led_dra,
    seg_n, an_n,
    a_mod, a_run, a_wat, a_pwr,
    clk
);
    parameter TIM_UNIT = `c_ms(1000);
    parameter END_WAIT = `c_s(10);
    parameter DEB_WAIT = `c_ms(5);
    parameter LCK_WAIT = `c_ms(1000);
    parameter BUZ_INTV = `c_ms(100);
    parameter LED_INTV = `c_ms(500);
    parameter DIS_INTV = `c_ms(1);
    output buz;
    output led_pwr, led_lck;
    output led_dry, led_rin, led_was;
    output led_fil, led_spi, led_dra;
    output [7:0] seg_n, an_n;
    input a_mod, a_run, a_wat, a_pwr;
    input clk;

    wire a_lck = a_mod && a_wat;

    wire [2:0] ld_drw, fl_drw, ld_fsd;
    wire [5:0] u_tot, u_cur, u_wat;
    wire main_done, prog_done;
    wire rst_n;
    wire lock;
    wire tr_lock, tr_mod, tr_run, tr_wat;
    wire buz_tr_a = tr_lock || tr_mod || tr_run || tr_wat;
    wire buz_tr_b = prog_done;
    // fwd buz
    // fwd led_pwr
    // fwd led_lck
    // fwd led_dry
    // fwd led_rin
    // fwd led_was
    // fwd led_fil
    // fwd led_spi
    // fwd led_spi
    // fwd led_dra
    // fwd seg_n
    // fwd an_n
    main #(
        .TIM_CMAX(TIM_UNIT),
        .END_CMAX(END_WAIT)
    ) x_main(
        .done(main_done),
        .prog_done(prog_done),
        .ld_drw(ld_drw),
        .fl_drw(fl_drw),
        .ld_fsd(ld_fsd),
        .u_tot(u_tot),
        .u_cur(u_cur),
        .u_wat(u_wat),
        .tr_mod(tr_mod),
        .tr_run(tr_run),
        .tr_wat(tr_wat),
        .clk(clk),
        .rst_n(rst_n)
    );
    power #(
        .DEB_CMAX(DEB_WAIT)
    ) x_power(
        .rst_n(rst_n),
        .led_pwr(led_pwr),
        .a_pwr(a_pwr),
        .main_done(main_done),
        .lock(lock),
        .clk(clk)
    );
    protector #(
        .TIM_CMAX(LCK_WAIT),
        .DEB_CMAX(DEB_WAIT)
    ) x_protector(
        .lock(lock),
        .tr_lock(tr_lock),
        .led_lck(led_lck),
        .a_lck(a_lck),
        .clk(clk),
        .rst_n(rst_n)
    );
    button #(
        .DEB_CMAX(DEB_WAIT)
    ) x_deb_mod(
        .tr_btn(tr_mod),
        .a_btn(a_mod),
        .lock(lock),
        .clk(clk),
        .rst_n(rst_n)
    );
    button #(
        .DEB_CMAX(DEB_WAIT)
    ) x_deb_run(
        .tr_btn(tr_run),
        .a_btn(a_run),
        .lock(lock),
        .clk(clk),
        .rst_n(rst_n)
    );
    button #(
        .DEB_CMAX(DEB_WAIT)
    ) x_deb_wat(
        .tr_btn(tr_wat),
        .a_btn(a_wat),
        .lock(lock),
        .clk(clk),
        .rst_n(rst_n)
    );
    buzzer #(
        .FLA_CMAX(BUZ_INTV)
    ) x_buzzer(
        .buz(buz),
        .tr_a(buz_tr_a),
        .tr_b(buz_tr_b),
        .clk(clk),
        .rst_n(rst_n)
    );
    leds #(
        .FLA_CMAX(LED_INTV)
    ) x_leds(
        .led_dry(led_dry),
        .led_rin(led_rin),
        .led_was(led_was),
        .led_fil(led_fil),
        .led_spi(led_spi),
        .led_dra(led_dra),
        .ld_drw(ld_drw),
        .fl_drw(fl_drw),
        .ld_fsd(ld_fsd),
        .clk(clk),
        .rst_n(rst_n)
    );
    display #(
        .SCA_CMAX(DIS_INTV)
    ) x_display(
        .seg_n(seg_n),
        .an_n(an_n),
        .u_tot(u_tot),
        .u_cur(u_cur),
        .u_wat(u_wat),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule
