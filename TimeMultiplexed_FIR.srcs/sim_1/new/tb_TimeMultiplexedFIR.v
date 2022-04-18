`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2021 08:31:00 AM
// Design Name: 
// Module Name: tb_TimeMultiplexed_FIR
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
module tb_TimeMultiplexed_FIR;
    parameter WI = 2, WF = 6;
    reg CLK, RST;
    reg topRegister, bottomRegister, outputRegister;
    reg [1:0] muxSel;
    reg signed [(WI+WF)-1:0] x, h0, h1, h2;
    wire signed [(WI+WF)-1:0] y;

    TimeMultiplexed_FIR #(.WI(WI),.WF(WF)) DUT (.CLK(CLK),.RST(RST),.topRegister(topRegister),.bottomRegister(bottomRegister),.outputRegister(outputRegister),.muxSel(muxSel),.x(x),.h0(h0),.h1(h1),.h2(h2),.y(y));
    
    parameter ClockPeriod = 10;
    initial CLK = 0;
    always #(ClockPeriod/2) CLK = ~CLK;
    
    integer c;
    initial begin
        c = $fopen("TimeMultiplexedFIR.txt");
    end
    reg [7:0] inputsList [3:0];
    reg [7:0] coeff [2:0];
    
    initial begin
        $readmemb("inputX.mem", inputsList);
        $readmemb("coeff.mem", coeff);
        h0 <= coeff[0]; h1 <= coeff[1]; h2 <= coeff[2]; RST = 1'b1;
        x <= 8'b00000000;
        @(posedge CLK) x <= 8'b00000000; muxSel = 'b00; topRegister = 1'b1;
        @(posedge CLK) x <= 8'b00000000; muxSel = 'b00; 
        @(posedge CLK) x <= 8'b00000000; muxSel = 'b00; 
        
        @(posedge CLK) x <= inputsList[0]; muxSel = 'b00; RST = 1'b0;
        topRegister = 1'b0;
        bottomRegister = 1'b1;
        @(posedge CLK) muxSel = 'b01; 
        @(posedge CLK) muxSel = 'b10; outputRegister = 1'b1; 
        @(posedge CLK) topRegister = 1'b1; $fwrite(c,"%b\n",y);
        bottomRegister = 1'b1;
        outputRegister = 1'b0;
        RST = 1'b1;
        
        @(posedge CLK) x <= inputsList[1]; muxSel = 'b00; RST = 1'b0;
        topRegister = 1'b0;
        bottomRegister = 1'b1;
        @(posedge CLK) muxSel = 'b01; 
        @(posedge CLK) muxSel = 'b10; outputRegister = 1'b1;
        @(posedge CLK) topRegister = 1'b1; $fwrite(c,"%b\n",y);
        bottomRegister = 1'b1;
        outputRegister = 1'b0;
        RST = 1'b1;
        
        @(posedge CLK) x <= inputsList[2]; muxSel = 'b00; RST = 1'b0;
        topRegister = 1'b0;
        bottomRegister = 1'b1;
        @(posedge CLK) muxSel = 'b01; 
        @(posedge CLK) muxSel = 'b10; outputRegister = 1'b1;
        @(posedge CLK) topRegister = 1'b1; $fwrite(c,"%b\n",y);
        bottomRegister = 1'b1;
        outputRegister = 1'b0;
        RST = 1'b1;
        
        @(posedge CLK) x <= inputsList[3]; muxSel = 'b00; RST = 1'b0;
        topRegister = 1'b0;
        bottomRegister = 1'b1;
        @(posedge CLK) muxSel = 'b01; 
        @(posedge CLK) muxSel = 'b10; outputRegister = 1'b1;
        @(posedge CLK) topRegister = 1'b1; $fwrite(c,"%b\n",y);
        bottomRegister = 1'b1;
        outputRegister = 1'b0;
        RST = 1'b1;
        
        #(ClockPeriod *6) $fclose(c); $finish;
    end
endmodule
