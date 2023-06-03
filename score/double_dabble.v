module double_dabble #(
    parameter W = 16
) (
    input wire clk,
    input wire[W-1:0] bin,
    output reg[W+(W-4)/3:0] bcd
);

    integer i, j;

    always @ (posedge clk) begin
        for (i = 0; i <= W+(W-4)/3; i=i+1) begin
            bcd[i] = 0;
        end
        bcd[W-1:0] = bin;
        for (i = 0; i <= W-4; i=i+1) begin
            for (j = 0; j <= i/3; j = j+1) begin
                if (bcd[W-i+4*j -: 4] > 4) begin
                    bcd[W-i+4*j -: 4] = bcd[W-i+4*j -: 4] + 4'd3;
                end
            end
        end
    end
    
endmodule