module BCD_to_seven_seg(
    input wire[3:0] BCD_in,
    output reg[7:0] DISPLAY
);

    //input leading_zero;  first is 1,
    
    parameter ZERO  = 7'b0111111;
    parameter ONE   = 7'b0000110;
    parameter TWO   = 7'b1011011;
    parameter THREE = 7'b1001111;
    parameter FORE  = 7'b1100110;
    parameter FIVE  = 7'b1101101;
    parameter SIX   = 7'b1111101;
    parameter SEVEN = 7'b0000111;
    parameter EIGHT = 7'b1111111;
    parameter NINE  = 7'b1101111;
    parameter BLANK = 7'b0000000;
    
    
    always @(BCD_in)
        case(BCD_in)
            0 : DISPLAY       = ZERO;
            1 : DISPLAY       = ONE;
            2 : DISPLAY       = TWO;
            3 : DISPLAY       = THREE;
            4 : DISPLAY       = FORE;
            5 : DISPLAY       = FIVE;
            6 : DISPLAY       = SIX;
            7 : DISPLAY       = SEVEN;
            8 : DISPLAY       = EIGHT;
            9 : DISPLAY       = NINE;
            default : DISPLAY = BLANK;
        endcase
    
endmodule