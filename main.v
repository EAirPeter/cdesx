`timescale 1ns / 1ps

`include "h_cmax.v"

module main(
    done, prog_done,
    ld_drw, fl_drw, ld_fsd,
    u_tot, u_cur, u_wat,
    tr_mod, tr_run, tr_wat,
    clk, rst_n
);
    parameter TIM_CMAX = `c_ms(1000);
    parameter END_CMAX = `c_s(10);
    output done, prog_done;
    output [2:0] ld_drw, fl_drw;
    output [2:0] ld_fsd;
    output [5:0] u_tot, u_cur, u_wat;
    input tr_mod, tr_run, tr_wat;
    input clk, rst_n;

    wire tr_set = tr_mod || tr_wat;

    reg [1:0] st = 'b00;
    wire started = st[0];
    wire se_done;
    wire [2:0] se_ld_drw;
    wire [5:0] se_u_tot, se_u_cur, se_u_wat;
    wire [2:0] se_mode;
    wire se_clr = started;
    wire [2:0] ru_ld_drw, ru_fl_drw;
    wire [2:0] ru_ld_fsd;
    wire [5:0] ru_u_tot, ru_u_cur;
    wire ru_done;
    wire ru_pau = st == 'b11;
    wire ru_clr = !started;
    wire tm_done;
    wire tm_clr = st != 'b10;
    assign done = st == 'b10 && tm_done;
    // fwd prog_done
    assign ld_drw = started ? ru_ld_drw : se_ld_drw;
    assign fl_drw = started ? ru_fl_drw : 'b000;
    assign ld_fsd = started ? ru_ld_fsd : 'b000;
    assign u_tot = started ? ru_u_tot : se_u_tot;
    assign u_cur = started ? ru_u_cur : se_u_cur;
    assign u_wat = se_u_wat;
    always @(posedge clk, negedge rst_n)
        if (!rst_n)
            st <= 'b00;
        else case (st)
            'b00: // setting
                if (se_done)
                    st <= 'b01;
            'b01: // running
                if (ru_done)
                    st <= 'b10;
                else if (tr_run)
                    st <= 'b11;
            'b10: // waiting_end
                if (tr_set)
                    st <= 'b00;
            'b11: // paused
                if (tr_run)
                    st <= 'b01;
                else if (tr_set)
                    st <= 'b00;
        endcase
    setting x_setting(
        .done(se_done),
        .mode(se_mode),
        .ld_drw(se_ld_drw),
        .u_tot(se_u_tot),
        .u_cur(se_u_cur),
        .u_wat(se_u_wat),
        .tr_mod(tr_mod),
        .tr_run(tr_run),
        .tr_wat(tr_wat),
        .clr(se_clr),
        .clk(clk),
        .rst_n(rst_n)
    );
    run_mode #(
        .TIM_CMAX(TIM_CMAX)
    ) x_run_mode(
        .done(ru_done),
        .prog_done(prog_done),
        .ld_drw(ru_ld_drw),
        .fl_drw(ru_fl_drw),
        .ld_fsd(ru_ld_fsd),
        .u_tot(ru_u_tot),
        .u_cur(ru_u_cur),
        .u_wat(se_u_wat),
        .init(se_mode),
        .pau(ru_pau),
        .clr(ru_clr),
        .clk(clk),
        .rst_n(rst_n)
    );
    timer #(
        .CMAX(END_CMAX)
    ) x_timer(
        .done(tm_done),
        .clr(tm_clr),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule
