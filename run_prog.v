`timescale 1ns / 1ps

`include "h_cmax.v"
`include "h_time.v"

module run_prog(
    done,
    ld_fsd, u_cur,
    u_wat, init, pau, clr, clk, rst_n
);
    parameter TIM_CMAX = `c_ms(1000);
    output done;
    output [2:0] ld_fsd;
    output [5:0] u_cur;
    input [5:0] u_wat;
    input [4:0] init;
    input pau, clr, clk, rst_n;

    reg[4:0] st = 'b00000;
    wire [4:0] lowb = st & -st;
    wire [4:0] srem = st ^ lowb;
    reg [5:0] tm_init_mul; // combinational
    always @(*)
        case (lowb)
            'b00001: tm_init_mul <= `TC_DRA;
            'b00010: tm_init_mul <= `TC_SPI;
            'b00100: tm_init_mul <= `TC_FIL;
            'b01000: tm_init_mul <= `TC_WAS;
            'b10000: tm_init_mul <= `TC_RIN;
            default: tm_init_mul <= 'd0;
        endcase
    wire tm_done;
    reg r_tm_done = 'b0;
    wire [5:0] tm_rema;
    wire [5:0] tm_init = u_wat * tm_init_mul;
    reg r_clr = 'b0;
    wire tm_clr = r_clr || r_tm_done;
    assign done = !st && r_tm_done;
    assign ld_fsd = lowb[2:0];
    assign u_cur = tm_rema + u_wat * (
        (srem[0] ? `TC_DRA : 0) +
        (srem[1] ? `TC_SPI : 0) +
        (srem[2] ? `TC_FIL : 0) +
        (srem[3] ? `TC_WAS : 0) +
        (srem[4] ? `TC_RIN : 0)
    );
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            st <= 'b00000;
            r_tm_done <= 'b0;
            r_clr <= 'b0;
        end
        else if (!pau) begin
            r_tm_done <= tm_done;
            r_clr <= clr;
            if (clr)
                st <= init;
            else if (tm_done)
                st <= srem;
        end
    timer_nested #(
        .CBIT(6),
        .INNER_CMAX(TIM_CMAX)
    ) x_timer(
        .done(tm_done),
        .rema(tm_rema),
        .init(tm_init),
        .pau(pau),
        .clr(tm_clr),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule
