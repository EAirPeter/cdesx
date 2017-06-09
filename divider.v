`timescale 1ns / 1ps

`include "h_cmax.v"

module divider(clk_div, clk, rst_n);
`include "h_cbit.v"
    parameter CMAX = `c_ms(500);
    localparam CBIT = cbit(CMAX);
    output reg clk_div = 'b1;
    input clk, rst_n;

    reg [CBIT - 1:0] cnt = 'd0;
    // reg clk_div
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            clk_div <= 'b1;
            cnt <= 'd0;
        end
        else if (cnt == CMAX) begin
            clk_div <= !clk_div;
            cnt <= 'd1;
        end
        else
            cnt <= cnt + 'd1;
endmodule
