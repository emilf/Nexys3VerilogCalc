`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:31:49 12/08/2014 
// Design Name: 
// Module Name:    ButtonDebounce 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


`define CLOG2(x) \
    (x >= 'h100000 ? 20 : \
     x >= 'h80000 ? 19 : \
     x >= 'h40000 ? 18 : \
     x >= 'h20000 ? 17 : \
     x >= 'h10000 ? 16 : \
     x >= 'h8000 ? 15 : \
     x >= 'h4000 ? 14 : \
     x >= 'h2000 ? 13 : \
     x >= 'h1000 ? 12 : \
     x >= 'h800 ? 11 : \
     x >= 'h400 ? 10 : \
     x >= 'h200 ? 9 : \
     x >= 'h100 ? 8 : \
     x >= 'h80 ? 7 : \
     x >= 'h40 ? 6 : \
     x >= 'h20 ? 5 : \
     x >= 'h10 ? 4 : \
     x >= 'h8 ? 3 : \
     x >= 'h4 ? 2 : 1)

module ButtonDebounce
    #(
        parameter NR_OF_CLKS=4096,
        localparam COUNTER_WIDTH=`CLOG2(NR_OF_CLKS)
    )
    (
        input wire clk,
        input wire sig,
        output wire pls
    );
    
    reg [COUNTER_WIDTH-1:0] counter = {COUNTER_WIDTH{1'b0}};
    reg lastSig = 1'b0;
    reg stable = 1'b0;
    reg lastStable = 1'b0;
    
    assign pls = ((lastStable == 1'b0) && (stable == 1'b1)) ? 1'b1 : 1'b0;

    always @(posedge clk)
    begin
        if (sig == lastSig)
        begin
            // Count the number of clock signals the signal is stable
            if (counter == NR_OF_CLKS-1)
                stable <= lastSig;
            else
                counter <= counter + 1'b1;
        end
        else
        begin
            // Reset the counter and store the current signal value
            counter <= {COUNTER_WIDTH{1'b0}};
            lastSig <= sig;
        end
    end
    
    always @(posedge clk)
    begin
        lastStable <= stable;
    end

endmodule
