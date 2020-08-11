//////////////////////////////////////////////////////////////////////////////////
// Design: Test bench for UART Receiver
// Engineer: kiran
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module test_bench();
//inputs for DUT
    logic clk;
    logic rst;
    logic din;  
//output from DUT
    logic [7:0] d_out;

    top_module DUT (.*);

    always #5 clk = ~clk;

    initial
        begin
            clk = 0;
            rst = 1;
            din = 1;
            #8700;          //one clock period for the receiver
            rst = 0;
            #17400;
            din = 0;
            #8700;
            din = 1;
            #34800;         //send four 1's serially
            din = 0;
            #34800;         //send four 0's serially
            din = 1;
            #8700;          //stop
            $finish;        //dout=00001111
        end

endmodule
