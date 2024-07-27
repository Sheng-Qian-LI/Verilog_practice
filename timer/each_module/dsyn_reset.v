//===================================================================
//
//	Module Name: submod_dsyn_reset
//
//	Features: 
//		1.Implement double sync
//
//	Function:
//  	1.Add a flip flop after reset
//
//	Author : Sheng Qian Li
//
//===================================================================

`timescale 1ns/100ps

module submod_dsyn_reset(
	clk, 
	rst_n, 
	dsyn_rst_n
);


//-----------------------------------------
//				I/O port
//-----------------------------------------
input clk;
input rst_n;

output reg dsyn_rst_n;


//-----------------------------------------
//				Double sync
//-----------------------------------------
reg sync_ff;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		sync_ff <= 0;
        dsyn_rst_n <= 0 ;
	end

	else begin
        sync_ff <= 1;
		dsyn_rst_n <= sync_ff;
	end
end


endmodule




