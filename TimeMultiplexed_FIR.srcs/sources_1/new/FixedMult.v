`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2021 12:17:29 PM
// Design Name: 
// Module Name: FixedMult
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
`define maxWI (WI1>WI2 ? (WI1): (WI2))
`define maxWF (WF1>WF2 ? (WF1): (WF2))

module FixedPointMult 
    #(parameter WI1 = 4, WF1 = 4,
    WI2 = 4, WF2 = 4,
    WIO = 4, WFO = 4,
    W1 = WI1+WF1,
    W2 = WI2+WF2,
    WO=WIO+WFO)
    (input RST,
    input signed [W1-1:0] in1,
    input signed [W2-1:0] in2,
    output reg signed [WO-1:0] out,
    output reg OVF
);
    parameter maxW = `maxWI + `maxWF;
    localparam multW = 2 * maxW;
    localparam multWI = 2 * `maxWI;
    localparam multWF = 2 * `maxWF;
    
    reg signed [`maxWI-1:0] in1I;
    reg signed [`maxWF-1:0] in1F;
    reg signed [`maxWI+`maxWF-1:0] in1A;
    
    reg signed [`maxWI-1:0] in2I;
    reg signed [`maxWF-1:0] in2F;
    reg signed [`maxWI+`maxWF-1:0] in2A;
    
    reg signed [(2*(maxW))-1:0] multA;

    reg signed [(2*`maxWI)-1:0] multAI;
    reg signed [(2*`maxWF)-1:0] multAF;

    reg signed [WIO-1:0] tempI;
    reg signed [WFO-1:0] tempF;

    always@(*) begin
        in1I = WI1==WI2 ? in1[W1-1:WF1] : WI1 > WI2 ? in1[W1-1:WF1] : WI1 < WI2  ? {{(WI2-WI1){in1[W1-1]}},in1[W1-1:WF1]} : in1[W1-1:WF1];
        in2I = WI1==WI2 ? in2[W2-1:WF2] : WI1 > WI2 ? {{(WI1-WI2){in2[W2-1]}},in2[W2-1:WF2]} : WI1 < WI2  ? in2[W2-1:WF2] : in2[W2-1:WF2];
        in1F = WF1==WF2 ? in1[WF1-1:0] : WF1 > WF2 ? in1[WF1-1:0] : WF1 <WF2 ? {in1[WF1-1:0],{(WF2-WF1){1'b0}}}  : in1[WF1-1:0];
        in2F = WF1==WF2 ? in2[WF2-1:0] : WF1 > WF2 ? {in2[WF2-1:0], {(WF1-WF2){1'b0}}} : WF1 <WF2 ? in2[WF2-1:0]  : in2[WF2-1:0];
        
        in1A = {in1I,in1F};
        in2A = {in2I,in2F};
        
        multA = in1A * in2A;
        
        {multAI,multAF} = multA;
        
        tempI = (WIO>multWI) ? {{(WIO-multWI){multAI[multWI-1]}},multAI[multWI-2:0]} : 
        (WIO==multWI) ? multAI[multWI-1:0] 
        : (WIO<multWI) ? {multAI[multWI-1], multAI[WIO-2:0]} : multAI[multWI-1:0];
        
        tempF = (WFO>multWF) ? {multAF[multWF-1:0],{(WFO-multWF){1'b0}}} : 
        (WFO==multWF) ? multAF[multWF-1:0] : 
        (WFO<multWF) ? multAF[multWF-1:multWF-WFO] : multAF[multWF-1:0];
        
        out = {tempI, tempF};

        OVF = (WIO>multWI) ? 0 
        : (WIO==multWI) ? (in1A[`maxWI+`maxWF-1] & in2A[`maxWI+`maxWF-1] & ~out[WO-1]) | (~in1A[`maxWI+`maxWF-1] &  ~in2A[`maxWI+`maxWF-1] & out[WO-1]) 
//        : (WIO<multWI) ? ~((in1A[`maxWI+`maxWF-1] & in2A[`maxWI+`maxWF-1] & (&multAI[multWI:WIO-1])) | (~in1A[`maxWI+`maxWF-1] & ~in2A[`maxWI+`maxWF-1] & ~(|multAI[multWI:WIO-1])))
        : (WIO<multWI) ? ~((multAI[multWI-1] & (&multAI[multWI-2:WIO-1])) | (~multAI[multWI-1] & ~(|multAI[multWI-2:WIO-1])))
        : 0;
    end
endmodule
