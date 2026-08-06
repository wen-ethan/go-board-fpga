module Debounce_Project_Top(
    input i_Clk,
    input i_Switch_1,
    output o_LED_1);

    // Need two registers to store the current LED state and the previous Switch state
    // This version also includes a wire to use for debouncing the switch input
    reg r_LED_1 = 1'b0;
    reg r_Switch_1 = 1'b0;
    wire w_Switch_1;

    // Debounces the input from i_Switch_1 into w_Switch_1
    Debounce_Switch Debounce_Inst(
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_1),
        .o_Switch(w_Switch_1));

    always @(posedge i_Clk) begin
        // store the previous switch state in the register,
        r_Switch_1 <= w_Switch_1;

        // then if the switch was just released (was 1, now 0), toggle LED state
        if(w_Switch_1 == 1'b0 && r_Switch_1 == 1'b1) begin
            r_LED_1 <= ~r_LED_1;
        end
    end

    // assign the LED output to the register value
    assign o_LED_1 = r_LED_1;
endmodule
