module Project_7_Segment_Top(
    input i_Clk,
    input i_Switch_1,
    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G);

    // Need one register to store the previous Switch state +
    // Need one register vector to store the current count
    // This version also includes a wire to use for debouncing the switch input
    reg[3:0] r_Count = 4'b0000;
    reg r_Switch_1 = 1'b0;
    wire w_Switch_1;

    // Need wires to connect the 7-segment decoder to the outputs
    wire w_Segment2_A;
    wire w_Segment2_B;
    wire w_Segment2_C;
    wire w_Segment2_D;
    wire w_Segment2_E;
    wire w_Segment2_F;
    wire w_Segment2_G;

    // Debounces the input from i_Switch_1 into w_Switch_1
    Debounce_Switch Debounce_Inst(
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_1),
        .o_Switch(w_Switch_1));
    
    // On the release of the switch, increment the count (9 ->0)
    always @(posedge i_Clk) begin
        // store the previous switch state in the register,
        r_Switch_1 <= w_Switch_1;

        // and if the switch then is just released (was 1, now 0), increment the count
        if(w_Switch_1 == 1'b0 && r_Switch_1 == 1'b1) begin
            if(r_Count == 4'b1001) begin
                r_Count <= 4'b0000;
            end else begin
                r_Count <= r_Count + 1;
            end
        end
    end

    // Connect the 7-segment decoder to the outputs
    Binary_To_7Segment Decoder_Inst(
        .i_Clk(i_Clk),
        .i_Binary_Num(r_Count),
        .o_Segment_A(w_Segment2_A),
        .o_Segment_B(w_Segment2_B),
        .o_Segment_C(w_Segment2_C),
        .o_Segment_D(w_Segment2_D),
        .o_Segment_E(w_Segment2_E),
        .o_Segment_F(w_Segment2_F),
        .o_Segment_G(w_Segment2_G)
    );

    // The Go Board has a common anode 7-segment display, so the outputs need to be inverted
    assign {o_Segment2_A, o_Segment2_B, o_Segment2_C, 
            o_Segment2_D, o_Segment2_E, o_Segment2_F, o_Segment2_G} = 
            {~w_Segment2_A, ~w_Segment2_B, ~w_Segment2_C, 
            ~w_Segment2_D, ~w_Segment2_E, ~w_Segment2_F, ~w_Segment2_G};
endmodule
    