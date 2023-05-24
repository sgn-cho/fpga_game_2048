module top_module (
    input wire clk,
    input wire rst,
    input wire preset_ext,
    input wire[3:0] preset_location,
    input wire[3:0] button_press,
    output wire[3:0] value,
    output wire vga_vs,
    output wire vga_hs,
    output wire[3:0] vga_r,
    output wire[3:0] vga_g,
    output wire[3:0] vga_b
);

	clk_wiz_0 clock_gen_65 (
		.clk_out1(clk_65),
		.clk_in1(clk)
	);

    reg[3:0] ready_1, ready_2;

    always @ (posedge clk_65) begin
        ready_1 <= button_press;
        ready_2 <= ready_1;
    end

    reg[3:0] ready_from;
    always @ (posedge clk_65) begin
        ready_from[3] <= (ready_1[3] != ready_2[3] && ready_1[3] == 1'b1) ? 1'b1 : 1'b0;
        ready_from[2] <= (ready_1[2] != ready_2[2] && ready_1[2] == 1'b1) ? 1'b1 : 1'b0;
        ready_from[1] <= (ready_1[1] != ready_2[1] && ready_1[1] == 1'b1) ? 1'b1 : 1'b0;
        ready_from[0] <= (ready_1[0] != ready_2[0] && ready_1[0] == 1'b1) ? 1'b1 : 1'b0;
    end

    wire[63:0] current_state;
    board main_board(
        .clk(clk_65),
        .rst(rst),
        .preset_ext(preset_ext),
        .preset_location(preset_location),
        .value_from_preset(4'b0010),
        .ready_from_global(ready_from),
        .total_current_state(current_state),
        .board_done(),
        .movable(),
        .score()
    );

    vga_module top_vga(
        .clk_65(clk_65),
        .rst(rst),
        .current_state(current_state),
        .vga_vs(vga_vs),
        .vga_hs(vga_hs),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b)
    );

    assign value[3] = current_state[63:0] == 64'd0 ? 1'b1 : 1'b0;
    assign value[2:0] = current_state[62:60];

endmodule