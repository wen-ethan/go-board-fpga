module UART_RX_To_7_Seg_Top(
    input i_Clk,
    input i_UART_RX,

    // Segment 1 is the left digit, Segment 2 is the right digit
    output o_Segment1_A,
    output o_Segment1_B,
    output o_Segment1_C,
    output o_Segment1_D,
    output o_Segment1_E,
    output o_Segment1_F,
    output o_Segment1_G,
    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G);

    reg [7:0] r_RX_Byte;
    wire w_RX_DV;

    wire w_Segment1_A, w_Segment2_A;
    wire w_Segment1_B, w_Segment2_B;
    wire w_Segment1_C, w_Segment2_C;
    wire w_Segment1_D, w_Segment2_D;
    wire w_Segment1_E, w_Segment2_E;
    wire w_Segment1_F, w_Segment2_F;
    wire w_Segment1_G, w_Segment2_G;
    
    UART_RX #(.CLKS_PER_BIT(217)) UART_RX_Inst(
        .i_Clock(i_Clk),
        .i_RX_Serial(i_UART_RX),
        .o_RX_DV(w_RX_DV),
        .o_RX_Byte(r_RX_Byte));
    
    // Connect the 7-segment decoder to the outputs
    Binary_To_7Segment Decoder_Inst1(
        .i_Clk(i_Clk),
        .i_Binary_Num(r_RX_Byte[7:4]),
        .o_Segment_A(w_Segment1_A),
        .o_Segment_B(w_Segment1_B),
        .o_Segment_C(w_Segment1_C),
        .o_Segment_D(w_Segment1_D),
        .o_Segment_E(w_Segment1_E),
        .o_Segment_F(w_Segment1_F),
        .o_Segment_G(w_Segment1_G));

    Binary_To_7Segment Decoder_Inst2(
        .i_Clk(i_Clk),
        .i_Binary_Num(r_RX_Byte[3:0]),
        .o_Segment_A(w_Segment2_A),
        .o_Segment_B(w_Segment2_B),
        .o_Segment_C(w_Segment2_C),
        .o_Segment_D(w_Segment2_D),
        .o_Segment_E(w_Segment2_E),
        .o_Segment_F(w_Segment2_F),
        .o_Segment_G(w_Segment2_G));

        assign {o_Segment1_A, o_Segment1_B, o_Segment1_C, 
                o_Segment1_D, o_Segment1_E, o_Segment1_F, o_Segment1_G} = 
               {~w_Segment1_A, ~w_Segment1_B, ~w_Segment1_C, 
                ~w_Segment1_D, ~w_Segment1_E, ~w_Segment1_F, ~w_Segment1_G};

        assign {o_Segment2_A, o_Segment2_B, o_Segment2_C, 
                o_Segment2_D, o_Segment2_E, o_Segment2_F, o_Segment2_G} = 
               {~w_Segment2_A, ~w_Segment2_B, ~w_Segment2_C, ~w_Segment2_D, 
                ~w_Segment2_E, ~w_Segment2_F, ~w_Segment2_G};
endmodule
