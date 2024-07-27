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




