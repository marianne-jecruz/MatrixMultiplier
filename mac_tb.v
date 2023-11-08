`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 10:17:09 PM
// Design Name: 
// Module Name: mac_tb
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


module mac_tb;
    reg clk;
    reg [7:0] arrA, arrB [2:0];
    reg [7:0] a, b;
    wire [7:0] a_pass, b_pass, Mn_out;
    
    integer i, j, k;

    mac_unit cut(.clk(clk), .a(a), .b(b), .a_pass(a_pass), .b_pass(b_pass), .Mn_out(Mn_out));
    
    initial begin
        
        arrA[0] = 8'b00100000; //0.5
        arrA[1] = 8'b00100000; //0.5
        arrA[2] = 8'b00110000; //1
        
        arrB[0] = 8'b00110000; //1
        arrB[1] = 8'b01000100; //2.5
        arrB[2] = 8'b01000100; //2.5
    
        j = 0;
        clk = 0;
        a = 0;
        b = 0;
        
        for(i = 0; i < 10000; i = i+ 1) begin
            #10
            clk = ~clk;
            j = j + 1;
            if (j >= 10) begin
                a = arrA[k];
                b = arrB[k];
                k = k + 1;
                j = 0;
            end
        end
    end
    
endmodule
