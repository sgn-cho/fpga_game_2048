module new_block_generator(
    input wire clk,
    input wire rst,
    input wire[15:0] in,
    output reg done,
    output reg[3:0] out,
    output reg out_preset
);

    wire[3:0] num;
    wire muxed_value, two_or_four;

    xor_shift_sync random_number_generator(
        .clk(clk),
        .rst(rst),
        .seed(32'h392a4953),
        .rand(num),
        .two_or_four(two_or_four)
    );

    assign muxed_value = (num == 4'h0) ? in[0] :
        (num == 4'h1) ? in[1]:
        (num == 4'h2) ? in[2]:
        (num == 4'h3) ? in[3]:
        (num == 4'h4) ? in[4]:
        (num == 4'h5) ? in[5]:
        (num == 4'h6) ? in[6]:
        (num == 4'h7) ? in[7]:
        (num == 4'h8) ? in[8]:
        (num == 4'h9) ? in[9]:
        (num == 4'ha) ? in[10] :
        (num == 4'hb) ? in[11] :
        (num == 4'hc) ? in[12] :
        (num == 4'hd) ? in[13] :
        (num == 4'he) ? in[14] : in[15];
        
    always @ (posedge clk) begin
        if (muxed_value) done <= 1'b1;
        else done <= 1'b0;
        out <= num;
        out_preset <= two_or_four;
    end

endmodule