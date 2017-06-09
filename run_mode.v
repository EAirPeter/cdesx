`timescale 1ns / 1ps

`include "h_cmax.v"
`include "h_time.v"

module run_mode(
    done, prog_done,
    ld_drw, fl_drw, ld_fsd,
    u_tot, u_cur,
    u_wat, init, pau, clr, clk, rst_n
);
    parameter TIM_CMAX = `c_ms(1000);
    output done, prog_done;
    output [2:0] ld_drw, fl_drw;
    output [2:0] ld_fsd;
    output [5:0] u_tot, u_cur;
    input [5:0] u_wat;
    input [2:0] init;
    input pau, clr, clk, rst_n;

    reg [2:0] st = 'b000;
    wire [2:0] lowb = st & -st;
    wire [2:0] srem = st ^ lowb;
    reg r_prog_done = 'b0;
    reg [4:0] prog_init; // combinational
    always @(*)
        case (lowb)
            'b001:   prog_init <= 'b01100;
            'b010:   prog_init <= 'b10111;
            'b100:   prog_init <= 'b00011;
            default: prog_init <= 'b00000;
        endcase
    reg r_clr = 'b0;
    wire prog_clr = r_clr || r_prog_done;
    assign done = !st && r_prog_done;
    // fwd prog_done
    assign ld_drw = st;
    assign fl_drw = lowb;
    // fwd ld_fsd
    assign u_tot = u_cur + u_wat * (
        (srem[0] ? `TG_WAS : 0) +
        (srem[1] ? `TG_RIN : 0) +
        (srem[2] ? `TG_DRY : 0)
    );
    // fwd u_cur
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            st <= 'b000;
            r_prog_done <= 'b0;
            r_clr <= 'b0;
        end
        else if (!pau) begin
            r_prog_done <= prog_done;
            r_clr <= clr;
            if (clr) begin
                st <= init;
            end
            else if (prog_done)
                st <= srem;
        end
    run_prog #(
        .TIM_CMAX(TIM_CMAX)
    ) x_run_prog(
        .done(prog_done),
        .ld_fsd(ld_fsd),
        .u_cur(u_cur),
        .u_wat(u_wat),
        .init(prog_init),
        .pau(pau),
        .clr(prog_clr),
        .clk(clk),
        .rst_n(rst_n)
    );
endmodule
