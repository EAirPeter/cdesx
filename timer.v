`timescale 1ns / 1ps

`include "h_cmax.v"

module timer(done, clr, clk, rst_n);
`include "h_cbit.v"
    parameter CMAX = `c_ms(1000);
    localparam CBIT = cbit(CMAX);
    output done;
    input clr, clk, rst_n;

    reg [CBIT - 1:0] cnt = 'd0;
    assign done = cnt == CMAX;
    always @(posedge clk, negedge rst_n)
        if (!rst_n)
            cnt <= 'd0;
        else if (clr)
            cnt <= 'd0;
        else
            cnt <= done ? 'd1 : cnt + 'd1;
endmodule
