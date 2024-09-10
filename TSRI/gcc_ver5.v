
module gcc (
	CLK, 
	RESET_, 
	Xi, 
	Yi, 
	Wi, 
	READY_, 
	Xc, 
	Yc
);

input CLK;
input RESET_;
input [7:0] Xi;
input [7:0] Yi;
input [3:0] Wi;

output READY_;
output [7:0] Xc;
output [7:0] Yc;

reg [7:0] X_1;
reg [7:0] X_2;
reg [7:0] X_3;
reg [7:0] X_4;
reg [7:0] X_5;
reg [7:0] X_6;

reg [7:0] X1;
reg [7:0] X2;
reg [7:0] X3;
reg [7:0] X4;
reg [7:0] X5;
reg [7:0] X6;

reg [7:0] Y_1;
reg [7:0] Y_2;
reg [7:0] Y_3;
reg [7:0] Y_4;
reg [7:0] Y_5;
reg [7:0] Y_6;

reg [7:0] Y1;
reg [7:0] Y2;
reg [7:0] Y3;
reg [7:0] Y4;
reg [7:0] Y5;
reg [7:0] Y6;

reg [3:0] W_1;
reg [3:0] W_2;
reg [3:0] W_3;
reg [3:0] W_4;
reg [3:0] W_5;
reg [3:0] W_6;

reg [3:0] W1;
reg [3:0] W2;
reg [3:0] W3;
reg [3:0] W4;
reg [3:0] W5;
reg [3:0] W6;

reg [2:0] counter;

reg [15:0] dist_1;
reg [15:0] dist_2;
reg [15:0] dist_3;
reg [15:0] dist_4;
reg [15:0] dist_5;
reg [15:0] dist_6;

reg [15:0] dist_max;

reg [15:0] dist1_2_max;
reg [15:0] dist3_4_max;
reg [15:0] dist5_6_max;
reg [15:0] dist1_2_3_4_max;

reg [7:0] dist1_2_X;
reg [7:0] dist3_4_X;
reg [7:0] dist5_6_X;
reg [7:0] dist1_2_3_4_X;

reg [7:0] dist1_2_Y;
reg [7:0] dist3_4_Y;
reg [7:0] dist5_6_Y;
reg [7:0] dist1_2_3_4_Y;

reg [3:0] dist1_2_W;
reg [3:0] dist3_4_W;
reg [3:0] dist5_6_W;
reg [3:0] dist1_2_3_4_W;

reg [2:0]dist1_2;
reg [2:0]dist3_4;
reg [2:0]dist5_6;
reg [2:0]dist1_2_3_4;
reg [2:0]dist;


reg [8:0] W_sum;
reg [15:0] X_sum;
reg [15:0] Y_sum;
reg [15:0] xc_wait;
reg [15:0] yc_wait;
reg [7:0] x_final;
reg [7:0] y_final;
reg [7:0] xc;
reg [7:0] yc;
reg READY;

//-----------------------------------------
//	          Output READY_
//-----------------------------------------
always@(posedge CLK or negedge RESET_) begin
	if(!RESET_) begin
		READY <= 1;
	end

	else if(counter < 1) begin
		READY <= 1;
	end

	else begin
		READY <= 0;
	end
	
end

assign READY_ = READY;

//-----------------------------------------
//	          Output Xc, Yc
//-----------------------------------------
/*
always@(posedge CLK or negedge RESET_) begin
	if(!RESET_) begin
		Xc <= 0;
		Yc <= 0;
	end
	else  begin
		Xc <= (((X1 * W1) + (X2 * W2) + (X3 * W3) + (X4 * W4) + (X5 * W5) + (X6 * W6)) + ((W1 + W2 + W3 + W4 + W5 + W6)/2)) / (W1 + W2 + W3 + W4 + W5 + W6);
		Yc <= (((Y1 * W1) + (Y2 * W2) + (Y3 * W3) + (Y4 * W4) + (Y5 * W5) + (Y6 * W6)) + ((W1 + W2 + W3 + W4 + W5 + W6)/2)) / (W1 + W2 + W3 + W4 + W5 + W6);
	end
end
*/

always@(posedge CLK or negedge RESET_) begin
	if(!RESET_) begin
		W_sum <= 0;
	end
	else  begin
		W_sum <= W1 + W2 + W3 + W4 + W5 + W6;
	end
end

always@(posedge CLK or negedge RESET_) begin
	if(!RESET_) begin
		X_sum <= 0;
		Y_sum <= 0;
	end
	else  begin
		X_sum <= (X1 * W1) + (X2 * W2) + (X3 * W3) + (X4 * W4) + (X5 * W5) + (X6 * W6);
		Y_sum <= (Y1 * W1) + (Y2 * W2) + (Y3 * W3) + (Y4 * W4) + (Y5 * W5) + (Y6 * W6);
	end
end

always@(*) begin
	xc_wait = X_sum + W_sum / 2;
	yc_wait = Y_sum + W_sum / 2;
end

always@(*) begin
	xc = xc_wait / W_sum;
	yc = xc_wait / W_sum;
end

always@(posedge CLK or negedge RESET_) begin
	if(!RESET_) begin
		x_final <= 0;
		y_final <= 0;
	end
	else  begin
		x_final <= xc;
		y_final <= yc;
	end
end

assign Xc = x_final;
assign Yc = y_final;

//-----------------------------------------
//	             counter
//-----------------------------------------
always@(posedge CLK or negedge RESET_) begin
	if(!RESET_) begin
		counter <= 0;
	end

	else if(counter < 6) begin
		counter <= counter + 1;
	end
	
	else begin
		counter <= counter;
	end
end


//-----------------------------------------
//	               X_
//-----------------------------------------
always@(posedge CLK or negedge RESET_) begin
	if(!RESET_) begin
		X_1 <= 0;
		X_2 <= 0;
		X_3 <= 0;
		X_4 <= 0;
		X_5 <= 0;
		X_6 <= 0;
	end
	else begin
		X_1 <= X1;
		X_2 <= X2;
		X_3 <= X3;
		X_4 <= X4;
		X_5 <= X5;
		X_6 <= X6;
	end
  end

  
//-----------------------------------------
//	               Y_
//-----------------------------------------
always@(posedge CLK or negedge RESET_) begin
	if(!RESET_) begin
		Y_1 <= 0;
		Y_2 <= 0;
		Y_3 <= 0;
		Y_4 <= 0;
		Y_5 <= 0;
		Y_6 <= 0;
	end
	else begin
		Y_1 <= Y1;
		Y_2 <= Y2;
		Y_3 <= Y3;
		Y_4 <= Y4;
		Y_5 <= Y5;
		Y_6 <= Y6;
	end
  end


//-----------------------------------------
//	               W_
//-----------------------------------------
always@(posedge CLK or negedge RESET_) begin
	if(!RESET_) begin
		W_1 <= 0;
		W_2 <= 0;
		W_3 <= 0;
		W_4 <= 0;
		W_5 <= 0;
		W_6 <= 0;
	end
	else begin
	 	W_1 <= W1;
		W_2 <= W2;
		W_3 <= W3;
		W_4 <= W4;
		W_5 <= W5;
		W_6 <= W6;
	end
  end


//-----------------------------------------
//	             dist_max
//-----------------------------------------
always@(*)begin	
    dist_1 = (X_1 - Xc) * (X_1 - Xc) + (Y_1 - Yc) * (Y_1 - Yc);
    dist_2 = (X_2 - Xc) * (X_2 - Xc) + (Y_2 - Yc) * (Y_2 - Yc);
    dist_3 = (X_3 - Xc) * (X_3 - Xc) + (Y_3 - Yc) * (Y_3 - Yc);
    dist_4 = (X_4 - Xc) * (X_4 - Xc) + (Y_4 - Yc) * (Y_4 - Yc);
    dist_5 = (X_5 - Xc) * (X_5 - Xc) + (Y_5 - Yc) * (Y_5 - Yc);
    dist_6 = (X_6 - Xc) * (X_6 - Xc) + (Y_6 - Yc) * (Y_6 - Yc);
end


always @(*) begin

        if (dist_1 > dist_2 || (dist_1 == dist_2 && (X_1 < X_2 || (X_1 == X_2 && (Y_1 < Y_2 || (Y_1 == Y_2 && W_1 <= W_2)))))) begin
			dist1_2 = 3'd1;
            dist1_2_max = dist_1;
            dist1_2_X = X_1;
            dist1_2_Y = Y_1;
            dist1_2_W = W_1;
        end
        else begin
			dist1_2 = 3'd2;
            dist1_2_max = dist_2;
            dist1_2_X = X_2;
            dist1_2_Y = Y_2;
            dist1_2_W = W_2;
        end

end

always @(*) begin
        if (dist_3 > dist_4 || (dist_3 == dist_4 && (X_3 < X_4 || (X_3 == X_4 && (Y_3 < Y_4 || (Y_3 == Y_4 && W_3 <= W_4)))))) begin
			dist3_4 = 3'd3;
            dist3_4_max = dist_3;
            dist3_4_X = X_3;
            dist3_4_Y = Y_3;
            dist3_4_W = W_3;
        end
        else begin
			dist3_4 = 3'd4;
            dist3_4_max = dist_4;
            dist3_4_X = X_4;
            dist3_4_Y = Y_4;
            dist3_4_W = W_4;
        end

end

always @(*) begin

        if (dist_5 > dist_6 || (dist_5 == dist_6 && (X_5 < X_6 || (X_5 == X_6 && (Y_5 < Y_6 || (Y_5 == Y_6 && W_5 <= W_6)))))) begin
            dist5_6 = 3'd5;
			dist5_6_max = dist_5;
            dist5_6_X = X_5;
            dist5_6_Y = Y_5;
            dist5_6_W = W_5;
        end
        else begin
			dist5_6 = 3'd6;
            dist5_6_max = dist_6;
            dist5_6_X = X_6;
            dist5_6_Y = Y_6;
            dist5_6_W = W_6;
        end

end

always @(*) begin

        if (dist1_2_max > dist3_4_max || (dist1_2_max == dist3_4_max && (dist1_2_X < dist3_4_X || (dist1_2_X == dist3_4_X && (dist1_2_Y < dist3_4_Y || (dist1_2_Y == dist3_4_Y && dist1_2_W <= dist3_4_W)))))) begin
			dist1_2_3_4 = dist1_2;
            dist1_2_3_4_max = dist1_2_max;
            dist1_2_3_4_X = dist1_2_X;
            dist1_2_3_4_Y = dist1_2_Y;
            dist1_2_3_4_W = dist1_2_W;
        end
        else begin
			dist1_2_3_4 = dist3_4;
            dist1_2_3_4_max = dist3_4_max;
            dist1_2_3_4_X = dist3_4_X;
            dist1_2_3_4_Y = dist3_4_Y;
            dist1_2_3_4_W = dist3_4_W;
        end

end

always @(*) begin

        if (dist1_2_3_4_max > dist5_6_max || (dist1_2_3_4_max == dist5_6_max && (dist1_2_3_4_X < dist5_6_X || (dist1_2_3_4_Y == dist5_6_Y && (dist1_2_3_4_Y < dist5_6_Y || (dist1_2_3_4_Y == dist5_6_Y && dist1_2_3_4_W <= dist5_6_W)))))) begin
            dist = dist1_2_3_4;
			dist_max = dist1_2_3_4_max;
        end
        else begin
			dist = dist5_6;
            dist_max = dist5_6_max;
        end

end

//-----------------------------------------
//	             change X
//-----------------------------------------
always @(*) begin
	if(counter > 5) begin
        if(dist == 3'd1) begin
			X1 = Xi;
		end
		else begin
			X1 = X_1 ;
		end

		if(dist == 3'd2) begin
			X2 = Xi;
		end
		else begin
			X2 = X_2 ;
		end

		if(dist == 3'd3) begin
			X3 = Xi;
		end
		else begin
			X3 = X_3 ;
		end

		if(dist == 3'd4) begin
			X4 = Xi;
		end
		else begin
			X4 = X_4 ;
		end

		if(dist == 3'd5) begin
			X5 = Xi;
		end
		else begin
			X5 = X_5 ;
		end

		if(dist == 3'd6) begin
			X6 = Xi;
		end
		else begin
			X6 = X_6 ;
		end
	end

	else begin
		X1 = Xi;
		X2 = X_1;
		X3 = X_2;
		X4 = X_3;
		X5 = X_4;
		X6 = X_5;
	end
end

//-----------------------------------------
//	             change Y
//-----------------------------------------
always @(*) begin
	if(counter > 5) begin
        if(dist == 3'd1) begin
			Y1 = Yi;
		end
		else begin
			Y1 = Y_1 ;
		end

		if(dist == 3'd2) begin
			Y2 = Yi;
		end
		else begin
			Y2 = Y_2 ;
		end

		if(dist == 3'd3) begin
			Y3 = Yi;
		end
		else begin
			Y3 = Y_3 ;
		end

		if(dist == 3'd4) begin
			Y4 = Yi;
		end
		else begin
			Y4 = Y_4 ;
		end

		if(dist == 3'd5) begin
			Y5 = Yi;
		end
		else begin
			Y5 = Y_5 ;
		end

		if(dist == 3'd6) begin
			Y6 = Yi;
		end
		else begin
			Y6 = Y_6 ;
		end
	end

	else begin
		Y1 = Yi;
		Y2 = Y_1;
		Y3 = Y_2;
		Y4 = Y_3;
		Y5 = Y_4;
		Y6 = Y_5;
	end
end

//-----------------------------------------
//	             change W
//-----------------------------------------
always @(*) begin
	if(counter > 5) begin
        if(dist == 3'd1) begin
			W1 = Wi;
		end
		else begin
			W1 = W_1 ;
		end

		if(dist == 3'd2) begin
			W2 = Wi;
		end
		else begin
			W2 = W_2 ;
		end

		if(dist == 3'd3) begin
			W3 = Wi;
		end
		else begin
			W3 = W_3 ;
		end

		if(dist == 3'd4) begin
			W4 = Wi;
		end
		else begin
			W4 = W_4 ;
		end

		if(dist == 3'd5) begin
			W5 = Wi;
		end
		else begin
			W5 = W_5 ;
		end

		if(dist == 3'd6) begin
			W6 = Wi;
		end
		else begin
			W6 = W_6 ;
		end
	end

	else begin
		W1 = Wi;
		W2 = W_1;
		W3 = W_2;
		W4 = W_3;
		W5 = W_4;
		W6 = W_5;
	end
end


endmodule






