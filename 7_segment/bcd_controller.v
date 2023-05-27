module bcd_controller(
    input wire clk,
    input wire rst,
    input wire[19:0] bcd_score,
    output reg[7:0] segment_digit,
    output reg[6:0] segment_data
);

    wire[39:0] display;
    reg[16:0] clk_cnt;
    reg seg_clk;

    BCD_to_seven_seg first_digit_module(
        .BCD_in(bcd_score[3:0]),
        .DISPLAY(display[7:0])
    );

    BCD_to_seven_seg second_digit_module(
        .BCD_in(bcd_score[7:4]),
        .DISPLAY(display[15:8])
    );

    BCD_to_seven_seg third_digit_module(
        .BCD_in(bcd_score[11:8]),
        .DISPLAY(display[23:16])
    );

    BCD_to_seven_seg fourth_digit_module(
        .BCD_in(bcd_score[15:12]),
        .DISPLAY(display[31:24])
    );

    BCD_to_seven_seg fifth_digit_module(
        .BCD_in(bcd_score[19:16]),
        .DISPLAY(display[39:32])
    );

    always @ (posedge clk) begin
        if (!rst) begin
            clk_cnt <= 17'd0;
            seg_clk <= 0;
        end else begin
            if (clk_cnt == 17'd64999) begin
                seg_clk <= ~seg_clk;
            end else begin
                clk_cnt <= clk_cnt + 1;
            end
        end
    end

    always @ (posedge seg_clk) begin
        if (!rst) begin
            segment_digit <= 8'b1000_0000;
        end else begin
            segment_digit <= {segment_digit[0], segment_digit[7:1]};
        end
    end

    always @ (posedge seg_clk) begin
        if (!rst) begin
            segment_data <= 7'd0;
        end else begin
            case (segment_digit)
                8'b0001_0000: segment_data <= display[39:32];
                8'b0000_1000: segment_data <= display[31:24];
                8'b0000_0100: segment_data <= display[23:16];
                8'b0000_0010: segment_data <= display[15:8];
                8'b0000_0001: segment_data <= display[7:0];
                default: segment_data <= 7'd0;
            endcase
        end
    end
    
endmodule