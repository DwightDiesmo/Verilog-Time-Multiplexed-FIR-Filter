`timescale 1ns / 1ps

//module RST_DFF #(parameter WI = 5, WF = 11)
//    (
//    input CLK, RST, 
//    input [(WI+WF)-1:0] D, 
//    output reg [(WI+WF)-1:0] Q
//    );
    
//    always @(posedge RST or D) begin
//        if(RST == 1) begin
//         Q <= 0; 
//        end
//        else begin
//         Q <= D;
//        end
//    end
//endmodule

module DFF #(parameter WI = 5, WF = 11)
    (
    input CLK,  EN, RST,
    input [(WI+WF)-1:0] D, 
    output reg [(WI+WF)-1:0] Q
    );
    
    initial begin Q = 0; end
    always @(posedge CLK, EN) begin
        if(EN) begin
            if (D != 0) begin
                Q <= D;
            end else begin
                Q <= 0;
            end
        end
    end
    always @(RST) begin
        if (RST) begin
            Q <= 0;
        end
    end
endmodule