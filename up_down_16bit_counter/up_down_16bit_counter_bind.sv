module up_down_16bit_counter_bind;

bit sys_clk,sys_count_enb,sys_updn_cnt,sys_rst,sys_ld_cnt;
logic [15:0] sys_data_in,sys_data_out;
//Instantiate counter module 
up_down_16bit_counter up_down_16bit_counter1(.clk(sys_clk),.count_enb(sys_count_enb),.updn_cnt(sys_updn_cnt),.rst(sys_rst),.ld_cnt(sys_ld_cnt),
.data_in(sys_data_in),.data_out(sys_data_out));
// Bind property module to design module
bind up_down_16bit_counter1 up_down_16bit_counter_property up_down_16bit_counter_bound (.pclk(clk),.pcount_enb(count_enb),
.pupdn_cnt(updn_cnt),.prst(rst),.pld_cnt(ld_cnt),.pdata_in(data_in),.pdata_out(data_out)); 


always #10 sys_clk = !sys_clk; // Define clock with 20 time units periods
initial
begin
sys_data_in=16'b1111000111111000; // Random 16bit data for input 
sys_ld_cnt = 1'b1; // Deassert load in the beginning
sys_rst = 1'b0; // Start by resetting out data
#20
sys_rst=1'b1; // Deassert reset
sys_count_enb = 1'b1; // Start by counting
sys_updn_cnt=1'b1; //Count up
#80 // Count for 4 clock periods (Clock period=20)
sys_ld_cnt=1'b0; // Load data to output, priority over counting 
#20 //for one period
sys_ld_cnt=1'b1; // Deassert load 
sys_updn_cnt=1'b0; // Start counting down
#40 // for two periods
sys_count_enb=1'b0; // Stop counting
sys_data_in=16'b1110000101100010; // New data input
#40 // two more periods
sys_ld_cnt=1'b0; // Load data again to out
#20 // wait for one more period
sys_rst=1'b0; // Reset counter, out=0

end

endmodule
