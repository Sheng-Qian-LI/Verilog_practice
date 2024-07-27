`timescale 1ns/100ps

module counter_mod10_tb;

reg clk;
reg rst_n;
wire [6:0]ssd_sec_l;
wire [6:0]ssd_sec_h;
wire [6:0]ssd_min_l;
wire [6:0]ssd_min_h;
wire [6:0]ssd_hour_l;
wire [6:0]ssd_hour_h;
wire [6:0]ssd_day;

timer_top timer_top(
	.clk(clk),
	.rst_n(rst_n),
	.ssd_day(ssd_day),
	.ssd_hour_h(ssd_hour_h),
	.ssd_hour_l(ssd_hour_l),
	.ssd_min_h(ssd_min_h),
	.ssd_min_l(ssd_min_l),
	.ssd_sec_h(ssd_sec_h),
	.ssd_sec_l(ssd_sec_l)
);


/////////////////////////////////////////
//////            Clock            //////
/////////////////////////////////////////
initial clk = 0;
always #5 clk = ~clk;


initial begin 
	rst_n       <= 1;
    #5 rst_n <= 0;
	repeat(3)@(negedge clk);
    rst_n <= 1;
	repeat(1200000) @(negedge clk);
	$finish;
end


initial begin
	$fsdbDumpfile("./timer_gpt.fsdb");
	$fsdbDumpvars;
end
endmodule