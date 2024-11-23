//===================================================================
//
//	Module Name: Gravity Center Calculate(GCC)
//
//	Features: 
//		1.System frequnecy 33MHz
//  	2.Round to an integer
//
//	Function:
//  	1.Calculate 6 points gravity center
//      2.Input Xi & Yi is from 0 to 255, Wi is from  0 to 15
//
//	Author : Sheng Qian Li
//
//===================================================================

module gcc (READY_, Xc, Yc, Xi, Yi, Wi, RESET_, CLK);

//--------------------------------------------------
//              IO port
//--------------------------------------------------
input CLK, RESET_;
input [7:0] Xi, Yi;
input [3:0] Wi;
output READY_;
output [7:0] Xc, Yc;

reg READY;
reg [7:0] xc, yc;


//--------------------------------------------------
//              REG define
//--------------------------------------------------

//-------------------------
//       Pipeline
//-------------------------

//Pipeline X sum
reg [11:0] X_SUM_2;
reg [11:0] X_SUM_3;
reg [11:0] X_SUM_4;
reg [11:0] X_SUM_5;
reg [11:0] X_SUM_6;
reg [11:0] X_SUM_7;

reg [12:0] X_SUM_2_3;
reg [12:0] X_SUM_4_5;
reg [12:0] X_SUM_6_7;

reg [13:0] X_SUM_2_3_4_5;
reg [14:0] X_SUM;

//Pipeline Y sum
reg [11:0] Y_SUM_2;
reg [11:0] Y_SUM_3;
reg [11:0] Y_SUM_4;
reg [11:0] Y_SUM_5;
reg [11:0] Y_SUM_6;
reg [11:0] Y_SUM_7;

reg [12:0] Y_SUM_2_3;
reg [12:0] Y_SUM_4_5;
reg [12:0] Y_SUM_6_7;

reg [13:0] Y_SUM_2_3_4_5;
reg [14:0] Y_SUM;

//Pipeline W sum
reg [4:0] W_SUM_2_3;
reg [4:0] W_SUM_4_5;
reg [4:0] W_SUM_6_7;
reg [5:0] W_SUM_2_3_4_5;

reg [6:0] W_SUM;
reg [6:0] W_SUM_HALF;

//Pipeline DIVISER
reg [15:0] X_DIVISER;
reg [15:0] Y_DIVISER;

reg [7:0] X_FINAL;
reg [7:0] Y_FINAL;

//-------------------------
//       Input X
//-------------------------
//Input X 
reg [7:0] X1;
reg [7:0] X2;
reg [7:0] X3;
reg [7:0] X4;
reg [7:0] X5;
reg [7:0] X6;
reg [7:0] X7;

//Input X buffer1 
reg [7:0] X1_buffer1;
reg [7:0] X2_buffer1;
reg [7:0] X3_buffer1;
reg [7:0] X4_buffer1;
reg [7:0] X5_buffer1;
reg [7:0] X6_buffer1;
reg [7:0] X7_buffer1;

//Input X buffer2 
reg [7:0] X1_buffer2;
reg [7:0] X2_buffer2;
reg [7:0] X3_buffer2;
reg [7:0] X4_buffer2;
reg [7:0] X5_buffer2;
reg [7:0] X6_buffer2;
reg [7:0] X7_buffer2;

//-------------------------
//       Input Y
//-------------------------
//Input Y 
reg [7:0] Y1;
reg [7:0] Y2;
reg [7:0] Y3;
reg [7:0] Y4;
reg [7:0] Y5;
reg [7:0] Y6;
reg [7:0] Y7;

//Input Y buffer1 
reg [7:0] Y1_buffer1;
reg [7:0] Y2_buffer1;
reg [7:0] Y3_buffer1;
reg [7:0] Y4_buffer1;
reg [7:0] Y5_buffer1;
reg [7:0] Y6_buffer1;
reg [7:0] Y7_buffer1;

//Input Y buffer2 
reg [7:0] Y1_buffer2;
reg [7:0] Y2_buffer2;
reg [7:0] Y3_buffer2;
reg [7:0] Y4_buffer2;
reg [7:0] Y5_buffer2;
reg [7:0] Y6_buffer2;
reg [7:0] Y7_buffer2;

//-------------------------
//       Input W
//-------------------------
//Input W 
reg [3:0] W1;
reg [3:0] W2;
reg [3:0] W3;
reg [3:0] W4;
reg [3:0] W5;
reg [3:0] W6;
reg [3:0] W7;

//Input W buffer1 
reg [3:0] W1_buffer1;
reg [3:0] W2_buffer1;
reg [3:0] W3_buffer1;
reg [3:0] W4_buffer1;
reg [3:0] W5_buffer1;
reg [3:0] W6_buffer1;
reg [3:0] W7_buffer1;

//Input W buffer2 
reg [3:0] W1_buffer2;
reg [3:0] W2_buffer2;
reg [3:0] W3_buffer2;
reg [3:0] W4_buffer2;
reg [3:0] W5_buffer2;
reg [3:0] W6_buffer2;
reg [3:0] W7_buffer2;

//-------------------------
//       Counter
//-------------------------
reg [2:0] counter;

//-------------------------
//       Distance
//-------------------------
reg [16:0] dist_7;
reg [16:0] dist_2;
reg [16:0] dist_3;
reg [16:0] dist_4;
reg [16:0] dist_5;
reg [16:0] dist_6;

reg [16:0] dist1_2_max;
reg [16:0] dist3_4_max;
reg [16:0] dist5_6_max;
reg [16:0] dist1_2_3_4_max;

reg [16:0] dist1_2_X;
reg [16:0] dist3_4_X;
reg [16:0] dist5_6_X;
reg [16:0] dist1_2_3_4_X;

reg [16:0] dist1_2_Y;
reg [16:0] dist3_4_Y;
reg [16:0] dist5_6_Y;
reg [16:0] dist1_2_3_4_Y;

reg [16:0] dist1_2_W;
reg [16:0] dist3_4_W;
reg [16:0] dist5_6_W;
reg [16:0] dist1_2_3_4_W;

reg [2:0] dist1_2;
reg [2:0] dist3_4;
reg [2:0] dist5_6;
reg [2:0] dist1_2_3_4;

reg [2:0] dist_s;


//--------------------------------------------------
//              Counter
//--------------------------------------------------
always @(posedge CLK or negedge RESET_) begin
    if(!RESET_)begin
        counter <= 0;
    end

    else if(counter < 7)begin
        counter <= counter +1;
    end

    else begin
        counter <= counter;
    end
end


//--------------------------------------------------
//             Output READY_
//--------------------------------------------------
always @(posedge CLK or negedge RESET_) begin
    if(!RESET_)begin
        READY <= 1;
    end

    else if(counter >= 1)begin
        READY <= 0;
    end

    else begin
        READY <= 1;
    end
end

assign READY_ = READY;


//--------------------------------------------------
//             Output Xc, Yc
//--------------------------------------------------
always @(*) begin
    X_SUM_2 = (X2_buffer2 * W2_buffer2);
end

always @(*) begin
    X_SUM_3 = (X3_buffer2 * W3_buffer2);
end

always @(*) begin
    X_SUM_4 = (X4_buffer2 * W4_buffer2);
end

always @(*) begin
    X_SUM_5 = (X5_buffer2 * W5_buffer2);
end

always @(*) begin
    X_SUM_6 = (X6_buffer2 * W6_buffer2);
end

always @(*) begin
    X_SUM_7 = (X7_buffer2 * W7_buffer2);
end

always @(*) begin
    X_SUM_2_3 = X_SUM_2 + X_SUM_3;
end

always @(*) begin
    X_SUM_4_5 = X_SUM_4 + X_SUM_5;
end

always @(*) begin
    X_SUM_6_7 = X_SUM_6 + X_SUM_7;
end

always @(*) begin
    X_SUM_2_3_4_5 = X_SUM_2_3 + X_SUM_4_5;
end

always @(*) begin
    X_SUM = X_SUM_2_3_4_5 + X_SUM_6_7;
end

//==========================================
always @(*) begin
    Y_SUM_2 = (Y2_buffer2 * W2_buffer2);
end

always @(*) begin
    Y_SUM_3 = (Y3_buffer2 * W3_buffer2);
end

always @(*) begin
    Y_SUM_4 = (Y4_buffer2 * W4_buffer2);
end

always @(*) begin
    Y_SUM_5 = (Y5_buffer2 * W5_buffer2);
end

always @(*) begin
    Y_SUM_6 = (Y6_buffer2 * W6_buffer2);
end

always @(*) begin
    Y_SUM_7 = (Y7_buffer2 * W7_buffer2);
end

always @(*) begin
    Y_SUM_2_3 = Y_SUM_2 + Y_SUM_3;
end

always @(*) begin
    Y_SUM_4_5 = Y_SUM_4 + Y_SUM_5;
end

always @(*) begin
    Y_SUM_6_7 = Y_SUM_6 + Y_SUM_7;
end

always @(*) begin
    Y_SUM_2_3_4_5 = Y_SUM_2_3 + Y_SUM_4_5;
end

always @(*) begin
    Y_SUM = Y_SUM_2_3_4_5 + Y_SUM_6_7;
end


//==========================================
always @(*) begin
    W_SUM_2_3 = W2_buffer2 + W3_buffer2;
end

always @(*) begin
    W_SUM_4_5 = W4_buffer2 + W5_buffer2;
end

always @(*) begin
    W_SUM_6_7 = W6_buffer2 + W7_buffer2;
end

always @(*) begin
    W_SUM_2_3_4_5 = W_SUM_2_3 + W_SUM_4_5;
end

always @(*) begin
    W_SUM = W_SUM_2_3_4_5 + W_SUM_6_7;
end

always @(*) begin
    W_SUM_HALF = W_SUM / 2;
end

//==========================================
always @(*) begin
    X_DIVISER = X_SUM + W_SUM_HALF;
end

always @(*) begin
    Y_DIVISER = Y_SUM + W_SUM_HALF;
end

always @(*) begin
    X_FINAL = X_DIVISER / W_SUM;
end

always @(*) begin
    Y_FINAL = Y_DIVISER / W_SUM;
end 

//==========================================
always @(posedge CLK or negedge RESET_) begin
    if(!RESET_)begin
        xc <= 0;
        yc <= 0;
    end

    else begin
        xc <= X_FINAL;
        yc <= Y_FINAL;
    end
end

assign Xc = xc;
assign Yc = yc;


//--------------------------------------------------
//             X buffer1
//--------------------------------------------------
always @(posedge CLK or negedge RESET_) begin
    if(!RESET_)begin
        X1_buffer1 <= 0;
        X2_buffer1 <= 0;
        X3_buffer1 <= 0;
        X4_buffer1 <= 0;
        X5_buffer1 <= 0;
        X6_buffer1 <= 0;
        X7_buffer1 <= 0;
    end

    else begin
        X1_buffer1 <= Xi;
        X2_buffer1 <= X2;
        X3_buffer1 <= X3;
        X4_buffer1 <= X4;
        X5_buffer1 <= X5;
        X6_buffer1 <= X6;
        X7_buffer1 <= X7;
    end
end


//--------------------------------------------------
//             Y buffer1
//--------------------------------------------------
always @(posedge CLK or negedge RESET_) begin
    if(!RESET_)begin
        Y1_buffer1 <= 0;
        Y2_buffer1 <= 0;
        Y3_buffer1 <= 0;
        Y4_buffer1 <= 0;
        Y5_buffer1 <= 0;
        Y6_buffer1 <= 0;
        Y7_buffer1 <= 0;
    end

    else begin
        Y1_buffer1 <= Yi;
        Y2_buffer1 <= Y2;
        Y3_buffer1 <= Y3;
        Y4_buffer1 <= Y4;
        Y5_buffer1 <= Y5;
        Y6_buffer1 <= Y6;
        Y7_buffer1 <= Y7;
    end
end


//--------------------------------------------------
//             W buffer1
//--------------------------------------------------
always @(posedge CLK or negedge RESET_) begin
    if(!RESET_)begin
        W1_buffer1 <= 0;
        W2_buffer1 <= 0;
        W3_buffer1 <= 0;
        W4_buffer1 <= 0;
        W5_buffer1 <= 0;
        W6_buffer1 <= 0;
        W7_buffer1 <= 0;
    end

    else begin
        W1_buffer1 <= Wi;
        W2_buffer1 <= W2;
        W3_buffer1 <= W3;
        W4_buffer1 <= W4;
        W5_buffer1 <= W5;
        W6_buffer1 <= W6;
        W7_buffer1 <= W7;
    end
end


//--------------------------------------------------
//             Distance
//--------------------------------------------------
always @(*)begin
    dist_2 = (X2_buffer1 - xc) * (X2_buffer1 - xc) + (Y2_buffer1 - yc) * (Y2_buffer1 - yc);
    dist_3 = (X3_buffer1 - xc) * (X3_buffer1 - xc) + (Y3_buffer1 - yc) * (Y3_buffer1 - yc);
    dist_4 = (X4_buffer1 - xc) * (X4_buffer1 - xc) + (Y4_buffer1 - yc) * (Y4_buffer1 - yc);
    dist_5 = (X5_buffer1 - xc) * (X5_buffer1 - xc) + (Y5_buffer1 - yc) * (Y5_buffer1 - yc);
    dist_6 = (X6_buffer1 - xc) * (X6_buffer1 - xc) + (Y6_buffer1 - yc) * (Y6_buffer1 - yc);
    dist_7 = (X7_buffer1 - xc) * (X7_buffer1 - xc) + (Y7_buffer1 - yc) * (Y7_buffer1 - yc);
end


//--------------------------------------------------
//             Compare
//--------------------------------------------------
always @(*)begin
    if(dist_7 > dist_2 || dist_7 == dist_2 && (X7_buffer1 < X2_buffer1 || (X7_buffer1 == X2_buffer1 && (Y7_buffer1 < Y2_buffer1 || (Y7_buffer1 == Y2_buffer1 && W7_buffer1 <= W2_buffer1)))))begin
        dist1_2 = 3'd7;
        dist1_2_max = dist_7;
        dist1_2_X = X7_buffer1;
        dist1_2_Y = Y7_buffer1;
        dist1_2_W = W7_buffer1;
    end

    else begin
        dist1_2 = 3'd2;
        dist1_2_max = dist_2;
        dist1_2_X = X2_buffer1;
        dist1_2_Y = Y2_buffer1;
        dist1_2_W = W2_buffer1;
    end
end

always @(*)begin
    if(dist_3 > dist_4 || dist_3 == dist_4 && (X3_buffer1 < X4_buffer1 || (X3_buffer1 == X4_buffer1 && (Y3_buffer1 < Y4_buffer1 || (Y3_buffer1 == Y4_buffer1 && W3_buffer1 <= W4_buffer1)))))begin
        dist3_4 = 3'd3;
        dist3_4_max = dist_3;
        dist3_4_X = X3_buffer1;
        dist3_4_Y = Y3_buffer1;
        dist3_4_W = W3_buffer1;
    end

    else begin
        dist3_4 = 3'd4;
        dist3_4_max = dist_4;
        dist3_4_X = X4_buffer1;
        dist3_4_Y = Y4_buffer1;
        dist3_4_W = W4_buffer1;
    end
end

always @(*)begin
    if(dist_5 > dist_6 || dist_5 == dist_6 && (X5_buffer1 < X6_buffer1 || (X5_buffer1 == X6_buffer1 && (Y5_buffer1 < Y6_buffer1 || (Y5_buffer1 == Y6_buffer1 && W5_buffer1 <= W6_buffer1)))))begin
        dist5_6 = 3'd5;
        dist5_6_max = dist_5;
        dist5_6_X = X5_buffer1;
        dist5_6_Y = Y5_buffer1;
        dist5_6_W = W5_buffer1;
    end

    else begin
        dist5_6 = 3'd6;
        dist5_6_max = dist_6;
        dist5_6_X = X6_buffer1;
        dist5_6_Y = Y6_buffer1;
        dist5_6_W = W6_buffer1;
    end
end

always @(*)begin
    if(dist1_2_max > dist3_4_max || dist1_2_max == dist3_4_max && (dist1_2_X < dist3_4_X || (dist1_2_X == dist3_4_X && (dist1_2_Y < dist3_4_Y || (dist1_2_Y == dist3_4_Y && dist1_2_W <= dist3_4_W)))))begin
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

always @(*)begin
    if(dist1_2_3_4_max > dist5_6_max || dist1_2_3_4_max == dist5_6_max && (dist1_2_3_4_X < dist5_6_X || (dist1_2_3_4_X == dist5_6_X && (dist1_2_3_4_Y < dist5_6_Y || (dist1_2_3_4_Y == dist5_6_Y && dist1_2_3_4_W <= dist5_6_W)))))begin
        dist_s = dist1_2_3_4;
    end

    else begin
        dist_s = dist5_6;
    end
end


//--------------------------------------------------
//             Change X
//--------------------------------------------------
always @(*)begin
    
    if(counter == 7)begin
        if(dist_s == 3'd7)begin
            X7_buffer2 = X1_buffer1;
        end
        else begin
            X7_buffer2 = X7_buffer1;
        end


        if(dist_s == 3'd2)begin
            X2_buffer2 = X1_buffer1;
        end
        else begin
            X2_buffer2 = X2_buffer1;
        end


        if(dist_s == 3'd3)begin
            X3_buffer2 = X1_buffer1;
        end
        else begin
            X3_buffer2 = X3_buffer1;
        end


        if(dist_s == 3'd4)begin
            X4_buffer2 = X1_buffer1;
        end
        else begin
            X4_buffer2 = X4_buffer1;
        end


        if(dist_s == 3'd5)begin
            X5_buffer2 = X1_buffer1;
        end
        else begin
            X5_buffer2 = X5_buffer1;
        end


        if(dist_s == 3'd6)begin
            X6_buffer2 = X1_buffer1;
        end
        else begin
            X6_buffer2 = X6_buffer1;
        end

    end

    else begin
        X2_buffer2 = X1_buffer1;
        X3_buffer2 = X2_buffer1;
        X4_buffer2 = X3_buffer1;
        X5_buffer2 = X4_buffer1;
        X6_buffer2 = X5_buffer1;
        X7_buffer2 = X6_buffer1;
    end
end

always @(*)begin
    
    if(counter == 7)begin
        if(dist_s == 3'd7)begin
            X7 = X1_buffer1;
        end
        else begin
            X7 = X7_buffer1;
        end


        if(dist_s == 3'd2)begin
            X2 = X1_buffer1;
        end
        else begin
            X2 = X2_buffer1;
        end


        if(dist_s == 3'd3)begin
            X3 = X1_buffer1;
        end
        else begin
            X3 = X3_buffer1;
        end


        if(dist_s == 3'd4)begin
            X4 = X1_buffer1;
        end
        else begin
            X4 = X4_buffer1;
        end


        if(dist_s == 3'd5)begin
            X5 = X1_buffer1;
        end
        else begin
            X5 = X5_buffer1;
        end


        if(dist_s == 3'd6)begin
            X6 = X1_buffer1;
        end
        else begin
            X6 = X6_buffer1;
        end

    end

    else begin
        X2 = X1_buffer1;
        X3 = X2_buffer1;
        X4 = X3_buffer1;
        X5 = X4_buffer1;
        X6 = X5_buffer1;
        X7 = X6_buffer1;
    end
end


//--------------------------------------------------
//             Change Y
//--------------------------------------------------
always @(*)begin
    
    if(counter == 7)begin
        if(dist_s == 3'd7)begin
            Y7_buffer2 = Y1_buffer1;
        end
        else begin
            Y7_buffer2 = Y7_buffer1;
        end


        if(dist_s == 3'd2)begin
            Y2_buffer2 = Y1_buffer1;
        end
        else begin
            Y2_buffer2 = Y2_buffer1;
        end


        if(dist_s == 3'd3)begin
            Y3_buffer2 = Y1_buffer1;
        end
        else begin
            Y3_buffer2 = Y3_buffer1;
        end


        if(dist_s == 3'd4)begin
            Y4_buffer2 = Y1_buffer1;
        end
        else begin
            Y4_buffer2 = Y4_buffer1;
        end


        if(dist_s == 3'd5)begin
            Y5_buffer2 = Y1_buffer1;
        end
        else begin
            Y5_buffer2 = Y5_buffer1;
        end


        if(dist_s == 3'd6)begin
            Y6_buffer2 = Y1_buffer1;
        end
        else begin
            Y6_buffer2 = Y6_buffer1;
        end

    end

    else begin
        Y2_buffer2 = Y1_buffer1;
        Y3_buffer2 = Y2_buffer1;
        Y4_buffer2 = Y3_buffer1;
        Y5_buffer2 = Y4_buffer1;
        Y6_buffer2 = Y5_buffer1;
        Y7_buffer2 = Y6_buffer1;
    end
end

always @(*)begin
    
    if(counter == 7)begin
        if(dist_s == 3'd7)begin
            Y7 = Y1_buffer1;
        end
        else begin
            Y7 = Y7_buffer1;
        end


        if(dist_s == 3'd2)begin
            Y2 = Y1_buffer1;
        end
        else begin
            Y2 = Y2_buffer1;
        end


        if(dist_s == 3'd3)begin
            Y3 = Y1_buffer1;
        end
        else begin
            Y3 = Y3_buffer1;
        end


        if(dist_s == 3'd4)begin
            Y4 = Y1_buffer1;
        end
        else begin
            Y4 = Y4_buffer1;
        end


        if(dist_s == 3'd5)begin
            Y5 = Y1_buffer1;
        end
        else begin
            Y5 = Y5_buffer1;
        end


        if(dist_s == 3'd6)begin
            Y6 = Y1_buffer1;
        end
        else begin
            Y6 = Y6_buffer1;
        end

    end

    else begin
        Y2 = Y1_buffer1;
        Y3 = Y2_buffer1;
        Y4 = Y3_buffer1;
        Y5 = Y4_buffer1;
        Y6 = Y5_buffer1;
        Y7 = Y6_buffer1;
    end
end


//--------------------------------------------------
//             Change W
//--------------------------------------------------
always @(*)begin
    
    if(counter == 7)begin
        if(dist_s == 3'd7)begin
            W7_buffer2 = W1_buffer1;
        end
        else begin
            W7_buffer2 = W7_buffer1;
        end


        if(dist_s == 3'd2)begin
            W2_buffer2 = W1_buffer1;
        end
        else begin
            W2_buffer2 = W2_buffer1;
        end


        if(dist_s == 3'd3)begin
            W3_buffer2 = W1_buffer1;
        end
        else begin
            W3_buffer2 = W3_buffer1;
        end


        if(dist_s == 3'd4)begin
            W4_buffer2 = W1_buffer1;
        end
        else begin
            W4_buffer2 = W4_buffer1;
        end


        if(dist_s == 3'd5)begin
            W5_buffer2 = W1_buffer1;
        end
        else begin
            W5_buffer2 = W5_buffer1;
        end


        if(dist_s == 3'd6)begin
            W6_buffer2 = W1_buffer1;
        end
        else begin
            W6_buffer2 = W6_buffer1;
        end

    end

    else begin
        W2_buffer2 = W1_buffer1;
        W3_buffer2 = W2_buffer1;
        W4_buffer2 = W3_buffer1;
        W5_buffer2 = W4_buffer1;
        W6_buffer2 = W5_buffer1;
        W7_buffer2 = W6_buffer1;
    end
end

always @(*)begin
    
    if(counter == 7)begin
        if(dist_s == 3'd7)begin
            W7 = W1_buffer1;
        end
        else begin
            W7 = W7_buffer1;
        end


        if(dist_s == 3'd2)begin
            W2 = W1_buffer1;
        end
        else begin
            W2 = W2_buffer1;
        end


        if(dist_s == 3'd3)begin
            W3 = W1_buffer1;
        end
        else begin
            W3 = W3_buffer1;
        end


        if(dist_s == 3'd4)begin
            W4 = W1_buffer1;
        end
        else begin
            W4 = W4_buffer1;
        end


        if(dist_s == 3'd5)begin
            W5 = W1_buffer1;
        end
        else begin
            W5 = W5_buffer1;
        end


        if(dist_s == 3'd6)begin
            W6 = W1_buffer1;
        end
        else begin
            W6 = W6_buffer1;
        end

    end

    else begin
        W2 = W1_buffer1;
        W3 = W2_buffer1;
        W4 = W3_buffer1;
        W5 = W4_buffer1;
        W6 = W5_buffer1;
        W7 = W6_buffer1;
    end
end

endmodule