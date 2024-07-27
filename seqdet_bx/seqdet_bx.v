//===================================================================
//
//	Module Name: seqdet_bx
//
//	Features:
//		1.Convert 4-bit data (nibble) input into 8-bit data output.
//		2.After detect data_rx = 1101, the next 4 bits of data should be placed in the low 4 bits of the output 8 bits.  	
//
//	Function:
//  	1.Use 4-state FSM to implement funtion.
//      2.When the valid_rx is de-asserted data_out remain at the last. 
//
//	Author : Sheng Qian Li
//
//===================================================================

`timescale 1ns/100ps

module seqdet_bx(
	clk, 
	rst_n, 
	valid_rx, 
	data_rx, 
	sfd_det, 
	valid_out,
	data_out
);

//-----------------------------------------
//				I/O port
//-----------------------------------------
input clk;							//clock source  
input rst_n;						//active low asynchronous reset  
input valid_rx;           			//active high to indicate data on data_rx is valid
input [3:0] data_rx;      			//input data     

output reg sfd_det;       			//active high to indicate SFD (4’hD) is detected. Remains high until valid_rx is de-asserted                
output reg valid_out;     			//active high to indicate 8 bit output data is valid              
output reg [7:0] data_out;			//output data                                    


//-----------------------------------------
//FSM combinational next state always block
//-----------------------------------------
reg[2:0] current_state, next_state;

parameter IDLE = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

always@(*) begin
	case(current_state)

		IDLE : if(valid_rx == 1 && data_rx == 4'b1101) next_state = S1;              //When valid_rx is high and detect data_rx = 1101,then go to the  S1                                                                                                
			   else next_state = IDLE;                                                                                                              
                               
		S1 : if(valid_rx == 1) next_state = S2;                                      //save the first 4 bits to a reg                                                                        
			 else next_state = IDLE;                                                                                                              
                                
		S2 : if(valid_rx == 1) next_state = S3;                                      //save the first 4 bits and the second 4 bits to a reg ,then combiate to 8 bits data                                                                        
			 else next_state = IDLE;                                                                                                              
                    
		S3 : if(valid_rx == 1) next_state = S2;                                      //output data                                                                        
			 else next_state = IDLE;

		default next_state = IDLE;
	endcase
end

//-----------------------------------------
//	  next state to stste always block
//-----------------------------------------

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		current_state <= IDLE;
	end

	else begin
		current_state <= next_state;
	end
end


//-----------------------------------------
//		sequential always block
//-----------------------------------------
reg [3:0] data_across;				//save the first 4 bits 

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		data_across <= 0;			
	end

	else if(current_state == S1) begin
		data_across <= data_rx;
	end

	else begin
		data_across <= data_rx;
	end
end


reg [7:0] data_across_2;			//save the total 8 bits

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		data_across_2 <= 0;			
	end

	else if(current_state == S2) begin
		if(valid_rx == 1) data_across_2 <= {data_rx, data_across};
		else data_across_2 <= data_across_2;
	end

	else begin
		data_across_2 <= data_across_2;
	end
end


//-----------------------------------------
//		output always block
//-----------------------------------------
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		data_out <= 0;			
	end

	else begin
		data_out <= data_across_2;
	end
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		sfd_det <= 0;
	end

	else if(next_state == IDLE) begin
		sfd_det <= 0;
	end

	else if(current_state == S1)begin;
		sfd_det <= 1;
	end

	else if(current_state == S2)begin;
		if(valid_rx == 1) sfd_det <= 1;
		else sfd_det <= 0;
	end

	else if(current_state == S3)begin;
		if(valid_rx == 1) sfd_det <= 1;
		else sfd_det <= 0;
	end

	else begin
		sfd_det <= 0;
	end
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		valid_out <= 0;
	end

	else if(current_state == IDLE) begin
		valid_out <= 0;
	end

	else if(current_state == S3)begin;
		valid_out <= 1;
	end
	
	else begin
		valid_out <= 0;
	end
end

endmodule