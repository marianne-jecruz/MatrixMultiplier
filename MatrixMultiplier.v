module matrix_multiplier(clk, reset, A, B, result);
    input wire clk, reset;
    input wire [7:0] A[2:0][2:0], B[2:0][2:0];
    output reg [7:0] result[2:0][2:0];

    wire [7:0] acc[2:0][2:0];
    wire [7:0] A_pass[2:0][2:0], B_pass[2:0][2:0];

    mac_unit mac_units00(
        .clk(clk),
        .a(A_pass[0][0], A_pass[0][1], A_pass[0][2]),
        .b(B_pass[0][0], B_pass[1][0], B_pass[2][0]),
        .a_pass(A_pass[0][0], A_pass[0][1], A_pass[0][2]),
        .b_pass(B_pass[0][0], B_pass[1][0], B_pass[2][0]),
        .Mn_out(acc[0][0])
    );

    mac_unit mac_units01(
        .clk(clk),
        .a(A_pass[0][1], A_pass[0][2], A_pass[0][0]),
        .b(B_pass[0][1], B_pass[1][1], B_pass[2][1]),
        .a_pass(A_pass[0][1], A_pass[0][2], A_pass[0][0]),
        .b_pass(B_pass[0][1], B_pass[1][1], B_pass[2][1]),
        .Mn_out(acc[0][1])
    );

    mac_unit mac_units02(
        .clk(clk),
        .a(A_pass[0][2], A_pass[0][0], A_pass[0][1]),
        .b(B_pass[0][2], B_pass[1][2], B_pass[2][2]),
        .a_pass(A_pass[0][2], A_pass[0][0], A_pass[0][1]),
        .b_pass(B_pass[0][2], B_pass[1][2], B_pass[2][2]),
        .Mn_out(acc[0][2])
    );

    mac_unit mac_units10(
        .clk(clk),
        .a(A_pass[1][0], A_pass[1][1], A_pass[1][2]),
        .b(B_pass[0][0], B_pass[1][0], B_pass[2][0]),
        .a_pass(A_pass[1][0], A_pass[1][1], A_pass[1][2]),
        .b_pass(B_pass[0][0], B_pass[1][0], B_pass[2][0]),
        .Mn_out(acc[1][0])
    );

    mac_unit mac_units11(
        .clk(clk),
        .a(A_pass[1][1], A_pass[1][2], A_pass[1][0]),
        .b(B_pass[0][1], B_pass[1][1], B_pass[2][1]),
        .a_pass(A_pass[1][1], A_pass[1][2], A_pass[1][0]),
        .b_pass(B_pass[0][1], B_pass[1][1], B_pass[2][1]),
        .Mn_out(acc[1][1])
    );

    mac_unit mac_units12(
        .clk(clk),
        .a(A_pass[1][2], A_pass[1][0], A_pass[1][1]),
        .b(B_pass[0][2], B_pass[1][2], B_pass[2][2]),
        .a_pass(A_pass[1][2], A_pass[1][0], A_pass[1][1]),
        .b_pass(B_pass[0][2], B_pass[1][2], B_pass[2][2]),
        .Mn_out(acc[1][2])
    );

    mac_unit mac_units20(
        .clk(clk),
        .a(A_pass[2][0], A_pass[2][1], A_pass[2][2]),
        .b(B_pass[0][0], B_pass[1][0], B_pass[2][0]),
        .a_pass(A_pass[2][0], A_pass[2][1], A_pass[2][2]),
        .b_pass(B_pass[0][0], B_pass[1][0], B_pass[2][0]),
        .Mn_out(acc[2][0])
    );

    mac_unit mac_units21(
        .clk(clk),
        .a(A_pass[2][1], A_pass[2][2], A_pass[2][0]),
        .b(B_pass[0][1], B_pass[1][1], B_pass[2][1]),
        .a_pass(A_pass[2][1], A_pass[2][2], A_pass[2][0]),
        .b_pass(B_pass[0][1], B_pass[1][1], B_pass[2][1]),
        .Mn_out(acc[2][1])
    );

    mac_unit mac_units22(
        .clk(clk),
        .a(A_pass[2][2], A_pass[2][0], A_pass[2][1]),
        .b(B_pass[0][2], B_pass[1][2], B_pass[2][2]),
        .a_pass(A_pass[2][2], A_pass[2][0], A_pass[2][1]),
        .b_pass(B_pass[0][2], B_pass[1][2], B_pass[2][2]),
        .Mn_out(acc[2][2])
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset accumulator registers
            result[0][0] <= 8'b0;
            result[0][1] <= 8'b0;
            result[0][2] <= 8'b0;
            result[1][0] <= 8'b0;
            result[1][1] <= 8'b0;
            result[1][2] <= 8'b0;
            result[2][0] <= 8'b0;
            result[2][1] <= 8'b0;
            result[2][2] <= 8'b0;
        end else begin
            // Update result registers
            result[0][0] <= acc[0][0];
            result[0][1] <= acc[0][1];
            result[0][2] <= acc[0][2];
            result[1][0] <= acc[1][0];
            result[1][1] <= acc[1][1];
            result[1][2] <= acc[1][2];
            result[2][0] <= acc[2][0];
            result[2][1] <= acc[2][1];
            result[2][2] <= acc[2][2];
        end
    end
endmodule
