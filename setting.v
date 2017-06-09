`timescale 1ns / 1ps

`include "h_time.v"

module setting(
    done, mode,
    ld_drw,
    u_tot, u_cur, u_wat,
    tr_mod, tr_run, tr_wat,
    clr, clk, rst_n
);
    output done;
    output reg [2:0] mode = 'b111;
    output [2:0] ld_drw;
    output [5:0] u_tot, u_cur;
    output reg [5:0] u_wat = 'd3;
    input tr_mod, tr_run, tr_wat;
    input clr, clk, rst_n;

    // drw =>   w =>  rw =>  r  => dr  => d   => drw
    // 111    001    011    010    110    100    111
    assign done = tr_run;
    // reg mode
    assign ld_drw = mode;
    assign u_tot = u_wat * (
        (mode[0] ? `TG_WAS : 0) +
        (mode[1] ? `TG_RIN : 0) +
        (mode[2] ? `TG_DRY : 0)
    );
    assign u_cur = u_wat * (
        mode[0] ? `TG_WAS :
        mode[1] ? `TG_RIN :
        mode[2] ? `TG_DRY : 0
    );
    // reg u_wat
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            mode <= 'b111;
            u_wat <= 'd3;
        end
        else if (clr)
            mode <= 'b111;
        else if (tr_mod)
            case (mode)
                'b111:   mode <= 'b001;
                'b001:   mode <= 'b011;
                'b011:   mode <= 'b010;
                'b010:   mode <= 'b110;
                'b110:   mode <= 'b100;
                'b100:   mode <= 'b111;
                default: mode <= 'b111;
            endcase
        else if (tr_wat)
            u_wat <= u_wat == 'd5 ? 'd2 : u_wat + 'd1;
endmodule
