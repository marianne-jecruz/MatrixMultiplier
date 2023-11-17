`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2023 11:44:40 PM
// Design Name: 
// Module Name: matrix_multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module matrix_multiplier(
    clk, reset, start, 
    a00, a01, a02, a10, a11, a12, a20, a21, a22,
    b00, b01, b02, b10, b11, b12, b20, b21, b22, 
    M0_out, M1_out, M2_out, M3_out, M4_out,M5_out, M6_out, 
    M7_out, M8_out, done
    );
    
    input wire clk, reset, start;
    input wire [7:0] a00, a01, a02, a10, a11, a12, a20, a21, a22;
    input wire [7:0] b00, b01, b02, b10, b11, b12, b20, b21, b22;
    output wire [7:0] M0_out, M1_out, M2_out, M3_out, M4_out, M5_out, M6_out, M7_out, M8_out;
    output reg done;
    
    integer i, j, k;
    reg [7:0] a0_input;
    reg [7:0] b0_input;
    
    reg [7:0] a1_input;
    reg [7:0] b1_input;
    
    reg [7:0] a2_input;
    reg [7:0] b2_input;
    
    wire [7:0] A_arr0[2:0];
    wire [7:0] A_arr1[2:0];
    wire [7:0] A_arr2[2:0];
    
    wire [7:0] B_arr0[2:0];
    wire [7:0] B_arr1[2:0];
    wire [7:0] B_arr2[2:0];
    
    wire [7:0] a_pass[5:0];
    wire [7:0] b_pass[5:0];
    
    reg prop_flag1;
    reg prop_flag2;
    reg prop_flag1_nxt;
    reg prop_flag2_nxt;
    
    initial begin
        i = 0;
        j = 0;
        k = 0;
        
        done = 0;
        prop_flag1_nxt = 0;
        prop_flag2_nxt = 0;
    end
    
    //pass in A values by row
    assign A_arr0[0] = a00;
    assign A_arr0[1] = a01;
    assign A_arr0[2] = a02;
    
    assign A_arr1[0] = a10;
    assign A_arr1[1] = a11;
    assign A_arr1[2] = a12;
        
    assign A_arr2[0] = a20;
    assign A_arr2[1] = a21;
    assign A_arr2[2] = a22;
    
    //pass in B values by column
    assign B_arr0[0] = b00;
    assign B_arr0[1] = b10;
    assign B_arr0[2] = b20;
        
    assign B_arr1[0] = b01;
    assign B_arr1[1] = b11;
    assign B_arr1[2] = b21;
        
    assign B_arr2[0] = b02;
    assign B_arr2[1] = b12;
    assign B_arr2[2] = b22;
    
    always@(posedge clk) begin
        if(i <= 2) begin
            a0_input = A_arr0[i];
            b0_input = B_arr0[i];
            prop_flag1_nxt = 1;
            i = i + 1;
        end
        
    end
    
    always@(posedge clk) begin
        if(prop_flag1 && (j <= 2)) begin
            a1_input = A_arr1[j];
            b1_input = B_arr1[j];
            prop_flag2_nxt = 1;
            j = j + 1;
        end
        prop_flag1 = prop_flag1_nxt;
    end
    
    always@(posedge clk) begin
        if(prop_flag2 && (k <= 2)) begin
            a2_input = A_arr2[k];
            b2_input = B_arr2[k];
            k = k + 1;
        end
        prop_flag2 = prop_flag2_nxt;
    end
    
    mac_unit mac_units00(
        .clk(clk),
        .a(a0_input),
        .b(b0_input),
        .a_pass(a_pass[0]),
        .b_pass(b_pass[0]),
        .Mn_out(M0_out)
    );
    
    mac_unit mac_units10(
        .clk(clk),
        .a(a_pass[0]),
        .b(b1_input),
        .a_pass(a_pass[1]),
        .b_pass(b_pass[1]),
        .Mn_out(M1_out)
    );
    
    mac_unit mac_units20(
        .clk(clk),
        .a(a_pass[1]),
        .b(b2_input),
        .a_pass(a_pass[2]),
        .b_pass(b_pass[2]),
        .Mn_out(M2_out)
    );    
    
//    mac_unit mac_units01(
//        .clk(clk),
//        .a(a1_input),
//        .b(b_pass[0]),
//        .a_pass(a_pass[3]),
//        .b_pass(b_pass[3]),
//        .Mn_out(M3_out)
//    ); 
    
//    mac_unit mac_units11(
//        .clk(clk),
//        .a(a_pass[3]),
//        .b(b_pass[0]),
//        .a_pass(a_pass[4]),
//        .b_pass(b_pass[4]),
//        .Mn_out(M4_out)
//    ); 
    
//    mac_unit mac_units21(
//        .clk(clk),
//        .a(a_pass[4]),
//        .b(b_pass[2]),
//        .a_pass(a_pass[5]),
//        .b_pass(b_pass[5]),
//        .Mn_out(M5_out)
//    ); 
    
//    mac_unit mac_units02(
//        .clk(clk),
//        .a(a2_input),
//        .b(b_pass[3]),
//        .a_pass(a_pass[6]),
//        .b_pass(b_pass[6]),
//        .Mn_out(M6_out)
//    ); 
    
//    mac_unit mac_units12(
//        .clk(clk),
//        .a(a_pass[6]),
//        .b(b_pass[4]),
//        .a_pass(a_pass[7]),
//        .b_pass(b_pass[7]),
//        .Mn_out(M7_out)
//    ); 
    
//    mac_unit mac_units22(
//        .clk(clk),
//        .a(a_pass[7]),
//        .b(b_pass[5]),
//        .a_pass(a_pass[8]),
//        .b_pass(b_pass[8]),
//        .Mn_out(M8_out)
//    ); 
endmodule
