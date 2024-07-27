//===================================================================
//
//	Module Name: timer_top
//
//	Features: 
//		1.Digital timer with day, hour, minute, and second display 
//  	2.Uses seven-segment displays(SSD) to show the time
//
//	Function:
//  	1.Double sync to handle asynchronous reset signal
//      2.Used counter to control BCD number
//
//	Author : Sheng Qian Li
//
//===================================================================

`timescale 1ns/100ps

//-----------------------------------------
//			BCD number define
//-----------------------------------------
`define ZERO  7'b1111110
`define ONE   7'b0110000
`define TWO   7'b1101101
`define THREE 7'b1111001
`define FOUR  7'b0110011
`define FIVE  7'b1011011
`define SIX   7'b1011111
`define SEVEN 7'b1110000
`define EIGHT 7'b1111111
`define NINE  7'b1111011

`include "dsyn_reset.v"
`include "ssd_sec_l.v"
`include "ssd_sec_h.v"
`include "ssd_min_l.v"
`include "ssd_min_h.v"
`include "ssd_hour_l.v"
`include "ssd_hour_h.v"
`include "ssd_day.v"

module timer_top(
	clk, 
	rst_n, 
	ssd_day, 
	ssd_hour_h, 
	ssd_hour_l, 
	ssd_min_h, 
	ssd_min_l, 
	ssd_sec_h, 
	ssd_sec_l
);


//-----------------------------------------
//				I/O port
//-----------------------------------------
input clk;              		//clock source                  
input rst_n;            		//active low asynchronous reset                     
		
output [6:0] ssd_day;   		//output seven segment display day                           
output [6:0] ssd_hour_h;		//output seven segment display hour high                                  
output [6:0] ssd_hour_l;		//output seven segment display hour low                                  
output [6:0] ssd_min_h; 		//output seven segment display hour high                                 
output [6:0] ssd_min_l; 		//output seven segment display hour low                              
output [6:0] ssd_sec_h; 		//output seven segment display hour high                                 
output [6:0] ssd_sec_l; 		//output seven segment display hour low                              		

//-----------------------------------------
//			Module wire 
//-----------------------------------------
wire dsyn_rst_n; 		//double sync wire           
wire temp0;      		//used to connnect top & double sync sub module        
wire [6:0] temp1;		//used to connnect top & submod_sec_l sub module           
wire [6:0] temp2;		//used to connnect top & submod_sec_h sub module              
wire [6:0] temp3;		//used to connnect top & submod_min_l sub module              
wire [6:0] temp4;		//used to connnect top & submod_min_h sub module              
wire [6:0] temp5;		//used to connnect top & submod_hour_l sub module              
wire [6:0] temp6;		//used to connnect top & submod_hour_h sub module             
wire [6:0] temp7;		//used to connnect top & submod_day sub module              


//-----------------------------------------
//			Output signals
//-----------------------------------------
assign dsyn_rst_n = temp0;
assign ssd_sec_l  = temp1;
assign ssd_sec_h  = temp2;
assign ssd_min_l  = temp3;
assign ssd_min_h  = temp4;
assign ssd_hour_l = temp5;
assign ssd_hour_h = temp6;
assign ssd_day    = temp7;


//-----------------------------------------
//	  Top module & Sub module connection
//-----------------------------------------
submod_dsyn_reset submod_dsyn_reset(
	.clk(clk),
	.rst_n(rst_n),
	.dsyn_rst_n(temp0)
);

submod_sec_l submod_sec_l(
	.clk(clk),
	.rst_n(rst_n),
	.dsyn_rst_n(temp0),
	.ssd_sec_l_sub(temp1)
);

submod_sec_h submod_sec_h(
	.clk(clk),
	.rst_n(rst_n),
	.dsyn_rst_n(temp0),
	.ssd_sec_l_sub(temp1),
	.ssd_sec_h_sub(temp2)
);

submod_min_l submod_min_l(
	.clk(clk),
	.rst_n(rst_n),
	.dsyn_rst_n(temp0),
	.ssd_sec_l_sub(temp1),
	.ssd_sec_h_sub(temp2),
	.ssd_min_l_sub(temp3)
);

submod_min_h submod_min_h(
	.clk(clk),
	.rst_n(rst_n),
	.dsyn_rst_n(temp0),
	.ssd_sec_l_sub(temp1),
	.ssd_sec_h_sub(temp2),
	.ssd_min_l_sub(temp3),
	.ssd_min_h_sub(temp4)
);

submod_hour_l submod_hour_l(
	.clk(clk),
	.rst_n(rst_n),
	.dsyn_rst_n(temp0),
	.ssd_sec_l_sub(temp1),
	.ssd_sec_h_sub(temp2),
	.ssd_min_l_sub(temp3),
	.ssd_min_h_sub(temp4),
	.ssd_hour_l_sub(temp5),
	.ssd_hour_h_sub(temp6)
);

submod_hour_h submod_hour_h(
	.clk(clk),
	.rst_n(rst_n),
	.dsyn_rst_n(temp0),
	.ssd_sec_l_sub(temp1),
	.ssd_sec_h_sub(temp2),
	.ssd_min_l_sub(temp3),
	.ssd_min_h_sub(temp4),
	.ssd_hour_l_sub(temp5),
	.ssd_hour_h_sub(temp6)
);

submod_day submod_day(
	.clk(clk),
	.rst_n(rst_n),
	.dsyn_rst_n(temp0),
	.ssd_sec_l_sub(temp1),
	.ssd_sec_h_sub(temp2),
	.ssd_min_l_sub(temp3),
	.ssd_min_h_sub(temp4),
	.ssd_hour_l_sub(temp5),
	.ssd_hour_h_sub(temp6),
	.ssd_day_sub(temp7)
);


endmodule




