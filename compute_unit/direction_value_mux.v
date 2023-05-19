module direction_value_mux(
    input wire[3:0] signal_from,
    input wire[11:0] value_from,
    output wire[3:0] out
);

    assign out = (signal_from[3] == 1'b1) ? value_from[11:9] :
        (signal_from[2] == 1'b1) ? value_from[8:6] :
        (signal_from[1] == 1'b1) ? value_from[5:3] : value_from[2:0];
    
endmodule