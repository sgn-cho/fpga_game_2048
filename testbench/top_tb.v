`timescale 1ns/1ns

module top_tb();
    reg clk, rst;
    reg[3:0] button_press;
    
    wire[3:0] value;
    wire vga_vs;
    wire vga_hs;
    wire[2:0] state;

    top_module test(
        .clk_65(clk),
        .rst(rst),
        .button_press(button_press),
        .value(value),
        .vga_vs(vga_vs),
        .vga_hs(vga_hs),
        .state(state)
    );

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        button_press = 4'b0000;
    end

    initial begin
        forever begin
            #10 clk = ~clk;
        end
    end

    initial begin
        #50 rst = 1'b1;
        #150 button_press = 4'b1000;
        #20 button_press = 4'b0000;
        #600 button_press = 4'b00001;
        #20 button_press = 4'b0000;
    end

endmodule