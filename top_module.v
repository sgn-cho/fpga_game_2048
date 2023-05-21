module top_module (
    input wire clk,
    input wire rst,
    input wire preset_ext,
    input wire[3:0] preset_location,
    input wire[3:0] button_press,
    output wire[3:0] value
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

    wire[63:0] current_state;
    board main_board(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext),
        .preset_location(preset_location),
        .value_from_preset(4'b0010),
        .ready_from_global(ready_from),
        .total_current_state(current_state)
    );

    assign value[3] = current_state[63:0] == 64'd0 ? 1'b1 : 1'b0;
    assign value[2:0] = current_state[62:60];

endmodule