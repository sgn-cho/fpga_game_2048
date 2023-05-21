`timescale 1ns/1ns

module xor_shift_tb();
    reg[31:0] seed;
    wire[3:0] rand;
    reg clk, rst;

    xor_shift_sync xor_module(
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .rand(rand)
    );

    initial begin
        seed = 32'h49582049;
        rst = 1'b0;
        clk = 1'b0;

        #40 rst = 1'b1;
    end

    initial begin
        forever begin
            #10 clk = !clk;
        end
    end

endmodule