module scorer (
    input wire clk,
    input wire rst,
    input wire[63:0] total_current_state,
    input wire[15:0] score_signal,
    output wire[19:0] bcd_score
);

    wire[63:0] first_adder_wire;
    reg[39:0] second_value_register;
    reg[23:0] third_value_register;
    reg[15:0] last_value_register;
    reg[15:0] score_by_two;

    always @ (posedge clk) begin
        if (!rst) begin
            second_value_register <= 40'd0;
            third_value_register <= 24'd0;
            last_value_register <= 16'd0;
            score_by_two <= 16'd0;
        end else begin
            second_value_register <= {
                {1'b0, first_adder_wire[63:60]} + {1'b0, first_adder_wire[59:56]},
                {1'b0, first_adder_wire[55:52]} + {1'b0, first_adder_wire[51:48]},
                {1'b0, first_adder_wire[47:44]} + {1'b0, first_adder_wire[43:40]},
                {1'b0, first_adder_wire[39:36]} + {1'b0, first_adder_wire[35:32]},
                {1'b0, first_adder_wire[31:28]} + {1'b0, first_adder_wire[27:24]},
                {1'b0, first_adder_wire[23:20]} + {1'b0, first_adder_wire[19:16]},
                {1'b0, first_adder_wire[15:12]} + {1'b0, first_adder_wire[11:8]},
                {1'b0, first_adder_wire[7:4]} + {1'b0, first_adder_wire[3:0]}
            };

            third_value_register <= {
                {1'b0, second_value_register[39:35]} + {1'b0, second_value_register[34:30]},
                {1'b0, second_value_register[29:25]} + {1'b0, second_value_register[24:20]},
                {1'b0, second_value_register[19:15]} + {1'b0, second_value_register[14:10]},
                {1'b0, second_value_register[9:5]} + {1'b0, second_value_register[4:0]}
            };

            last_value_register <= {
                {2'b00, third_value_register[23:18]} + {2'b00, third_value_register[17:12]},
                {2'b00, third_value_register[11:6]} + {2'b00, third_value_register[5:0]}
            };

            score_by_two <= {8'b0000_0000, last_value_register[15:8]} + {8'b0000_0000, last_value_register[7:0]} + score_by_two;
        end
    end

    double_dabble bcd_score_module(
        .bin(score_by_two),
        .bcd(bcd_score)
    );


    state_decoder_to_score score_15(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[63:60]),
        .decoded_value(first_adder_wire[63:60])
    );

    state_decoder_to_score score_14(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[59:56]),
        .decoded_value(first_adder_wire[59:56])
    );

    state_decoder_to_score score_13(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[55:52]),
        .decoded_value(first_adder_wire[55:52])
    );

    state_decoder_to_score score_12(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[51:48]),
        .decoded_value(first_adder_wire[51:48])
    );

    state_decoder_to_score score_11(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[47:44]),
        .decoded_value(first_adder_wire[47:44])
    );

    state_decoder_to_score score_10(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[43:40]),
        .decoded_value(first_adder_wire[43:40])
    );

    state_decoder_to_score score_9(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[39:36]),
        .decoded_value(first_adder_wire[39:36])
    );

    state_decoder_to_score score_8(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[35:32]),
        .decoded_value(first_adder_wire[35:32])
    );

    state_decoder_to_score score_7(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[31:28]),
        .decoded_value(first_adder_wire[31:28])
    );

    state_decoder_to_score score_6(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[27:24]),
        .decoded_value(first_adder_wire[27:24])
    );

    state_decoder_to_score score_5(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[23:20]),
        .decoded_value(first_adder_wire[23:20])
    );

    state_decoder_to_score score_4(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[19:16]),
        .decoded_value(first_adder_wire[19:16])
    );

    state_decoder_to_score score_3(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[15:12]),
        .decoded_value(first_adder_wire[15:12])
    );

    state_decoder_to_score score_2(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[11:8]),
        .decoded_value(first_adder_wire[11:8])
    );

    state_decoder_to_score score_1(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[7:4]),
        .decoded_value(first_adder_wire[7:4])
    );

    state_decoder_to_score score_0(
        .clk(clk),
        .rst(rst),
        .current_state(total_current_state[3:0]),
        .decoded_value(first_adder_wire[3:0])
    );
    
endmodule