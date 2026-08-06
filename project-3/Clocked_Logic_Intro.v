module Clocked_Logic_Intro(
    input i_Clk,
    input i_Switch_1,
    output o_LED_1);

    // Need two registers to store the current LED state and the previous Switch state
    reg r_LED_1 = 1'b0;
    reg r_Switch_1 = 1'b0;

    always @(posedge i_Clk) begin
        // store the previous switch state in the register,
        r_Switch_1 <= i_Switch_1;

        // then if the switch was just released (was 1, now 0), toggle LED state
        if(i_Switch_1 == 1'b0 && r_Switch_1 == 1'b1) begin
            r_LED_1 <= ~r_LED_1;
        end
    end

    // assign the LED output to the register value
    assign o_LED_1 = r_LED_1;
endmodule
