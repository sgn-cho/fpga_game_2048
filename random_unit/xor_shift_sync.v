module xor_shift_sync (
    input wire clk,
    input wire rst,
    input wire[31:0] seed,
    output wire[3:0] rand
);

    reg[31:0] raw_rand;

    wire[31:0] tmp = raw_rand ^ raw_rand >> 7;
    wire[31:0] tmp_2 = tmp ^ tmp << 9;
    wire[31:0] tmp_3 = tmp_2 ^ tmp_2 >> 13;

    assign rand = raw_rand[3:0];

    always @ (posedge clk) begin
        if (rst == 1'b0) raw_rand <= seed;
        else raw_rand <= tmp_3;
    end

endmodule