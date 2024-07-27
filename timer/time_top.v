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




//===================================================================
//
//	Module Name: submod_hour_l
//
//	Features: 
//		1.Digital timer with hour low display 
//  	2.Uses seven-segment displays(SSD) to show the time
//
//	Function:
//  	1.Used counter to control BCD number
//
//	Author : Sheng Qian Li
//
//===================================================================

`timescale 1ns/100ps

module submod_hour_l(
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
input [6:0]ssd_hour_h_sub;
input [6:0]ssd_sec_l_sub;
input [6:0]ssd_sec_h_sub;
input [6:0]ssd_min_l_sub;
input [6:0]ssd_min_h_sub;

output reg [6:0]ssd_hour_l_sub;		//hour low output display


//-----------------------------------------
//		        Counter
//-----------------------------------------
reg [3:0] counter;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		counter <= 0;
	end

	else if(counter == 3 && ssd_hour_h_sub == `TWO &&  ssd_min_h_sub == `FIVE && ssd_min_l_sub == `NINE &&  ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE)begin
		counter <= 0;
	end

	else if(counter < 9  &&  ssd_min_h_sub == `FIVE && ssd_min_l_sub == `NINE &&  ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE) begin
        counter <= counter + 1;
    end

	else if(counter == 9 &&  ssd_min_h_sub == `FIVE && ssd_min_l_sub == `NINE &&  ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE)begin
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
		ssd_hour_l_sub = 7'd0 ;
	end

	else begin
    	case (counter)
    	    4'b0000: ssd_hour_l_sub = `ZERO  ;
    	    4'b0001: ssd_hour_l_sub = `ONE   ;
    	    4'b0010: ssd_hour_l_sub = `TWO   ;
    	    4'b0011: ssd_hour_l_sub = `THREE ;
    	    4'b0100: ssd_hour_l_sub = `FOUR  ;
    	    4'b0101: ssd_hour_l_sub = `FIVE  ;
    	    4'b0110: ssd_hour_l_sub = `SIX   ;
    	    4'b0111: ssd_hour_l_sub = `SEVEN ;
    	    4'b1000: ssd_hour_l_sub = `EIGHT ;
    	    4'b1001: ssd_hour_l_sub = `NINE  ;
    	    default: ssd_hour_l_sub = 7'b0; 
    	endcase
	end
end

endmodule




//===================================================================
//
//	Module Name: submod_min_h
//
//	Features: 
//		1.Digital timer with minute high display 
//  	2.Uses seven-segment displays(SSD) to show the time
//
//	Function:
//  	1.Used counter to control BCD number
//
//	Author : Sheng Qian Li
//
//===================================================================

`timescale 1ns/100ps

module submod_min_h(
	clk, 
	rst_n,
	dsyn_rst_n,
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

output reg [6:0]ssd_min_h_sub;		//minute high output display


//-----------------------------------------
//		        Counter
//-----------------------------------------
reg[3:0] counter;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		counter <= 0;
	end

	else if(counter < 5 && ssd_min_l_sub == `NINE && ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE)begin
		counter <= counter + 1;
	end

	else if(counter == 5 && ssd_min_l_sub == `NINE && ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE) begin
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
		ssd_min_h_sub = 7'd0 ;
	end

	else begin
    	case (counter)
    	    4'b0000: ssd_min_h_sub = `ZERO  ;
    	    4'b0001: ssd_min_h_sub = `ONE   ;
    	    4'b0010: ssd_min_h_sub = `TWO   ;
    	    4'b0011: ssd_min_h_sub = `THREE ;
    	    4'b0100: ssd_min_h_sub = `FOUR  ;
    	    4'b0101: ssd_min_h_sub = `FIVE  ;
    	    default: ssd_min_h_sub = 7'b0; 
    	endcase
	end
end

endmodule




//===================================================================
//
//	Module Name: submod_min_l
//
//	Features: 
//		1.Digital timer with minute low display 
//  	2.Uses seven-segment displays(SSD) to show the time
//
//	Function:
//  	1.Used counter to control BCD number
//
//	Author : Sheng Qian Li
//
//===================================================================

`timescale 1ns/100ps

module submod_min_l(
	clk, 
	rst_n,
    dsyn_rst_n,  
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

output reg [6:0]ssd_min_l_sub;      //minute low output display

//-----------------------------------------
//		        Counter
//-----------------------------------------
reg [3:0] counter;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		counter <= 0;
	end

	else if(counter == 9 &&  ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE) begin
        counter <= 0;
    end

	else if(ssd_sec_h_sub == `FIVE && ssd_sec_l_sub == `NINE)begin
		counter <= counter + 1;
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
		ssd_min_l_sub = 7'd0 ;
	end

    else begin
        case (counter)
            4'b0000: ssd_min_l_sub = `ZERO  ;
            4'b0001: ssd_min_l_sub = `ONE   ;
            4'b0010: ssd_min_l_sub = `TWO   ;
            4'b0011: ssd_min_l_sub = `THREE ;
            4'b0100: ssd_min_l_sub = `FOUR  ;
            4'b0101: ssd_min_l_sub = `FIVE  ;
            4'b0110: ssd_min_l_sub = `SIX   ;
            4'b0111: ssd_min_l_sub = `SEVEN ;
            4'b1000: ssd_min_l_sub = `EIGHT ;
            4'b1001: ssd_min_l_sub = `NINE  ;
            default: ssd_min_l_sub = 7'b0; 
        endcase
    end
end

endmodule




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




//===================================================================
//
//	Module Name: submod_sec_l
//
//	Features: 
//		1.Digital timer with second low display 
//  	2.Uses seven-segment displays(SSD) to show the time
//
//	Function:
//  	1.Used counter to control BCD number
//
//	Author : Sheng Qian Li
//
//===================================================================

`timescale 1ns/100ps

module submod_sec_l(
	clk, 
	rst_n, 
    dsyn_rst_n, 
	ssd_sec_l_sub
);


//-----------------------------------------
//				I/O port
//-----------------------------------------
input clk;
input rst_n;
input dsyn_rst_n;

output reg [6:0] ssd_sec_l_sub;     //second low output display


//-----------------------------------------
//		        Counter
//-----------------------------------------
reg [3:0] counter;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		counter <= 0;
	end

    else if(dsyn_rst_n == 1) begin
	    if(counter == 9) begin
            counter <= 0;
        end

	    else begin
	    	counter <= counter + 1;
	    end
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
		ssd_sec_l_sub = 7'b0 ;
	end

    else begin
        case (counter)
            4'b0000: ssd_sec_l_sub = `ZERO  ;
            4'b0001: ssd_sec_l_sub = `ONE   ;
            4'b0010: ssd_sec_l_sub = `TWO   ;
            4'b0011: ssd_sec_l_sub = `THREE ;
            4'b0100: ssd_sec_l_sub = `FOUR  ;
            4'b0101: ssd_sec_l_sub = `FIVE  ;
            4'b0110: ssd_sec_l_sub = `SIX   ;
            4'b0111: ssd_sec_l_sub = `SEVEN ;
            4'b1000: ssd_sec_l_sub = `EIGHT ;
            4'b1001: ssd_sec_l_sub = `NINE  ;
            default: ssd_sec_l_sub = 7'b0; 
        endcase
    end
end

endmodule




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




