//////////////////////////////////////////////////////////////////////////////////////////////////
// Design Name: UART Receiver with Oversampling
// Engineer: kiran
// Reference: FPGA Prototyping by Verilog by Pong P. Chu
//////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module uart_rx(clk, rst, tick, din, d_out);

    input  logic clk;
    input  logic rst;
    input  logic tick;
    input  logic din;

    output logic [7:0] d_out;

    typedef enum logic[1:0] {idle,start, receive, stop} FSM;
    FSM state, nxt_state;

    logic [3:0]ov_reg, ov_nxt;
    logic [3:0] d_reg,  d_nxt;

    logic [7:0]data_reg, data_nxt;


    always_ff@(posedge clk, posedge rst)
        begin
            if(rst)begin
                state <= idle;
                ov_reg<= 0;
                d_reg <= 0;
                data_reg<= 0;
            end else begin
                state <= nxt_state;
                ov_reg<= ov_nxt;
                d_reg <= d_nxt;
                data_reg<=data_nxt;
            end
        end

    always@*
        begin
            nxt_state = state;
            ov_nxt    = ov_reg;
            d_nxt     = d_reg;
            data_nxt  = data_reg;
            case(state)
                idle    :   begin
                                if(din==0)begin
                                    nxt_state = start;
                                    ov_nxt    = 0;
                                end else begin
                                    nxt_state = idle;
                                end
                            end
                start   :   begin
                                if(tick)begin
                                    ov_nxt = ov_reg + 1;
                                    if(ov_reg == 8)begin
                                        nxt_state = receive;
//                                        ov_nxt    = 0;
                                        d_nxt     = 0;
                                    end
                                end else begin
                                    nxt_state = start;
                                end
                            end
                receive :   begin
                                if(tick)begin
                                    if(ov_reg == 8)begin
                                        data_nxt = {din, data_reg[7:1]};
                                        if(d_reg==7)
                                            nxt_state = stop;
                                        else
                                            d_nxt = d_reg + 1;
                                    end
                                end else begin
                                    ov_nxt = ov_reg + 1;
                                end
                            end
                stop    :   begin
                                if(tick)begin
                                    if(ov_reg == 8)
                                        nxt_state = idle;
                                    else
                                        nxt_state = stop;
                                end else begin
                                    ov_nxt = ov_reg +1;
                                end
                            end
            endcase
        end

        assign d_out = data_reg;
endmodule
