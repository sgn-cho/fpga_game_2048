module new_block_generator(
    input wire clk,
    input wire rst,
    input wire[15:0] in,
    output wire done,
    output reg[3:0] out,
    output reg out_preset
);

    wire[31:0] num;
    wire muxed_value, two_or_four;

    xor_shift_sync random_number_generator(
        .clk(clk),
        .rst(rst),
        .seed(32'h392a4953),
        .rand(num),
        .two_or_four(two_or_four)
    );

    parameter tmp_position = 16'h0001;
    assign muxed_value = in & ((num == 4'h0) ? tmp_position :
        (num == 4'h1) ? tmp_position << 1 :
        (num == 4'h2) ? tmp_position << 2 :
        (num == 4'h3) ? tmp_position << 3 :
        (num == 4'h4) ? tmp_position << 4 :
        (num == 4'h5) ? tmp_position << 5 :
        (num == 4'h6) ? tmp_position << 6 :
        (num == 4'h7) ? tmp_position << 7 :
        (num == 4'h8) ? tmp_position << 8 :
        (num == 4'h9) ? tmp_position << 9 :
        (num == 4'ha) ? tmp_position << 10 :
        (num == 4'hb) ? tmp_position << 11 :
        (num == 4'hc) ? tmp_position << 12 :
        (num == 4'hd) ? tmp_position << 13 :
        (num == 4'he) ? tmp_position << 14 : tmp_position << 15);

    always @ (posedge clk) begin
        if (muxed_value == 1'b1) begin
            done <= 1'b1;
        end
        out <= num;
        out_preset <= two_or_four;
    end

endmodule