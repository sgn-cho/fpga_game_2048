module controller (
    input wire clk,
    input wire rst,
    input wire[3:0] button_press,
    output reg[15:0] score
);

    parameter idle = 0, init_1 = 1, pend_init = 2, init_2 = 3, wait_press = 4, pending = 5, check = 6, ended = 7;

    reg[2:0] state, next_state;
    reg preset, rnd_num;
    wire generate_done, movable;
    wire[3:0] board_done;
    wire[63:0] total_current_state;

    reg[3:0] sended_direction, preset_location, preset_value;

    board main_board(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset),
        .preset_location(preset_location),
        .total_current_state(total_current_state)
        .board_done(board_done),
        .movable(movable)
    );

    new_block_generator random_number(
        .clk(clk),
        .rst(rst),
        .in(),
        .done(done),
        .out(rnd_num)
    );

    reg[63:0] score_queue;
    reg[31:0] score_queue_2;

    always @ (posedge clk) begin
        score_queue <= {score[15] == 1'b1 ? total_current_state[63:60] : 4'h0,
            score[14] == 1'b1 ? total_current_state[59:56] : 4'h0,
            score[13] == 1'b1 ? total_current_state[55:52] : 4'h0,
            score[12] == 1'b1 ? total_current_state[51:48] : 4'h0,
            score[11] == 1'b1 ? total_current_state[47:44] : 4'h0,
            score[10] == 1'b1 ? total_current_state[43:40] : 4'h0,
            score[9] == 1'b1 ? total_current_state[39:36] : 4'h0,
            score[8] == 1'b1 ? total_current_state[35:32] : 4'h0,
            score[7] == 1'b1 ? total_current_state[31:28] : 4'h0,
            score[6] == 1'b1 ? total_current_state[27:24] : 4'h0,
            score[5] == 1'b1 ? total_current_state[23:20] : 4'h0,
            score[4] == 1'b1 ? total_current_state[19:16] : 4'h0,
            score[3] == 1'b1 ? total_current_state[15:12] : 4'h0,
            score[2] == 1'b1 ? total_current_state[11:8] : 4'h0,
            score[1] == 1'b1 ? total_current_state[7:4] : 4'h0,
            score[0] == 1'b1 ? total_current_state[3:0] : 4'h0 };

        score_queue_2 <= { score[15] + score[14] + score[13] + score[12],
            score[11] + score[10] + score[9] + score[8],
            score[7] + score[6] + score[5] + score[4],
            score[3] + score[2] + score[1] + score[0] };

        score <= score_queue_2[31:24] + score_queue_2[23:16] + score_queue_2[15:8] + score_queue_2[7:0];
    end

    reg[3:0] ready_1, ready_2;

    always @ (posedge clk) begin
        ready_1 <= button_press;
        ready_2 <= ready_1;
    end

    reg[3:0] ready_from;
    always @ (posedge clk) begin
        ready_from[3] <= (ready_1[3] != ready_2[3] && ready_1[3] == 1'b1) ? 1'b1 : 1'b0;
        ready_from[2] <= (ready_1[2] != ready_2[2] && ready_1[2] == 1'b1) ? 1'b1 : 1'b0;
        ready_from[1] <= (ready_1[1] != ready_2[1] && ready_1[1] == 1'b1) ? 1'b1 : 1'b0;
        ready_from[0] <= (ready_1[0] != ready_2[0] && ready_1[0] == 1'b1) ? 1'b1 : 1'b0;
    end

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
            if (done == 1'b1) next_state <= pend_init;
            else next_state <= init_1;
        end
        else if (state == pend_init) next_state <= init_2;
        else if (state == init_2) begin
            if (done == 1'b1) next_state <= wait_press;
            else next_state <= init_2;
        end
        else if (state == wait_press) begin
            if (ready_from != 4'b0000) next_state <= pending;
            else next_state <= wait_press;
        end
        else if (state == pending) begin
            if (sended_direction & board_done != 4'b0000) next_state <= check;
            else next_state <= pending;
        end
        else if (state == check) begin
            if (movable == 1'b1) next_state <= init_2;
            else next_state <= ended;
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

    // preset location
    always @ (posedge clk) begin
        if (state == init_1 && generate_done == 1'b1) begin
            preset_location <= rnd_num;
        end 
        else if (state == init_2 && generate_done == 1'b1) begin
            preset_location <= rnd_num;
        end
        else begin
            preset_location <= 4'b0000;
        end
    end

    // preset value
    always @ (posedge clk) begin
        preset_value <= 4'b0001;
    end
    
endmodule