`timescale 1ns / 1ps

module MUX3IN #(parameter WI = 2, WF = 6)(
    input CLK,
    input [1:0] sel, // 2-bit Select
    input [(WI+WF)-1:0] in0,in1,in2, 
    output reg [(WI+WF)-1:0] out
    );
    
    always@(sel,in0,in1,in2)begin
        if(sel == 2'b00)begin
            out <= in0;
        end
    
        else if(sel == 2'b01)begin
            out <= in1;
        end

        else if(sel == 2'b10)begin
            out <= in2;
        end
    end
endmodule