//===================================================================
//
//	Module Name: Asynchronous FIFO
//
//	Features: 
//		1.Implement multi-bits CDC problem by asynchrous fifo  
//      2.write slow read fast
//
//	Function:
//  	1.Double sync to solve CDC problem
//      
//
//===================================================================

module	async_fifo
// #(
// 	parameter   DATA_WIDTH = 'd3  ,			        //FIFO位宽
//     parameter   DATA_DEPTH = 'd3 			        //FIFO深度
// )		
(		
	//CLK 1 for write
	input							wr_clk		,				
	input							wr_rst_n	,       		
	input							wr_en		,       			
	input	[7:0]		data_in		,       		
	//CLK 2 for read		
	input							rd_clk		,				
	input							rd_rst_n	,       		
	input							rd_en		,										                                        
	output	reg	[7:0]	data_out	,				
				
	output							empty		,				
	output							full		    			
);                                                              
 
//------------------------
//      reg define
//------------------------
reg [7:0]fifo_buffer[7:0];                          //FIFO寬度8，深度8
	
reg [3:0]		wr_ptr;						//write point(add 1bit)
reg	[3:0]		wr_ptr_g_d1;				//write double_synch dff1
reg	[3:0]		wr_ptr_g_d2;				//write double_synch dff2

reg [3:0]		rd_ptr;						//read point(add 1bit)
reg	[3:0]		rd_ptr_g_d1;				//read double_synch dff1
reg	[3:0]		rd_ptr_g_d2;				//read double_synch dff2

	
//------------------------
//      wire define
//------------------------
wire [3:0]		wr_ptr_g;					//convert binary to gray code
wire [3:0]		rd_ptr_g;					//convert binary to gray code
wire [2:0]	 wr_ptr_true;				//correct bit write point
wire [2:0]	 rd_ptr_true;				//correct bit read point
 
 
//------------------------------------------------
//      convert pointer binary to gray code
//------------------------------------------------
assign wr_ptr_g = (wr_ptr >> 1) ^ wr_ptr;
assign rd_ptr_g = (rd_ptr >> 1) ^ rd_ptr;


//------------------------------------------------
//                 true pointer
//------------------------------------------------
assign	wr_ptr_true = wr_ptr [2 : 0];
assign	rd_ptr_true = rd_ptr [2 : 0];


//------------------------------------------------
//                 write point
//------------------------------------------------
always @(posedge wr_clk or negedge wr_rst_n) begin
    if(!wr_rst_n) begin
        wr_ptr <= 0;
    end

    else if(wr_en == 1 && full == 0) begin
        wr_ptr <= wr_ptr + 1;
        fifo_buffer[wr_ptr_true] <= data_in;
    end

    else begin
        wr_ptr <= wr_ptr;
    end
    
end


//------------------------------------------------
//          write point double synch 1
//
//將wrptr同步到rd clk的 always block 裡面要是rd clk
//------------------------------------------------
always @(posedge rd_clk or negedge rd_rst_n) begin
    if(!rd_rst_n) begin
        wr_ptr_g_d1 <= 0;
    end

    else begin
       wr_ptr_g_d1 <= wr_ptr_g;
    end
    
end


//------------------------------------------------
//          write point double synch 2
//------------------------------------------------
always @(posedge rd_clk or negedge rd_rst_n) begin
    if(!rd_rst_n) begin
        wr_ptr_g_d2 <= 0;
    end

    else begin
       wr_ptr_g_d2 <= wr_ptr_g_d1;
    end
    
end


//------------------------------------------------
//                 read point
//------------------------------------------------
always @(posedge rd_clk or negedge rd_rst_n) begin
    if(!rd_rst_n) begin
        rd_ptr <= 0;
    end

    else if(rd_en == 1 && empty == 0) begin
        
        rd_ptr <= rd_ptr + 1;
        data_out <= fifo_buffer[rd_ptr_true];
    end

    else begin
        rd_ptr <= rd_ptr;
    end
    
end


//------------------------------------------------
//          read point double synch 1
//
//將rdptr同步到wr clk的 always block 裡面要是wr clk
//------------------------------------------------
always @(posedge wr_clk or negedge wr_rst_n) begin
    if(!wr_rst_n) begin
        rd_ptr_g_d1 <= 0;
    end

    else begin
       rd_ptr_g_d1 <= rd_ptr_g;
    end
    
end


//------------------------------------------------
//          read point double synch 2
//------------------------------------------------
always @(posedge wr_clk or negedge wr_rst_n) begin
    if(!wr_rst_n) begin
        rd_ptr_g_d2 <= 0;
    end

    else begin
       rd_ptr_g_d2 <= rd_ptr_g_d1;
    end
    
end


//------------------------------------------------
//                  full & empty
//------------------------------------------------

//將read clk 的ptr同步到write clk，比較前兩bit不同，後2bits相同時代表寫滿
assign full = (wr_ptr_g == {~(rd_ptr_g_d2[3 : 2]) , rd_ptr_g_d2[1 : 0]}) ? 1'b1 : 1'b0;

//將write clk 的ptr同步到read clk
assign empty = (wr_ptr_g_d2 == rd_ptr_g) ? 1'b1 : 1'b0;


endmodule
