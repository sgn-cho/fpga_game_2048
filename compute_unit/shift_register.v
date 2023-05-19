module shift_register(
    input wire clk,
    input wire rst,
    input wire mode,
    input wire preset,
    input wire[3:0] en_from,
    input wire[3:0] value_from,
    output reg[3:0] current_value
);

    always @ (posedge clk) begin
        if (rst == 1'b0) current_value <= 4'b0000;
        else if (preset == 1'b1) current_value <= value_from;
        else if (en_from != 4'b0000) begin
            if (mode == 1'b1) current_value <= current_value + 1;
            else current_value <= value_from;
        end
    end
    
endmodule