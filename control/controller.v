module controller (
    input wire clk,
    input wire rst,
    input wire[3:0] button_press,
    output reg[19:0] score
);

    parameter idle = 0, init_1 = 1, pend_init = 2, init_2 = 3, wait_press = 4, pending = 5, check = 6, ended = 7;

    reg[2:0] state, next_state;
    reg preset, rnd_num;
    wire generate_done, movable, out_preset;
    wire[3:0] board_done;
    wire[63:0] total_current_state;
    wire[15:0] score_signal;

    reg[3:0] sended_direction, preset_location, preset_value;

    board main_board(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset),
        .preset_location(preset_location),
        .total_current_state(total_current_state)
        .board_done(board_done),
        .movable(movable),
        .score(score_signal)
    );

    new_block_generator random_number(
        .clk(clk),
        .rst(rst),
        .in(),
        .done(done),
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
            if (done == 1'b1) next_state <= check;
            else if (movable == 1'b0) next_state <= ended;
            else next_state <= init_2;
        end
        else if (state == check) begin
            if (movable == 1'b1) next_state <= wait_press;
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
        preset_value <= out_preset == 1'b1 ? 4'b0001 : 4'b0010;
    end
    
endmodule