module top_module (
    input wire clk,
    input wire rst,
    input wire[3:0] button_press,
    output wire[3:0] value,
    output wire vga_vs,
    output wire vga_hs,
    output wire[2:0] state,
    output wire[3:0] vga_r,
    output wire[3:0] vga_g,
    output wire[3:0] vga_b,
    output wire[7:0] segment_digit,
    output wire[6:0] segment_data
);

    wire[19:0] score_bcd;
    wire[63:0] current_state;

	clk_wiz_0 clock_gen_65 (
		.clk_out1(clk_65),
		.clk_in1(clk)
	);

    controller main_controller(
        .clk(clk_65),
        .rst(rst),
        .button_press(button_press),
        .state(state),
        .total_current_state(current_state),
        .score(score_bcd)
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

    bcd_controller bcd_controller_module(
        .clk(clk),
        .rst(rst),
        .bcd_score(score_bcd),
        .segment_digit(segment_digit),
        .segment_data(segment_data)
    );

    assign value[3] = current_state[63:0] == 64'd0 ? 1'b1 : 1'b0;
    assign value[2:0] = current_state[62:60];

endmodule