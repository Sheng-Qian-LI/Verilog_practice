module seqdetector(clock, reset_n, seq_in, valid_in, match, full);

input clock;
input reset_n;
input seq_in;
input valid_in;

output reg match;
output reg full;

reg[3:0] current_state, next_state;
reg[3:0] counter;

parameter IDLE = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

parameter FULL_NUM = 8;

always@(*) begin
	case(current_state)

		IDLE : if(seq_in == 1 && valid_in == 1) next_state = S1;
			   else next_state = IDLE;
		
		S1 : if(seq_in == 0 && valid_in == 1) next_state = S2;
			 else next_state = S1;
		
		S2 : if(seq_in == 1 && valid_in == 1) next_state = S3;
			 else if(seq_in == 0 && valid_in == 1) next_state = IDLE;
			 else next_state = S2;

		S3 : if(seq_in == 1 && valid_in == 1) next_state = S4;
			 else if(seq_in == 0 && valid_in == 1) next_state = S2;
			 else next_state = S3;

   		S4 : if(seq_in == 1 && valid_in == 1) next_state = S1;
			 else next_state = IDLE;

		default next_state = IDLE;
	endcase
end

always@(posedge clock or negedge reset_n) begin
	if(!reset_n) begin
		current_state <= IDLE;
	end

	else begin
		current_state <= next_state;
	end
end

always@(posedge clock or negedge reset_n) begin
	if(!reset_n) begin
		match <= 0;			
	end

	else if(current_state == S4) begin
		match <= 1;
	end

	else begin
		match <= 0;
	end
end

always@(posedge clock or negedge reset_n) begin
	if(!reset_n) begin
		full <= 0;
	end

	else if(counter == FULL_NUM - 1  && current_state == S4) begin
		full <= 1; 
	end

	else if(full == 1)begin;
		full <= 1;
	end
	
	else begin
		full <= 0;
	end
end

always@(posedge clock or negedge reset_n) begin
	if(!reset_n) begin
		counter <= 0;
	end

	else if(current_state == S4) begin
		counter <= counter + 1;
	end

	else if(counter == 8) begin
		counter <=0;
	end

	else begin
		counter <= counter;
	end
end

endmodule