module scorer (
    input wire clk,
    input wire rst,
    input wire[63:0] total_current_state,
    input wire[15:0] score_signal,
    output wire[19:0] bcd_score
);

    wire[255:0] first_adder_wire;
    reg[127:0] second_value_register;
    reg[63:0] third_value_register;
    reg[31:0] last_value_register;
    reg[15:0] score_by_two;

    always @ (posedge clk) begin
        if (!rst) begin
            second_value_register <= 40'd0;
            third_value_register <= 24'd0;
            last_value_register <= 16'd0;
            score_by_two <= 16'd0;
        end else begin
            second_value_register <= {
                first_adder_wire[255:240] + first_adder_wire[239:224],
                first_adder_wire[223:208] + first_adder_wire[207:192],
                first_adder_wire[191:176] + first_adder_wire[175:160],
                first_adder_wire[159:144] +  first_adder_wire[143:128],
                first_adder_wire[127:112] +  first_adder_wire[111:96],
                first_adder_wire[95:80] +  first_adder_wire[79:64],
                first_adder_wire[63:48] +  first_adder_wire[47:32],
                first_adder_wire[31:16] + 1'b0, first_adder_wire[15:0]
            };

            third_value_register <= {
                second_value_register[127:112] + second_value_register[111:96],
                second_value_register[95:80] + second_value_register[79:64],
                second_value_register[63:48] + second_value_register[47:32],
                second_value_register[31:16] + second_value_register[15:0]
            };

            last_value_register <= {
                third_value_register[63:48] + third_value_register[47:32],
                third_value_register[31:16] + third_value_register[15:0]
            };

            score_by_two <= last_value_register[31:16] + last_value_register[15:0] + score_by_two;
        end
    end

    wire[20:0] bcd_score_module_output;
    double_dabble bcd_score_module(
        .clk(clk),
        .bin(score_by_two),
        .bcd(bcd_score_module_output)
    );

    assign bcd_score = bcd_score_module_output[19:0];

    state_decoder_to_score score_15(
        .clk(clk),
        .rst(rst),
        .en(score_signal[15]),
        .current_state(total_current_state[63:60]),
        .decoded_value(first_adder_wire[255:240])
    );

    state_decoder_to_score score_14(
        .clk(clk),
        .en(score_signal[14]),
        .current_state(total_current_state[59:56]),
        .decoded_value(first_adder_wire[239:224])
    );

    state_decoder_to_score score_13(
        .clk(clk),
        .rst(rst),
        .en(score_signal[13]),
        .current_state(total_current_state[55:52]),
        .decoded_value(first_adder_wire[223:208])
    );

    state_decoder_to_score score_12(
        .clk(clk),
        .rst(rst),
        .en(score_signal[12]),
        .current_state(total_current_state[51:48]),
        .decoded_value(first_adder_wire[207:192])
    );

    state_decoder_to_score score_11(
        .clk(clk),
        .rst(rst),
        .en(score_signal[11]),
        .current_state(total_current_state[47:44]),
        .decoded_value(first_adder_wire[191:176])
    );

    state_decoder_to_score score_10(
        .clk(clk),
        .rst(rst),
        .en(score_signal[10]),
        .current_state(total_current_state[43:40]),
        .decoded_value(first_adder_wire[175:160])
    );

    state_decoder_to_score score_9(
        .clk(clk),
        .rst(rst),
        .en(score_signal[9]),
        .current_state(total_current_state[39:36]),
        .decoded_value(first_adder_wire[159:144])
    );

    state_decoder_to_score score_8(
        .clk(clk),
        .rst(rst),
        .en(score_signal[8]),
        .current_state(total_current_state[35:32]),
        .decoded_value(first_adder_wire[143:128])
    );

    state_decoder_to_score score_7(
        .clk(clk),
        .rst(rst),
        .en(score_signal[7]),
        .current_state(total_current_state[31:28]),
        .decoded_value(first_adder_wire[127:112])
    );

    state_decoder_to_score score_6(
        .clk(clk),
        .rst(rst),
        .en(score_signal[6]),
        .current_state(total_current_state[27:24]),
        .decoded_value(first_adder_wire[111:96])
    );

    state_decoder_to_score score_5(
        .clk(clk),
        .rst(rst),
        .en(score_signal[5]),
        .current_state(total_current_state[23:20]),
        .decoded_value(first_adder_wire[95:80])
    );

    state_decoder_to_score score_4(
        .clk(clk),
        .rst(rst),
        .en(score_signal[4]),
        .current_state(total_current_state[19:16]),
        .decoded_value(first_adder_wire[79:64])
    );

    state_decoder_to_score score_3(
        .clk(clk),
        .rst(rst),
        .en(score_signal[3]),
        .current_state(total_current_state[15:12]),
        .decoded_value(first_adder_wire[63:48])
    );

    state_decoder_to_score score_2(
        .clk(clk),
        .rst(rst),
        .en(score_signal[2]),
        .current_state(total_current_state[11:8]),
        .decoded_value(first_adder_wire[47:32])
    );

    state_decoder_to_score score_1(
        .clk(clk),
        .rst(rst),
        .en(score_signal[1]),
        .current_state(total_current_state[7:4]),
        .decoded_value(first_adder_wire[31:16])
    );

    state_decoder_to_score score_0(
        .clk(clk),
        .rst(rst),
        .en(score_signal[0]),
        .current_state(total_current_state[3:0]),
        .decoded_value(first_adder_wire[15:0])
    );
    
endmodule