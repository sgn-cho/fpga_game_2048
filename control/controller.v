module controller (
    input wire clk,
    input wire rst,
    input wire[3:0] button_press,
    output wire[63:0] total_current_state,
    output wire[19:0] score
);

    parameter idle = 0, init_1 = 1, pend_init = 2, init_2 = 3, wait_press = 4, pending = 5, check = 6, ended = 7;

    reg[2:0] state, next_state;
    wire[3:0] rnd_num;
    wire[1:0] movable;
    wire generate_done, out_preset, preset_signal;
    wire[3:0] board_done;
    wire[15:0] score_signal;

    reg[3:0] sended_direction;
    wire[3:0] preset_location, preset_value;

    reg[3:0] ready_1, ready_2;

    always @ (posedge clk) begin
        ready_1 <= button_press;
        ready_2 <= ready_1;
    end

    reg[3:0] ready_from;
    always @ (posedge clk) begin
        ready_from[3] <= (ready_1[3] != ready_2[3] && ready_1[3] == 1'b1 && movable[1]) ? 1'b1 : 1'b0;
        ready_from[2] <= (ready_1[2] != ready_2[2] && ready_1[2] == 1'b1 && movable[0]) ? 1'b1 : 1'b0;
        ready_from[1] <= (ready_1[1] != ready_2[1] && ready_1[1] == 1'b1 && movable[1]) ? 1'b1 : 1'b0;
        ready_from[0] <= (ready_1[0] != ready_2[0] && ready_1[0] == 1'b1 && movable[0]) ? 1'b1 : 1'b0;
    end

    board main_board(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_signal),
        .preset_location(preset_location),
        .value_from_preset(preset_value),
        .ready_from_global(ready_from),
        .total_current_state(total_current_state),
        .board_done(board_done),
        .movable(movable),
        .score(score_signal)
    );

    wire[15:0] block_exist = {
        total_current_state[63:60] != 4'b0000,
        total_current_state[59:56] != 4'b0000,
        total_current_state[55:52] != 4'b0000,
        total_current_state[51:48] != 4'b0000,
        total_current_state[47:44] != 4'b0000,
        total_current_state[43:40] != 4'b0000,
        total_current_state[39:36] != 4'b0000,
        total_current_state[35:32] != 4'b0000,
        total_current_state[31:28] != 4'b0000,
        total_current_state[27:24] != 4'b0000,
        total_current_state[23:20] != 4'b0000,
        total_current_state[19:16] != 4'b0000,
        total_current_state[15:12] != 4'b0000,
        total_current_state[11:8] != 4'b0000,
        total_current_state[7:4] != 4'b0000,
        total_current_state[3:0] != 4'b0000
    };

    new_block_generator random_number(
        .clk(clk),
        .rst(rst),
        .in(block_exist),
        .done(generate_done),
        .out(rnd_num),
        .out_preset(out_preset)
    );

    scorer score_module(
        .clk(clk),
        .rst(rst),
        .total_current_state(total_current_state),
        .score_signal(score_signal),
        .bcd_score(score)
    );

    always @ (posedge clk) begin
        if (rst == 1'b0) state <= idle;
        else state <= next_state;
    end

    // next_state
    always @ (posedge clk) begin
        if (rst == 1'b0) next_state <= idle;
        else if (state == idle) begin
            if (rst == 1'b0) next_state <= init_1;
            else next_state <= idle;
        end
        else if (state == init_1) begin
            if (generate_done == 1'b1) next_state <= pend_init;
            else next_state <= init_1;
        end
        else if (state == pend_init) next_state <= init_2;
        else if (state == init_2) begin
            if (generate_done == 1'b1) next_state <= check;
            else if (movable == 2'b00) next_state <= ended;
            else next_state <= init_2;
        end
        else if (state == check) begin
            if (movable != 2'b00) next_state <= wait_press;
            else next_state <= ended;
        end
        else if (state == wait_press) begin
            if (ready_from != 4'b0000) next_state <= pending;
            else next_state <= wait_press;
        end
        else if (state == pending) begin
            if (sended_direction & board_done != 4'b0000) next_state <= init_2;
            else next_state <= pending;
        end
        else next_state <= next_state;
    end

    // sended direction
    always @ (posedge clk) begin
        if (state == wait_press && ready_from != 4'b0000) begin
            sended_direction <= ready_from;
        end
        else if (state == init_2) sended_direction <= 4'b0000;
        else sended_direction <= sended_direction;
    end
    
    assign preset_location = generate_done == 1'b1 ? rnd_num : 4'b0000;
    assign preset_value = out_preset == 1'b1 ? 4'b0001: 4'b0010;
    assign preset_signal = (state == init_1) || (state == init_2) || generate_done;

endmodule