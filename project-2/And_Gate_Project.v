module And_Gate_Project(
    input i_Switch_1,
    input i_Switch_2,
    output o_LED_1,

    // these pins are not used in this project, but they are included to avoid strange behavior on the board
    output o_LED_2,
    output o_LED_3,
    output o_LED_4);

    assign o_LED_1 = i_Switch_1 & i_Switch_2;

    // added these pins and set them to 0 to avoid strange behavior on the board
    assign o_LED_2 = 1'b0;
    assign o_LED_3 = 1'b0;
    assign o_LED_4 = 1'b0;

endmodule