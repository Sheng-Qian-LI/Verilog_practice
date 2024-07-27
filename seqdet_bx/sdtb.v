`timescale 1ns/100ps

module SD_TB();
   /////////////////////////////////////////
   //////             Def             //////
   /////////////////////////////////////////
   reg clk ;
   reg rst_n;
   //reg [10:0] i ;
   //reg [0:0] valid_in_data[0:999]; 
   //reg [0:0] seq_in_data[0:999]; 
   reg valid_rx;
   reg [3:0] data_rx;

   wire sfd_det;
   wire valid_out;
   wire [7:0] data_out;

   integer seed;

   /////////////////////////////////////////
   //////           Connect           //////
   /////////////////////////////////////////
   seqdet_bx SD_TB
   (
      .clk        (clk   ),
      .rst_n      (rst_n  ),
	   .valid_rx   (valid_rx ),
	   .data_rx    (data_rx  ),
	   .sfd_det    (sfd_det    ),
	   .valid_out  (valid_out     ),
      .data_out   (data_out)
   );

   /////////////////////////////////////////
   //////            clk           //////
   /////////////////////////////////////////

   initial clk= 0;
   always #5 clk= ~clk;

   /////////////////////////////////////////
   //////            Reset            //////
   /////////////////////////////////////////

   task reset_task; 
	begin
		//i = 0 ;

	   valid_rx <= 0 ;
	   data_rx <= 0 ;
      rst_n <= 1;
      #5 rst_n <= 0;

	   @(negedge clk);
      rst_n <= 1;
	end
   endtask

   /////////////////////////////////////////
   //////            Data             //////
   /////////////////////////////////////////

   //task Data; 
	//begin
	//	$readmemh("valid_in.txt",valid_in_data);
	//   $readmemh("seq_in.txt",seq_in_data);
	//end
   //endtask
   
   /////////////////////////////////////////
   //////            Main             //////
   /////////////////////////////////////////
   
	initial begin
   
      reset_task;
      seed = 3 ;
      repeat(100) begin
         @(negedge clk);
         //valid_rx <= $random(seed) % 2;
         valid_rx <= 1;
         data_rx <= $random(seed) % 16;
      end
      repeat(1000) begin
         @(negedge clk);
         valid_rx <= $random(seed) % 2;
         //valid_rx <= 1;
         data_rx <= $random(seed) % 16;
      end
	   repeat(10)@(negedge clk) ;
	   $finish;
	
	end

   /////////////////////////////////////////
   //////            Dump             //////
   /////////////////////////////////////////
   
   initial begin
	   $fsdbDumpfile("mysd.fsdb");
	   $fsdbDumpvars;
   end

endmodule

