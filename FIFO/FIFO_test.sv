//parameters define for FIFO module instantiation
`define WIDTH_dut 16
`define DEPTH_dut 16


module FIFO_test;
// define necessary inputs-outputs
bit sys_rst,sys_clk,sys_fifo_write,sys_fifo_read,sys_fifo_full,sys_fifo_empty;

logic [`WIDTH_dut-1:0] sys_fifo_data_in,sys_fifo_data_out;
//Instantiate FIFO module
FIFO FIFO_dut(.clk(sys_clk),.rst(sys_rst),.fifo_write(sys_fifo_write),.fifo_read(sys_fifo_read),.fifo_full(sys_fifo_full),.fifo_empty(sys_fifo_empty),
.fifo_data_in(sys_fifo_data_in),.fifo_data_out(sys_fifo_data_out) );
//bind to property module
bind FIFO_dut FIFO_property FIFO_bind(.pclk(clk),.prst(rst),.pfifo_write(fifo_write),.pfifo_read(fifo_read),.pfifo_full(fifo_full),
.pfifo_empty(fifo_empty),.pfifo_data_in(fifo_data_in),.pfifo_data_out(fifo_data_out),.pwrt_ptr(FIFO_dut.wr_ptr),.prd_ptr(FIFO_dut.rd_ptr),.pcnt(FIFO_dut.cnt) );

//create clock for simulation
always #1 sys_clk = !sys_clk;
initial begin
sys_rst=1'b0; //reset FIFO to initialise contents

#2
sys_rst=1'b1; // deassert reset
sys_fifo_write=1'b1; //start writing data to stack
sys_fifo_data_in=16'b0001100011101001; //input data
#2
sys_fifo_data_in=16'b1111111011110011 ; //next input data
#2
sys_fifo_data_in=16'b1010100110111010 ; //next input data
#2
sys_fifo_write=1'b0;
sys_fifo_read=1'b1; 
#4 // read for 2 clock periods
sys_fifo_read=1'b0;
sys_fifo_write=1'b1;
#30 // perform 15 writes
//do nothing here, check for write pointer stability
#2
sys_fifo_write=1'b0; // stop writing request
sys_fifo_read=1'b1; // start reading
#32 // read all data from stack
//do nothing here, check for read pointer stability
#2
sys_rst=1'b0; //reset and finish

end

endmodule 
