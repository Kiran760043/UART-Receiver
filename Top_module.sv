////////////////////////////////////////////////////////////////////////////////////////////////////
// Design Name: TOP MODULE for UART Receiver 
// Engineer: kiran
////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module top_module(clk, rst, din, d_out);

    input  logic clk;
    input  logic rst;
    input  logic din;
    output logic [7:0] d_out;

    logic b_clk;
    logic tick;

    clk_gen   TK  (.*);
    uart_rx  UART (.*);

endmodule
