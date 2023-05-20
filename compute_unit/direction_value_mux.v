module direction_value_mux(
    input wire[3:0] signal_from,
    input wire[15:0] value_from,
    output wire[3:0] out
);

    assign out = (signal_from[3] == 1'b1) ? value_from[15:12] :
        (signal_from[2] == 1'b1) ? value_from[11:8] :
        (signal_from[1] == 1'b1) ? value_from[7:4] : value_from[3:0];
    
endmodule