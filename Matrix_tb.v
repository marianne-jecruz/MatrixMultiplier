`timescale 1ns / 1ps


module Systolic_Matrix_tb();
    reg clk;
    reg start; 
    reg reset;
    reg [7:0] a00, a01, a02, a10, a11, a12, a20, a21, a22;
    reg [7:0] b00, b01, b02, b10, b11, b12, b20, b21, b22;
    
    wire done;
    wire [7:0] M1_out, M2_out, M3_out, M4_out, M5_out, M6_out, M7_out, M8_out, M9_out;
    
    initial begin
        clk = 0;
        start = 0;
        reset = 0;
        a00 = 0;
        b00 = 0;
    end
    
    always #5 clk = ~clk;
    
    initial begin
        reset = 1;
        a00 = 8'b00100000; a01 = 8'b00100000; a02 = 8'b00110000;    //  0.5   0.5    1
        a10 = 8'b00100000; a11 = 8'b00110000; a12 = 8'b10111000;    //  0.5    1   -1.5
        a20 = 8'b10010000; a21 = 8'b00100000; a22 = 8'b00110000;    // -0.25  0.5    1
    
        b00 = 8'b00110000; b01 = 8'b01000100; b02 = 8'b01000100;    //  1   2.5  2.5
        b10 = 8'b00110000; b11 = 8'b00110000; b12 = 8'b00110000;    //  1    1    1
        b20 = 8'b00110000; b21 = 8'b00100000; b22 = 8'b00100000;    //  1   0.5  0.5
        
//        c00 = 8'b01000000; c01 = 8'b01000010; c02 = 8'b01000010;    //  2     2.25    2.25
//        c10 = 8'b00000000; c11 = 8'b00111000; c12 = 8'b00111000;    //  0     1.5     1.5
//        c20 = 8'b00110100; c01 = 8'b00100000; c02 = 8'b00100000;    //  1.25   0.5    0.5
        
        
        #10;
        reset = 0;
        
        #100;
        start = 1;
     
    end
    
    Matrix DUT( clk, 
                reset, 
                start, 
                a00, 
                a01, 
                a02, 
                a10, 
                a11, 
                a12, 
                a20, 
                a21, 
                a22, 
                b00, 
                b01, 
                b02, 
                b10, 
                b11, 
                b12, 
                b20, 
                b21, 
                b22,
                //make sure the above wires/ports are identicaly
                
                //You can choose not to have below wires/ports in your design
                M1_out, 
                M2_out, 
                M3_out, 
                M4_out, 
                M5_out, 
                M6_out, 
                M7_out, 
                M8_out, 
                M9_out, 
                done); 
    
endmodule
