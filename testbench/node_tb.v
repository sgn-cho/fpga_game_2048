`timescale 1ns/1ns

module node_tb();

    reg clk, rst;

    reg[3:0] ready_from;

    reg preset;
    reg[3:0] value_preset_1;
    reg[3:0] value_preset_2;
    reg[3:0] value_preset_3;

    wire[3:0] node_1_value;
    wire[3:0] node_1_en;
    wire[3:0] node_1_ready;
    
    wire[3:0] node_2_value;
    wire[3:0] node_2_en;
    wire[3:0] node_2_exist;
    wire[3:0] node_2_ready;

    wire[3:0] node_3_value;
    wire[3:0] node_3_en;
    wire[3:0] node_3_exist;
    wire[3:0] node_3_ready;

    node node_1(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset),
        .en_from(4'b000),
        .ready_from(ready_from),
        .exist_from({1'b0, node_2_exist[2], 2'b00}),
        .value_from({4'b0000, node_2_value, 8'b00000000}),
        .value_from_preset(value_preset_1),
        .current_value(node_1_value),
        .en_to(node_1_en),
        .ready_to(node_1_ready),
        .exist_to()
    );

    node node_2(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset),
        .en_from({1'b0, node_1_en[2], 2'b00}),
        .ready_from({1'b0, node_1_ready[2], 2'b00}),
        .exist_from({1'b0, node_3_exist[2], 2'b00}),
        .value_from({4'b0000, node_3_value, 8'b00000000}),
        .value_from_preset(value_preset_2),
        .current_value(node_2_value),
        .en_to(node_2_en),
        .ready_to(node_2_ready),
        .exist_to(node_2_exist)
    );

    node node_3(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset),
        .en_from({1'b0, node_2_en[2], 2'b00}),
        .ready_from({1'b0, node_2_ready[2], 2'b00}),
        .exist_from(4'b0000),
        .value_from(16'b0000000000000000),
        .value_from_preset(value_preset_3),
        .current_value(node_3_value),
        .en_to(node_3_en),
        .ready_to(node_3_ready),
        .exist_to(node_3_exist)
    );

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        preset = 1'b0;
        ready_from = 4'b0000;
        value_preset_1 = 4'b0001;
        value_preset_2 = 4'b0011;
        value_preset_3 = 4'b0010;
    end

    initial begin
        forever begin
            #10 clk = !clk;
        end
    end

    initial begin
        #20 rst = 1'b1;
        #20 preset = 1'b1;
        #20 ready_from = 4'b0100; preset = 1'b0;
        #20 ready_from = 4'b0000;
    end
    
endmodule