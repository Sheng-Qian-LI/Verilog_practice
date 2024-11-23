`timescale 1ns/100ps

module counter_mod10_tb;

reg CLK;
reg RESET_;
reg [7:0]Xi;
reg [7:0]Yi;
reg [3:0]Wi;
wire READY_;
wire [7:0]Xc;
wire [7:0]Yc;

gcc gcc(
	.CLK(CLK),
	.RESET_(RESET_),
	.Xi(Xi),
	.Yi(Yi),
	.Wi(Wi),
	.READY_(READY_),
	.Xc(Xc),
	.Yc(Yc)
);

integer i;
/////////////////////////////////////////
//////            Clock            //////
/////////////////////////////////////////
initial CLK = 0;
always #33 CLK = ~CLK;


initial begin 

	Xi <= 0;
	Yi <= 0;
	Wi <= 0;
	RESET_ <= 1;
    #33 RESET_ <= 0;
	repeat(3)@(negedge CLK);
    RESET_ <= 1;

	for(i=0; i<20; i=i+1) 
	begin
		Xi <= {$random}%256 ;
		Yi <= {$random}%256 ;
		Wi <= {$random}%16 + 1;
		repeat(1) @(negedge CLK);
	end
	repeat(1) @(negedge CLK);
	$finish;
end


initial begin
	$fsdbDumpfile("./gcc.fsdb");
	$fsdbDumpvars( "+mda");
	$fsdbDumpvars;
end
endmodule