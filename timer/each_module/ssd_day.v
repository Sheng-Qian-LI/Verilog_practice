//===================================================================
//
//	Module Name: submod_day
//
//	Features: 
//		1.Digital timer with day display 
//  	2.Uses seven-segment displays(SSD) to show the time
//
//	Function:
//  	1.Used counter to control BCD number
//
//	Author : Sheng Qian Li
//
//===================================================================

`timescale 1ns/100ps

module submod_day(
	clk, 
	rst_n,
	dsyn_rst_n,
	ssd_day_sub,
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
input [6:0]ssd_hour_h_sub;

output reg [6:0]ssd_day_sub;		//day output display


//-----------------------------------------
//		        Counter
//-----------------------------------------
reg[3:0] counter;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		counter <= 0;
	end

	else if(counter < 9 && ssd_hour_h_sub ==`TWO && ssd_hour_l_sub ==`THREE &&  ssd_min_h_sub == `FIVE && ssd_min_l_sub == `NINE && ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE)begin
		counter <= counter + 1;
	end

	else if(counter == 9 && ssd_hour_h_sub ==`TWO && ssd_hour_l_sub ==`THREE &&  ssd_min_h_sub == `FIVE && ssd_min_l_sub == `NINE && ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE) begin
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
		ssd_day_sub = 7'd0 ;
	end

	else begin
    	case (counter)
    	    4'b0000: ssd_day_sub = `ZERO  ;
    	    4'b0001: ssd_day_sub = `ONE   ;
    	    4'b0010: ssd_day_sub = `TWO   ;
    	    4'b0011: ssd_day_sub = `THREE ;
    	    4'b0100: ssd_day_sub = `FOUR  ;
    	    4'b0101: ssd_day_sub = `FIVE  ;
    	    4'b0110: ssd_day_sub = `SIX   ;
    	    4'b0111: ssd_day_sub = `SEVEN ;
    	    4'b1000: ssd_day_sub = `EIGHT ;
    	    4'b1001: ssd_day_sub = `NINE  ;
    	    default: ssd_day_sub = 7'b0; 
    	endcase
	end
end

endmodule




