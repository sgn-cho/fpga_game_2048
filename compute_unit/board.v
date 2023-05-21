module board (
    input wire clk,
    input wire rst,
    input wire preset_ext,
    input wire[3:0] preset_location,
    input wire[3:0] value_from_preset,
    input wire[3:0] ready_from_global,
    output wire[63:0] total_current_state
);

    // preset location decoder
    parameter tmp_preset = 16'b0000_0000_0000_0001;
    wire[15:0] preset_decode = (preset_location == 4'b0000) ? tmp_preset :
        (preset_location == 4'b0001) ? tmp_preset << 1 :
        (preset_location == 4'b0010) ? tmp_preset << 2 :
        (preset_location == 4'b0011) ? tmp_preset << 3 :
        (preset_location == 4'b0100) ? tmp_preset << 4 :
        (preset_location == 4'b0101) ? tmp_preset << 5 :
        (preset_location == 4'b0110) ? tmp_preset << 6 :
        (preset_location == 4'b0111) ? tmp_preset << 7 :
        (preset_location == 4'b1000) ? tmp_preset << 8 :
        (preset_location == 4'b1001) ? tmp_preset << 9 :
        (preset_location == 4'b1010) ? tmp_preset << 10 :
        (preset_location == 4'b1011) ? tmp_preset << 11 :
        (preset_location == 4'b1100) ? tmp_preset << 12 :
        (preset_location == 4'b1101) ? tmp_preset << 13 :
        (preset_location == 4'b1110) ? tmp_preset << 14 : tmp_preset << 15;

    wire[3:0] node_15_value;
    wire[3:0] node_15_en;
    wire[3:0] node_15_exist;
    wire[3:0] node_15_ready;

    wire[3:0] node_14_value;
    wire[3:0] node_14_en;
    wire[3:0] node_14_exist;
    wire[3:0] node_14_ready;

    wire[3:0] node_13_value;
    wire[3:0] node_13_en;
    wire[3:0] node_13_exist;
    wire[3:0] node_13_ready;

    wire[3:0] node_12_value;
    wire[3:0] node_12_en;
    wire[3:0] node_12_exist;
    wire[3:0] node_12_ready;

    wire[3:0] node_11_value;
    wire[3:0] node_11_en;
    wire[3:0] node_11_exist;
    wire[3:0] node_11_ready;

    wire[3:0] node_10_value;
    wire[3:0] node_10_en;
    wire[3:0] node_10_exist;
    wire[3:0] node_10_ready;

    wire[3:0] node_9_value;
    wire[3:0] node_9_en;
    wire[3:0] node_9_exist;
    wire[3:0] node_9_ready;

    wire[3:0] node_8_value;
    wire[3:0] node_8_en;
    wire[3:0] node_8_exist;
    wire[3:0] node_8_ready;

    wire[3:0] node_7_value;
    wire[3:0] node_7_en;
    wire[3:0] node_7_exist;
    wire[3:0] node_7_ready;

    wire[3:0] node_6_value;
    wire[3:0] node_6_en;
    wire[3:0] node_6_exist;
    wire[3:0] node_6_ready;

    wire[3:0] node_5_value;
    wire[3:0] node_5_en;
    wire[3:0] node_5_exist;
    wire[3:0] node_5_ready;

    wire[3:0] node_4_value;
    wire[3:0] node_4_en;
    wire[3:0] node_4_exist;
    wire[3:0] node_4_ready;

    wire[3:0] node_3_value;
    wire[3:0] node_3_en;
    wire[3:0] node_3_exist;
    wire[3:0] node_3_ready;

    wire[3:0] node_2_value;
    wire[3:0] node_2_en;
    wire[3:0] node_2_exist;
    wire[3:0] node_2_ready;

    wire[3:0] node_1_value;
    wire[3:0] node_1_en;
    wire[3:0] node_1_exist;
    wire[3:0] node_1_ready;

    wire[3:0] node_0_value;
    wire[3:0] node_0_en;
    wire[3:0] node_0_exist;
    wire[3:0] node_0_ready;

    // test assign
    assign total_current_state = {node_15_value, node_14_value, node_13_value, node_12_value,
        node_11_value, node_10_value, node_9_value, node_8_value,
        node_7_value, node_6_value, node_5_value, node_4_value,
        node_3_value, node_2_value, node_1_value, node_0_value};

    node node_15(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[15]),
        .en_from({node_11_en[3], 1'b0, 1'b0, node_14_en[0]}),
        .ready_from({node_11_ready[3], ready_from_global[2:1], node_14_ready[0]}),
        .exist_from({1'b0, node_14_exist[2], node_11_exist[1], 1'b0}),
        .value_from({4'b0000, node_14_value, node_11_value, 4'b0000}),
        .value_from_preset(value_from_preset),
        .current_value(node_15_value),
        .en_to(node_15_en),
        .ready_to(node_15_ready),
        .exist_to(node_15_exist)
    );

    node node_14(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[14]),
        .en_from({node_10_en[3], node_15_en[2], 1'b0, node_13_en[0]}),
        .ready_from({node_10_ready[3], node_15_ready[2], ready_from_global[1], node_13_ready[0]}),
        .exist_from({1'b0, node_13_exist[2], node_10_exist[1], node_15_exist[0]}),
        .value_from({4'b0000, node_13_value, node_10_value, node_15_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_14_value),
        .en_to(node_14_en),
        .ready_to(node_14_ready),
        .exist_to(node_14_exist)
    );

    node node_13(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[13]),
        .en_from({node_9_en[3], node_14_en[2], 1'b0, node_12_en[0]}),
        .ready_from({node_9_ready[3], node_14_ready[2], ready_from_global[1], node_12_ready[0]}),
        .exist_from({1'b0, node_12_exist[2], node_9_exist[1], node_14_exist[0]}),
        .value_from({4'b0000, node_12_value, node_9_value, node_14_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_13_value),
        .en_to(node_13_en),
        .ready_to(node_13_ready),
        .exist_to(node_13_exist)
    );

    node node_12(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[12]),
        .en_from({node_8_en[3], node_13_en[2], 1'b0, 1'b0}),
        .ready_from({node_8_ready[3], node_13_ready[2], ready_from_global[1:0]}),
        .exist_from({2'b00, node_8_exist[1], node_13_exist[0]}),
        .value_from({8'b0000_0000, node_8_value, node_13_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_12_value),
        .en_to(node_12_en),
        .ready_to(node_12_ready),
        .exist_to(node_12_exist)
    );

    node node_11(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[11]),
        .en_from({node_7_en[3], 1'b0, node_15_en[1], node_10_en[0]}),
        .ready_from({node_7_ready[3], ready_from_global[2], node_15_ready[1], node_10_ready[0]}),
        .exist_from({node_15_exist[3], node_10_exist[2], node_7_exist[1], 1'b0}),
        .value_from({node_15_value, node_10_value, node_7_value, 4'b0000}),
        .value_from_preset(value_from_preset),
        .current_value(node_11_value),
        .en_to(node_11_en),
        .ready_to(node_11_ready),
        .exist_to(node_11_exist)
    );

    node node_10(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[10]),
        .en_from({node_6_en[3], node_11_en[2], node_14_en[1], node_9_en[0]}),
        .ready_from({node_6_ready[3], node_11_ready[2], node_14_ready[1], node_9_ready[0]}),
        .exist_from({node_14_exist[3], node_9_exist[2], node_6_exist[1], node_11_exist[0]}),
        .value_from({node_14_value, node_9_value, node_6_value, node_11_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_10_value),
        .en_to(node_10_en),
        .ready_to(node_10_ready),
        .exist_to(node_10_exist)
    );

    node node_9(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[9]),
        .en_from({node_5_en[3], node_10_en[2], node_13_en[1], node_8_en[0]}),
        .ready_from({node_5_ready[3], node_10_ready[2], node_13_ready[1], node_8_ready[0]}),
        .exist_from({node_13_exist[3], node_8_exist[2], node_5_exist[1], node_10_exist[0]}),
        .value_from({node_13_value, node_8_value, node_5_value, node_10_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_9_value),
        .en_to(node_9_en),
        .ready_to(node_9_ready),
        .exist_to(node_9_exist)
    );

    node node_8(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[8]),
        .en_from({node_4_en[3], node_9_en[2], node_12_en[1], 1'b0}),
        .ready_from({node_4_ready[3], node_9_ready[2], node_12_ready[1], ready_from_global[0]}),
        .exist_from({node_12_exist[3], 1'b0, node_4_exist[1], node_9_exist[0]}),
        .value_from({node_12_value, 4'b0000, node_4_value, node_9_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_8_value),
        .en_to(node_8_en),
        .ready_to(node_8_ready),
        .exist_to(node_8_exist)
    );

    node node_7(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[7]),
        .en_from({node_3_en[3], 1'b0, node_11_en[1], node_6_en[0]}),
        .ready_from({node_3_ready[3], ready_from_global[2], node_11_ready[1], node_6_ready[0]}),
        .exist_from({node_11_exist[3], node_6_exist[2], node_3_exist[1], 1'b0}),
        .value_from({node_11_value, node_6_value, node_3_value, 4'b0000}),
        .value_from_preset(value_from_preset),
        .current_value(node_7_value),
        .en_to(node_7_en),
        .ready_to(node_7_ready),
        .exist_to(node_7_exist)
    );

    node node_6(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[6]),
        .en_from({node_2_en[3], node_7_en[2], node_10_en[1], node_5_en[0]}),
        .ready_from({node_2_ready[3], node_7_ready[2], node_10_ready[1], node_5_ready[0]}),
        .exist_from({node_11_exist[3], node_5_exist[2], node_2_exist[1], node_7_exist[0]}),
        .value_from({node_10_value, node_5_value, node_2_value, node_7_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_6_value),
        .en_to(node_6_en),
        .ready_to(node_6_ready),
        .exist_to(node_6_exist)
    );

    node node_5(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[5]),
        .en_from({node_1_en[3], node_6_en[2], node_9_en[1], node_4_en[0]}),
        .ready_from({node_1_ready[3], node_6_ready[2], node_9_ready[1], node_4_ready[0]}),
        .exist_from({node_9_exist[3], node_4_exist[2], node_1_exist[1], node_6_exist[0]}),
        .value_from({node_9_value, node_4_value, node_1_value, node_6_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_5_value),
        .en_to(node_5_en),
        .ready_to(node_5_ready),
        .exist_to(node_5_exist)
    );

    node node_4(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[4]),
        .en_from({node_0_en[3], node_5_en[2], node_8_en[1], 1'b0}),
        .ready_from({node_0_ready[3], node_5_ready[2], node_8_ready[1], ready_from_global[0]}),
        .exist_from({node_8_exist[3], 1'b0, node_0_exist[1], node_5_exist[0]}),
        .value_from({node_8_value, 4'b0000, node_0_value, node_5_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_4_value),
        .en_to(node_4_en),
        .ready_to(node_4_ready),
        .exist_to(node_4_exist)
    );

    node node_3(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[3]),
        .en_from({2'b00, node_7_en[1], node_2_en[0]}),
        .ready_from({ready_from_global[3:2], node_7_ready[1], node_2_ready[0]}),
        .exist_from({node_7_exist[3], node_2_exist[2], 2'b00}),
        .value_from({node_7_value, node_2_value, 8'b0000_0000}),
        .value_from_preset(value_from_preset),
        .current_value(node_3_value),
        .en_to(node_3_en),
        .ready_to(node_3_ready),
        .exist_to(node_3_exist)
    );

    node node_2(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[2]),
        .en_from({1'b0, node_3_en[2], node_6_en[1], node_1_en[0]}),
        .ready_from({ready_from_global[3], node_3_ready[2], node_6_ready[1], node_1_ready[0]}),
        .exist_from({node_6_exist[3], node_1_exist[2], 1'b0, node_3_exist[0]}),
        .value_from({node_6_value, node_1_value, 4'b0000, node_3_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_2_value),
        .en_to(node_2_en),
        .ready_to(node_2_ready),
        .exist_to(node_2_exist)
    );

    node node_1(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[1]),
        .en_from({1'b0, node_2_en[2], node_5_en[1], node_0_en[0]}),
        .ready_from({ready_from_global[3], node_2_ready[2], node_5_ready[1], node_0_ready[0]}),
        .exist_from({node_5_exist[3], node_0_exist[2], 1'b0, node_2_exist[0]}),
        .value_from({node_5_value, node_0_value, 4'b0000, node_2_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_1_value),
        .en_to(node_1_en),
        .ready_to(node_1_ready),
        .exist_to(node_1_exist)
    );

    node node_0(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext && preset_decode[0]),
        .en_from({1'b0, node_1_en[2], node_4_en[1], 1'b0}),
        .ready_from({ready_from_global[3], node_1_ready[2], node_4_ready[1], ready_from_global[0]}),
        .exist_from({node_4_exist[3], 2'b00, node_1_exist[0]}),
        .value_from({node_4_value, 8'b0000_0000, node_1_value}),
        .value_from_preset(value_from_preset),
        .current_value(node_0_value),
        .en_to(node_0_en),
        .ready_to(node_0_ready),
        .exist_to(node_0_exist)
    );
    
endmodule