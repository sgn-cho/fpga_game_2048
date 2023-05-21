module board_tb();

    reg clk, rst, preset_ext;
    reg[3:0] preset_location, value_from_preset, ready_from;
    wire[63:0] done;

    board main_board(
        .clk(clk),
        .rst(rst),
        .preset_ext(preset_ext),
        .preset_location(preset_location),
        .value_from_preset(value_from_preset),
        .ready_from_global(ready_from),
        .total_current_state(done)
    );

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        preset_ext = 1'b0;
        preset_location = 4'b0000;
        value_from_preset = 4'b0010;
        ready_from = 4'b0000;
    end

    initial begin
        forever begin
            #10 clk = ~clk;
        end
    end

    initial begin
        #40 rst = 1'b1;
        #20 preset_location = 4'b0111;
        #20 preset_ext = 1'b1;
        #20 preset_ext = 1'b0;
        #20 preset_location = 4'b0110;
        #20 preset_ext = 1'b1;
        #20 preset_ext = 1'b0;
            value_from_preset = 4'b0001;
        #20 preset_location = 4'b1111;
        #20 preset_ext = 1'b1;
        #20 preset_ext = 1'b0;
        #20 preset_location = 4'b1110;
        #20 preset_ext = 1'b1;
        #20 preset_ext = 1'b0;
        #20 ready_from = 4'b1000;
        #20 ready_from = 4'b0000;
        #180 ready_from = 4'b0100;
        #20 ready_from = 4'b0000;
        #180 ready_from = 4'b0100;
        #20 ready_from = 4'b0000;
        #180 ready_from = 4'b0010;
        #20 ready_from = 4'b0000;
    end

endmodule