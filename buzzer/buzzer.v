module buzzer (
    input wire clk,
    input wire rst,
    input wire[3:0] ready_from,
    input wire lose,
    output reg buzz
);

    reg[31:0] clk_cnt1;

    reg[31:0] en_cnt;

    always @ (posedge clk) begin
        if (!rst) begin
            en_cnt <= 'd0;
        end else if (ready_from != 4'b0000) begin
            en_cnt <= 'd1;
        end else if (en_cnt == 'd7500000) begin
            en_cnt <= 'd0;
        end else if (en_cnt != 'd0) begin
            en_cnt <= en_cnt + 'd1;
        end else begin
            en_cnt <= en_cnt;
        end
    end

    always @ (posedge clk) begin
        if (!rst) begin
            clk_cnt1 <= 'd0;
        end else if ((en_cnt != 'd0) && (clk_cnt1 == 'd0)) begin
            clk_cnt1 <= 'd1;
        end else if (clk_cnt1 == 'd126626) begin
            clk_cnt1 <= 'd1;
        end else if ((en_cnt != 'd0) && (clk_cnt1 != 'd0)) begin
            clk_cnt1 <= clk_cnt1 + 'd1;
        end else begin
            clk_cnt1 <= 'd0;
        end
    end

    always @ (posedge clk) begin
        if (!rst) begin
            buzz <= 'd0;
        end else if (clk_cnt1 == 'd126626) begin
            buzz <= ~buzz;
        end else begin
            buzz <= buzz;
        end
    end
    
endmodule