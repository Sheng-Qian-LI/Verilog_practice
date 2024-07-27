//===================================================================
//
//	Module Name: submod_hour_h
//
//	Features: 
//		1.Digital timer with hour high display 
//  	2.Uses seven-segment displays(SSD) to show the time
//
//	Function:
//  	1.Used counter to control BCD number
//
//	Author : Sheng Qian Li
//
//===================================================================

`timescale 1ns/100ps

module submod_hour_h(
	clk, 
	rst_n,
	dsyn_rst_n,
	ssd_hour_h_sub,
	ssd_hour_l_sub,
	ssd_min_h_sub, 
	ssd_min_l_sub,  
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
input [6:0]ssd_sec_h_sub;
input [6:0]ssd_min_l_sub;
input [6:0]ssd_min_h_sub;
input [6:0]ssd_hour_l_sub;

output reg [6:0]ssd_hour_h_sub;		//hour high output display


//-----------------------------------------
//		        Counter
//-----------------------------------------
reg[1:0] counter;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		counter <= 0;
	end

	else if(counter < 2 && ssd_hour_l_sub ==`NINE &&  ssd_min_h_sub == `FIVE && ssd_min_l_sub == `NINE && ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE)begin
		counter <= counter + 1;
	end

	else if(counter == 2 && ssd_hour_l_sub ==`THREE &&  ssd_min_h_sub == `FIVE && ssd_min_l_sub == `NINE && ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE) begin
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
		ssd_hour_h_sub = 7'd0 ;
	end

	else begin
    	case (counter)
    	    2'b00: ssd_hour_h_sub = `ZERO  ;
    	    2'b01: ssd_hour_h_sub = `ONE   ;
    	    2'b10: ssd_hour_h_sub = `TWO   ;
    	    2'b11: ssd_hour_h_sub = `THREE ;
    	    default: ssd_hour_h_sub = 7'b0; 
    	endcase
	end
end

endmodule




