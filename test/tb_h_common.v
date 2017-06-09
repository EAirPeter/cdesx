`include "../h_cmax.v"

`define cp(x) #((x) * 10)
`define ns(x) #(x)
`define us(x) #((x) * 1000)
`define ms(x) #((x) * 1000_000)

    reg clk = 'b1;
    always #5 clk <= !clk;
