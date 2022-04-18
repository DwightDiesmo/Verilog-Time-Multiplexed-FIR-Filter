`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2021 07:43:00 AM
// Design Name: 
// Module Name: TimeMultiplexed_FIR
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


module TimeMultiplexed_FIR #(parameter WI = 2, WF = 6)(
    input CLK, RST,
    input topRegister, bottomRegister, outputRegister,
    input [1:0] muxSel,
    input signed [(WI+WF)-1:0] x, h0, h1, h2,
    output signed [(WI+WF)-1:0] y
    );
    wire signed [(WI+WF)-1:0] dff1_out, dff2_out, mux1_out, mux2_out, mult_out, add_out, xdff_out;
    wire signed [(2*(WI+WF))-1:0] trueMultOut;
    wire signed [(2*(WI+WF)):0] trueAddOut;
    
    DFF #(.WI(WI),.WF(WF)) dff1 (.CLK(CLK),.EN(topRegister),.D(x),.Q(dff1_out));
    DFF #(.WI(WI),.WF(WF)) dff2 (.CLK(CLK),.EN(topRegister),.D(dff1_out),.Q(dff2_out));
    MUX3IN #(.WI(WI),.WF(WF)) mux1 (.CLK(CLK),.sel(muxSel),.in0(x),.in1(dff1_out),.in2(dff2_out),.out(mux1_out));
    MUX3IN #(.WI(WI),.WF(WF)) mux2 (.CLK(CLK),.sel(muxSel),.in0(h0),.in1(h1),.in2(h2),.out(mux2_out));
    

    FixedPointMult # (.WI1(WI), .WF1(WF), .WI2(WI), .WF2(WF), .WIO(2*WI), .WFO(2*WF))
    mult( .in1(mux1_out), .in2(mux2_out), .out(trueMultOut));  
    FixedPointAdder # (.WI1(2*WI), .WF1(2*WF), .WI2(WI), .WF2(WF), .WIO(WI), .WFO(WF))
    add( .in1(trueMultOut), .in2(xdff_out), .out(add_out) );    
    
    DFF #(.WI(WI),.WF(WF)) xdff (.CLK(CLK),.RST(RST),.EN(bottomRegister),.D(add_out),.Q(xdff_out));
    DFF #(.WI(WI),.WF(WF)) dff3 (.CLK(CLK),.EN(outputRegister),.D(add_out),.Q(y)); 
endmodule


