`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 01:30:22 AM
// Design Name: 
// Module Name: mac_unit
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


module mac_unit(clk, a, b, a_pass, b_pass, Mn_out);

    input wire clk;
    input wire [7:0] a, b;
    output reg [7:0] a_pass, b_pass, Mn_out;
    
    reg [7:0] accumulator_next;
    
    reg sign_a, sign_b;
    reg [2:0] exp_a, exp_b;
    reg [3:0] fract_a, fract_b;
    
    reg sign_out;
    reg [2:0] exp_out;
    reg [4:0] fract_out; //make this one bit larger for overflow
    reg [7:0] numToAdd;
    
    initial begin
        accumulator_next = 0;
    end
    
    //separate diff parts of floating point num
    always@(a, b) begin
        sign_a = a[7];
        sign_b = b[7];
        exp_a = {a[6], a[5], a[4]};
        exp_b = {b[6], b[5], b[4]};
        fract_a = {a[3], a[2], a[1], a[0]};
        fract_b = {b[3], b[2], b[1], b[0]};
    end
    
    always@(*) begin
        sign_out = sign_a ^ sign_b; //generate new sign bit
        exp_out = exp_a + exp_b - 3; //generate new exponent bits
        fract_out = fract_a * fract_b;
        
        if(fract_out[4])//true = fraction is too big, so increment exponent
            exp_out = exp_out + 1;
            
        numToAdd = {sign_out, exp_out, fract_out};
    end
    
    always@(numToAdd) begin
        accumulator_next = accumulator_next + numToAdd;
    end
    
    //synchronise accumulator register w clk
    always@(posedge clk) begin
        Mn_out <= accumulator_next;
        a_pass <= a; //CHECK IN TESTING: does this change the passed 
                     //value a clk cycle after a or b changes? (desired behavior)
        b_pass <= b;
    end
endmodule
