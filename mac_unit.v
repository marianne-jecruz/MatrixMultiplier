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
    reg [3:0] accumulator_fract;
    reg [7:0] numToAdd;
    
    reg sign_a, sign_b, sign_out;
    reg [2:0] exp_a, exp_b, exp_out;
    reg [4:0] fract_a, fract_b;//one more bit for leading 1
    reg [3:0] fract_out; //make this one bit larger for overflow;
    
    reg [11:0] product_reg;
    reg [11:0] sum_reg;
    reg [7:0] exp_reg; //bigger for overflow
    
    reg [7:0] accumulator_all;
    reg [7:0] Mn_out_next;
    reg [7:0] a_pass_next;
    reg [7:0] b_pass_next;
    
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
            fract_a = {1'b1, a[3], a[2], a[1], a[0]};//add leading 1
            fract_b = {1'b1, b[3], b[2], b[1], b[0]};//add leading 1
        end
    end
    
    //MULTIPLY a and b 
    always@(sign_a, sign_b, exp_a, exp_b, fract_a, fract_b) begin
        sign_out = sign_a ^ sign_b; //generate new sign bit
        exp_reg = exp_a + exp_b; //generate new biased exponent bits
    
        product_reg = fract_a * fract_b;
        while(product_reg >= 32) begin
            product_reg = product_reg >> 1;
            exp_reg = exp_reg + 1;
        end
        exp_reg = exp_reg + 1; //for some reason, exponent is 1 off if we stop shifting when >= 32 (4 bits for fraction)
        exp_out = exp_reg[2:0];
        
        fract_out = product_reg[3:0];
            
        numToAdd = {sign_out, exp_out, fract_out};
    
    //ADD product of a and b to running sum
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
            sum_reg = accumulator_fract + fract_out;
            while(sum_reg >= 16) begin
                sum_reg = sum_reg >> 1;
                exp_reg = exp_reg + 1;
            end
            accumulator_fract = sum_reg[3:0];
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
        accumulator_all = {accumulator_s, accumulator_exp, accumulator_fract[3:0]};
    end
    
    //synchronise accumulator register w clk
    always@(posedge clk) begin
        Mn_out_next <= accumulator_all;
        a_pass_next <= a; 
        b_pass_next <= b;
    end
    
    always@(posedge clk) begin
        Mn_out <= Mn_out_next;
        a_pass <= a_pass_next;
        b_pass <= b_pass_next;
    end

endmodule
