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
    
    //bits for the next value of the accumulator register
    reg accumulator_s;
    reg [2:0] accumulator_exp;
    reg [4:0] accumulator_fract;//make this one bit larger for overflow;
    reg [7:0] numToAdd;
    
    reg sign_a, sign_b, sign_out;
    reg [2:0] exp_a, exp_b, exp_out;
    reg [3:0] fract_a, fract_b;
    reg [4:0] fract_out; //make this one bit larger for overflow;
    
    wire exp_lt, exp_gt, exp_eq;
    wire fract_lt, fract_gt, fract_eq;
    
    initial begin
        accumulator_s = 0;
        accumulator_exp = 0;
        accumulator_fract = 0;
    end
    
    //separate diff parts of floating point num
    always@(a, b) begin
        if(a == 0) begin
            numToAdd = 8'b0;
        end
        else if(b == 0) begin
            numToAdd = 8'b0;
        end
        else begin
            sign_a = a[7];
            sign_b = b[7];
            exp_a = {a[6], a[5], a[4]};
            exp_b = {b[6], b[5], b[4]};
            fract_a = {a[3], a[2], a[1], a[0]};
            fract_b = {b[3], b[2], b[1], b[0]};
        end
    end
    
    //Multiply a and b 
    always@(*) begin
        sign_out = sign_a ^ sign_b; //generate new sign bit
        exp_out = exp_a + exp_b - 3; //generate new exponent bits
        
        fract_out = fract_a * fract_b;
        if(fract_out[4])begin//true = fraction is too big, so increment exponent
            fract_out = fract_out >> 1;
            exp_out = exp_out + 1;
        end
            
        numToAdd = {sign_out, exp_out, fract_out[3:0]};
    end
    
    //Add product of a and b to running sum
    always@(numToAdd) begin
    
        //make exponents the same for addition/subtraction
        while(!(accumulator_exp == exp_out)) begin
            if(accumulator_exp < exp_out)begin
                accumulator_fract = accumulator_fract >> 1;
                accumulator_exp = accumulator_exp + 1;
            end
            else if(accumulator_exp > exp_out) begin
                fract_out = fract_out >> 1;
                exp_out = exp_out + 1;
            end
        end
    
        //if both sign bits are the same == add fraction bits
        if(accumulator_s ~^ sign_out) begin
            accumulator_s = accumulator_s & sign_out; //compute sign bit
            
            //add fraction bits
            accumulator_fract = accumulator_fract + fract_out;
            if(accumulator_fract[4])begin //overflow
                accumulator_fract = accumulator_fract >> 1;
                accumulator_exp = accumulator_exp + 1;
            end
        end
        
        //sign bits are different == which one has bigger fraction & subtract 
        else begin
            if(accumulator_fract < fract_out) begin
                accumulator_fract = fract_out - accumulator_fract;
                accumulator_s = sign_out;
            end
            else if(accumulator_fract > fract_out) begin
                accumulator_fract = accumulator_fract - fract_out;
                //accumulator sign stays the same
            end
            else if(accumulator_fract == fract_out) begin
                accumulator_fract = 0;
                accumulator_exp = 0;
                accumulator_s = 0;
            end
        end
    end
    
    //synchronise accumulator register w clk
    always@(posedge clk) begin
        Mn_out <= {accumulator_s, accumulator_exp, accumulator_fract[3:0]};
        a_pass <= a; //CHECK IN TESTING: does this change the passed 
                     //value a clk cycle after a or b changes? (desired behavior)
        b_pass <= b;
    end
endmodule
