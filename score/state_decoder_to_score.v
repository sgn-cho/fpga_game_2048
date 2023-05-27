module state_decoder_to_score (
    input wire clk,
    input wire rst,
    input wire[3:0] current_state,
    output reg[3:0] decoded_value
);

    parameter tmp_bit = 16'b0000_0000_0000_0001;

    always @ (posedge clk) begin
        if (!rst) decoded_value <= 4'b0;
        else begin
            decoded_value = (current_state == 4'd0) ? 4'b0 :
                (current_state == 4'd1) ? tmp_bit << 1 :
                (current_state == 4'd2) ? tmp_bit << 2 :
                (current_state == 4'd3) ? tmp_bit << 3 :
                (current_state == 4'd4) ? tmp_bit << 4 :
                (current_state == 4'd5) ? tmp_bit << 5 :
                (current_state == 4'd6) ? tmp_bit << 6 :
                (current_state == 4'd7) ? tmp_bit << 7 :
                (current_state == 4'd8) ? tmp_bit << 8 :
                (current_state == 4'd9) ? tmp_bit << 9 :
                (current_state == 4'd10) ? tmp_bit << 10 :
                (current_state == 4'd11) ? tmp_bit << 11 :
                (current_state == 4'd12) ? tmp_bit << 12 :
                (current_state == 4'd13) ? tmp_bit << 13 :
                (current_state == 4'd14) ? tmp_bit << 14 : 4'b0;
        end
    end
    
endmodule