//===================================================================
//
//	Module Name: submod_sec_h
//
//	Features: 
//		1.Digital timer with second high display 
//  	2.Uses seven-segment displays(SSD) to show the time
//
//	Function:
//  	1.Used counter to control BCD number
//
//	Author : Sheng Qian Li
//
//===================================================================

`timescale 1ns/100ps

module submod_sec_h(
	clk, 
	rst_n,
	dsyn_rst_n,  
	ssd_sec_h_sub, 
	ssd_sec_l_sub 
);


//-----------------------------------------
//				I/O port
//-----------------------------------------
input clk;
input rst_n;
input dsyn_rst_n;
input [6:0]ssd_sec_l_sub;

output reg [6:0]ssd_sec_h_sub;		//second high output display


//-----------------------------------------
//		        Counter
//-----------------------------------------
reg[3:0] counter;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		counter <= 0;
	end

	else if(counter < 5 && ssd_sec_l_sub == `NINE)begin
		counter <= counter + 1;
	end

	else if(ssd_sec_l_sub == `NINE) begin
		counter <= 0;
	end

	else begin
		counter <= counter;
	end
end


//-----------------------------------------
//		    Seven segment display
//-----------------------------------------
always @(*) begin
	if(!dsyn_rst_n) begin
		ssd_sec_h_sub = 7'd0 ;
	end

	else begin
    	case (counter)
    	    4'b0000: ssd_sec_h_sub = `ZERO  ;
    	    4'b0001: ssd_sec_h_sub = `ONE   ;
    	    4'b0010: ssd_sec_h_sub = `TWO   ;
    	    4'b0011: ssd_sec_h_sub = `THREE ;
    	    4'b0100: ssd_sec_h_sub = `FOUR  ;
    	    4'b0101: ssd_sec_h_sub = `FIVE  ;
    	    default: ssd_sec_h_sub = 7'b0; 
    	endcase
	end
end

endmodule




