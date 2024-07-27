`timescale 1ns/100ps

module SD_TB();
   /////////////////////////////////////////
   //////             Def             //////
   /////////////////////////////////////////
   reg clock  ;
   reg reset_n;
   reg [10:0] i ;
   reg [0:0] valid_in_data[0:999]; 
   reg [0:0] seq_in_data[0:999]; 
   reg valid_in;
   reg seq_in ;

   wire match ;
   wire full ;

   localparam FULL_NUM = 8;

   /////////////////////////////////////////
   //////           Connect           //////
   /////////////////////////////////////////
   seqdetector #(
	  .FULL_NUM  (FULL_NUM )
   )  SD_TB
   (
      .clock    (clock    ),
      .reset_n  (reset_n  ),
	   .valid_in (valid_in ),
	   .seq_in   (seq_in   ),
	   .match    (match    ),
	   .full     (full     )
   );

   /////////////////////////////////////////
   //////            Clock            //////
   /////////////////////////////////////////

   initial clock = 0;
   always #5 clock = ~clock;

   /////////////////////////////////////////
   //////            Reset            //////
   /////////////////////////////////////////

   task reset_task; 
	begin
		i = 0 ;

	   valid_in <= 0 ;
	   seq_in <= 0 ;
      reset_n <= 1;
      #5 reset_n = 0;

	   @(negedge clock);
      reset_n = 1;
	end
   endtask

   /////////////////////////////////////////
   //////            Data             //////
   /////////////////////////////////////////

   task Data; 
	begin
		$readmemh("valid_in.txt",valid_in_data);
	   $readmemh("seq_in.txt",seq_in_data);
	end
   endtask
   
   /////////////////////////////////////////
   //////            Main             //////
   /////////////////////////////////////////
   
	initial begin
   
      Data;
      reset_task;
	
	   for(i = 0; i < 350; i = i + 1) begin
         @(negedge clock);
	      valid_in <= valid_in_data[i];
	      seq_in <=   seq_in_data[i];
      end
   
	   repeat(10)@(negedge clock) ;
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

