`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:44:27 12/03/2014 
// Design Name: 
// Module Name:    directconnection 
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
module directconnection(
	input wire clk,
   input wire [7:0] sw,
	input wire [4:0] btn,
   output wire [7:0] Led,
	output wire [7:0] seg,
	output wire [3:0] an
   );
	wire add;
	wire sub;
	wire mul;
	wire div;
	wire rst;
	wire [6:0] inp;
	reg [15:0] cnt;

	assign inp = sw;
	assign Led = sw;
	
	LedDriver Display(.clk(clk), .value(cnt), .enable(4'b1111), .bcd(sw[7]), .SSEG_CA(seg), .SSEG_AN(an));
	ButtonDebounce add_button_debounce(.clk(clk), .sig(btn[0]), .pls(add));
	ButtonDebounce sub_button_debounce(.clk(clk), .sig(btn[4]), .pls(sub));
	ButtonDebounce mul_button_debounce(.clk(clk), .sig(btn[2]), .pls(mul));
	ButtonDebounce div_button_debounce(.clk(clk), .sig(btn[3]), .pls(div));
	ButtonDebounce rst_button_debounce(.clk(clk), .sig(btn[1]), .pls(rst));
	
	always @(posedge clk)
	begin
		if (add == 1'b1) 
			cnt <= cnt + inp;
		else if (sub == 1'b1)
			cnt <= cnt - inp;
		else if (mul == 1'b1)
			cnt <= cnt * inp;
		else if (div == 1'b1)
			cnt <= cnt / inp;
		else if (rst == 1'b1)
			cnt <= 15'b0;
	end
endmodule
