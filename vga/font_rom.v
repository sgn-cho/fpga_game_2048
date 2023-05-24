module font_rom(
    input wire clk,
    input wire[3:0] number,
    input wire[11:0] v_cnt,
    output reg[15:0] output_row
);

always @ (posedge clk) begin
    case (number)
        4'b0000: begin
            casex (v_cnt)
                5'b0000x | 5'b0001x : output_row <= 16'h0000;
                5'b0010x : output_row <= 16'b0011111111110000;
                5'b0011x : output_row <= 16'b1111000000111100;
                5'b0100x : output_row <= 16'b1111000000111100;
                5'b0101x : output_row <= 16'b1111000000111100;
                5'b0110x : output_row <= 16'b1111000011111100;
                5'b0111x : output_row <= 16'b1111001111111100;
                5'b1000x : output_row <= 16'b1111111100111100;
                5'b1001x : output_row <= 16'b1111110000111100;
                5'b1010x : output_row <= 16'b1111000000111100;
                5'b1011x : output_row <= 16'b1111000000111100;
                5'b1100x : output_row <= 16'b0011111111110000;
                default :  output_row <= 16'b0000000000000000;
            endcase
        end
        4'b0001: begin
            casex (v_cnt)
                5'b0000x | 5'b0001x : output_row <= 16'h0000;
                5'b0010x : output_row <= 16'b0000001111000000;
                5'b0011x : output_row <= 16'b0000111111000000;
                5'b0100x : output_row <= 16'b0011111111000000;
                5'b0101x : output_row <= 16'b0000001111000000;
                5'b0110x : output_row <= 16'b0000001111000000;
                5'b0111x : output_row <= 16'b0000001111000000;
                5'b1000x : output_row <= 16'b0000001111000000;
                5'b1001x : output_row <= 16'b0000001111000000;
                5'b1010x : output_row <= 16'b0000001111000000;
                5'b1011x : output_row <= 16'b0011111111111100;
                default  : output_row <= 16'b0000000000000000;
            endcase
        end
        4'b0010: begin
            casex (v_cnt)
                5'b0000x | 5'b0001x : output_row <= 16'h0000;
                5'b0010x : output_row <= 16'b0011111111111100;
                5'b0011x : output_row <= 16'b1111000000111100;
                5'b0100x : output_row <= 16'b0000000000111100;
                5'b0101x : output_row <= 16'b0000000011110000;
                5'b0110x : output_row <= 16'b0000001111000000;
                5'b0111x : output_row <= 16'b0000111100000000;
                5'b1000x : output_row <= 16'b0011110000000000;
                5'b1001x : output_row <= 16'b1111000000000000;
                5'b1010x : output_row <= 16'b1111000000111100;
                5'b1011x : output_row <= 16'b1111111111111100;
                default  : output_row <= 16'b0000000000000000;
            endcase
        end
        4'b0011: begin
            casex (v_cnt)
                5'b0000x | 5'b0001x : output_row <= 16'h0000;
                5'b0010x : output_row <= 16'b0011111111110000;
                5'b0011x : output_row <= 16'b1111000000111100;
                5'b0100x : output_row <= 16'b0000000000111100;
                5'b0101x : output_row <= 16'b0000000000111100;
                5'b0110x : output_row <= 16'b0000111111110000;
                5'b0111x : output_row <= 16'b0000000000111100;
                5'b1000x : output_row <= 16'b0000000000111100;
                5'b1001x : output_row <= 16'b0000000000111100;
                5'b1010x : output_row <= 16'b1111000000111100;
                5'b1011x : output_row <= 16'b0011111111110000;
                default  : output_row <= 16'b0000000000000000;
            endcase
        end
        4'b0100: begin
            casex (v_cnt)
                5'b0000x | 5'b0001x : output_row <= 16'h0000;
                5'b0010x : output_row <= 16'b0000000011110000;
                5'b0011x : output_row <= 16'b0000001111110000;
                5'b0100x : output_row <= 16'b0000111111110000;
                5'b0101x : output_row <= 16'b0011110011110000;
                5'b0110x : output_row <= 16'b1111000011110000;
                5'b0111x : output_row <= 16'b1111111111111100;
                5'b1000x : output_row <= 16'b0000000011110000;
                5'b1001x : output_row <= 16'b0000000011110000;
                5'b1010x : output_row <= 16'b0000000011110000;
                5'b1011x : output_row <= 16'b0000001111111100;
                default  : output_row <= 16'b0000000000000000;
            endcase
        end
        4'b0101: begin
            casex (v_cnt)
                5'b0000x | 5'b0001x : output_row <= 16'h0000;
                5'b0010x : output_row <= 16'b1111111111111100;
                5'b0011x : output_row <= 16'b1111000000000000;
                5'b0100x : output_row <= 16'b1111000000000000;
                5'b0101x : output_row <= 16'b1111000000000000;
                5'b0110x : output_row <= 16'b1111111111110000;
                5'b0111x : output_row <= 16'b0000000000111100;
                5'b1000x : output_row <= 16'b0000000000111100;
                5'b1001x : output_row <= 16'b0000000000111100;
                5'b1010x : output_row <= 16'b1111000000111100;
                5'b1011x : output_row <= 16'b0011111111110000;
                default  : output_row <= 16'b0000000000000000;
            endcase
        end
        4'b0110: begin
            casex (v_cnt)
                5'b0000x | 5'b0001x : output_row <= 16'h0000;
                5'b0010x : output_row <= 16'b0000111111000000;
                5'b0011x : output_row <= 16'b0011110000000000;
                5'b0100x : output_row <= 16'b1111000000000000;
                5'b0101x : output_row <= 16'b1111000000000000;
                5'b0110x : output_row <= 16'b1111111111110000;
                5'b0111x : output_row <= 16'b1111000000111100;
                5'b1000x : output_row <= 16'b1111000000111100;
                5'b1001x : output_row <= 16'b1111000000111100;
                5'b1010x : output_row <= 16'b1111000000111100;
                5'b1011x : output_row <= 16'b0011111111110000;
                default  : output_row <= 16'b0000000000000000;
            endcase
        end
        4'b0111: begin
            casex (v_cnt)
                5'b0000x | 5'b0001x : output_row <= 16'h0000;
                5'b0010x : output_row <= 16'b1111111111111100;
                5'b0011x : output_row <= 16'b1111000000111100;
                5'b0100x : output_row <= 16'b0000000000111100;
                5'b0101x : output_row <= 16'b0000000000111100;
                5'b0110x : output_row <= 16'b0000000011110000;
                5'b0111x : output_row <= 16'b0000001111000000;
                5'b1000x : output_row <= 16'b0000111100000000;
                5'b1001x : output_row <= 16'b0000111100000000;
                5'b1010x : output_row <= 16'b0000111100000000;
                5'b1011x : output_row <= 16'b0000111100000000;
                default  : output_row <= 16'b0000000000000000;
            endcase
        end
        4'b1000: begin
            casex (v_cnt)
                5'b0000x | 5'b0001x : output_row <= 16'h0000;
                5'b0010x : output_row <= 16'b0011111111110000;
                5'b0011x : output_row <= 16'b1111000000111100;
                5'b0100x : output_row <= 16'b1111000000111100;
                5'b0101x : output_row <= 16'b1111000000111100;
                5'b0110x : output_row <= 16'b0011111111110000;
                5'b0111x : output_row <= 16'b1111000000111100;
                5'b1000x : output_row <= 16'b1111000000111100;
                5'b1001x : output_row <= 16'b1111000000111100;
                5'b1010x : output_row <= 16'b1111000000111100;
                5'b1011x : output_row <= 16'b0011111111110000;
                default  : output_row <= 16'b0000000000000000;
            endcase
        end
        4'b1001: begin
            casex (v_cnt)
                5'b0000x | 5'b0001x : output_row <= 16'h0000;
                5'b0010x : output_row <= 16'b0011111111110000;
                5'b0011x : output_row <= 16'b1111000000111100;
                5'b0100x : output_row <= 16'b1111000000111100;
                5'b0101x : output_row <= 16'b1111000000111100;
                5'b0110x : output_row <= 16'b0011111111111100;
                5'b0111x : output_row <= 16'b0000000000111100;
                5'b1000x : output_row <= 16'b0000000000111100;
                5'b1001x : output_row <= 16'b0000000000111100;
                5'b1010x : output_row <= 16'b0000000000111100;
                5'b1011x : output_row <= 16'b0011111111110000;
                default  : output_row <= 16'b0000000000000000;
            endcase
        end
        default: 
            output_row <= 16'h0000;
    endcase
end

endmodule