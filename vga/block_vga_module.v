module block_vga_module (
    input wire clk,
    input wire rst,
    input wire[3:0] state,
    input wire[11:0] h_cnt,
    input wire[11:0] v_cnt,
    output reg[11:0] vga_data
);

    parameter v_letter_start_offset = 12'd60;
    parameter v_letter_end_offset = 12'd106;

    parameter h_letter_first_offset = 12'd41;
    parameter h_letter_second_offset = 12'd58;
    parameter h_letter_third_offset = 12'd74;
    parameter h_letter_last_offset = 12'd90;
    parameter h_end_offset = 12'd106;

    wire[11:0] background_color = (state == 4'b0000) ? 12'h000 :
        (state == 4'b0001) ? 12'hEED :
        (state == 4'b0010) ? 12'hEEC :
        (state == 4'b0011) ? 12'hFB7 :
        (state == 4'b0100) ? 12'hF96 :
        (state == 4'b0101) ? 12'hF75 :
        (state == 4'b0110) ? 12'hF53 :
        (state == 4'b0111) ? 12'hED7 :
        (state == 4'b1000) ? 12'hEC6 :
        (state == 4'b1001) ? 12'hEC5 :
        (state == 4'b1010) ? 12'hEC3 :
        (state == 4'b1011) ? 12'hEC2 : 12'h333;

    wire[11:0] font_color = (state == 4'b0000) ? 12'h000 :
        (state == 4'b0001) ? 12'h766 :
        (state == 4'b0010) ? 12'h766 : 12'hFFF;

    reg[3:0] current_individual_number;
    reg[4:0] h_cnt_offset;
    wire[15:0] vga_font_output;

    font_rom font_rom_1(
        .clk(clk),
        .number(current_individual_number),
        .v_cnt(v_cnt - v_letter_start_offset),
        .output_row(vga_font_output)
    );

    // determine h_cnt_offset
    always @ (posedge clk) begin
        if (h_cnt == h_letter_first_offset) begin
            h_cnt_offset <= 5'd0;
        end else if (h_cnt > h_letter_first_offset && h_cnt < h_end_offset) begin
            if (h_cnt_offset == 5'b01111) h_cnt_offset <= 5'd0;
            else h_cnt_offset <= h_cnt_offset + 5'd1;
        end else begin
            h_cnt_offset <= 5'd0;
        end
    end

    // determine current_individual_number
    always @ (posedge clk) begin
        if (h_cnt >= h_letter_first_offset && h_cnt < h_letter_second_offset) begin
            case (state)
                4'b0001: current_individual_number <= 4'b0010;
                4'b0010: current_individual_number <= 4'b0100;
                4'b0011: current_individual_number <= 4'b1000;
                4'b0100: current_individual_number <= 4'b0001;
                4'b0101: current_individual_number <= 4'b0011;
                4'b0110: current_individual_number <= 4'b0110;
                4'b0111: current_individual_number <= 4'b0001;
                4'b1000: current_individual_number <= 4'b0010;
                4'b1001: current_individual_number <= 4'b0101;
                4'b1010: current_individual_number <= 4'b0001;
                4'b1011: current_individual_number <= 4'b0010;
                4'b1100: current_individual_number <= 4'b0101;
                default: current_individual_number <= 4'b1111;
            endcase
        end else if (h_cnt >= h_letter_second_offset && h_cnt < h_letter_third_offset) begin
            case (state)
                4'b0100: current_individual_number <= 4'd6;
                4'b0101: current_individual_number <= 4'd2;
                4'b0110: current_individual_number <= 4'd4;
                4'b0111: current_individual_number <= 4'd2;
                4'b1000: current_individual_number <= 4'd5;
                4'b1001: current_individual_number <= 4'd1;
                4'b1010: current_individual_number <= 4'd0;
                4'b1011: current_individual_number <= 4'd0;
                4'b1100: current_individual_number <= 4'd0;
                default: current_individual_number <= 4'b1111;
            endcase
        end else if (h_cnt >= h_letter_third_offset && h_cnt < h_letter_last_offset) begin
            case (state)
                4'b0111: current_individual_number <= 4'd8;
                4'b1000: current_individual_number <= 4'd6;
                4'b1001: current_individual_number <= 4'd2;
                4'b1010: current_individual_number <= 4'd2;
                4'b1011: current_individual_number <= 4'd4;
                4'b1100: current_individual_number <= 4'd9;
                default: current_individual_number <= 4'b1111;
            endcase
        end else if (h_cnt >= h_letter_last_offset && h_cnt < h_end_offset) begin
            case (state)
                4'b1010: current_individual_number <= 4'd4;
                4'b1011: current_individual_number <= 4'd8;
                4'b1100: current_individual_number <= 4'd6;
                default: current_individual_number <= 4'b1111;
            endcase
        end else begin
            current_individual_number <= 4'b1111;
        end
    end

    always @ (posedge clk) begin
        if (!rst) begin
            vga_data <= 12'd0;
        end
        else if (v_cnt >= v_letter_start_offset && v_cnt < v_letter_end_offset) begin
            vga_data <= vga_font_output[5'd15 - h_cnt_offset] == 1'b1 ? font_color : background_color;
        end else begin
            vga_data <= background_color;
        end
    end
    
endmodule