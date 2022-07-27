module FIFO #( parameter  WIDTH=16,DEPTH=16 ) //parameterized width and depth
(input rst,clk,fifo_write,fifo_read,input logic [WIDTH-1:0] fifo_data_in,output logic[WIDTH-1:0] fifo_data_out,output fifo_full,fifo_empty);
// output and inputs defined
integer cnt;
logic [4:0] wr_ptr,rd_ptr;
logic [WIDTH-1:0] fifo_memory[DEPTH-1:0]; // the stack is WIDTH bits wide and DEPTH locations in size
 //assigning fifo_full and fifo_empty condition
assign fifo_full= ( cnt==DEPTH );
assign fifo_empty = (cnt==0);

always_ff@(posedge clk,negedge rst) begin
 // make pointers zero by default if they reached top of the stack
if(wr_ptr==DEPTH) wr_ptr=0; 
if(rd_ptr==DEPTH) rd_ptr=0; 

if (!rst) begin 
//priority on active low reset
  for (integer i=0; i<DEPTH-1; i=i+1) fifo_memory[i]<=16'b0;
wr_ptr<=0;
rd_ptr<=0;
cnt<=0; // by making counter zero, fifo_empty and fifo_full automatically reset, since there is a continuous assignment on them
fifo_data_out<=16'b0;
end
else begin 
 if (fifo_write & !fifo_full) begin 
fifo_memory[wr_ptr]<=fifo_data_in; //put data into the stack
wr_ptr<=wr_ptr+1; // write pointer increments on write request
cnt<=cnt+1;  //counter increments
end
else if (fifo_read & !fifo_empty) begin
 fifo_data_out<=fifo_memory[rd_ptr]; //read data from the stack, data are read from the bottom of the stack cause first in first out architecture
 rd_ptr<=rd_ptr+1; // read pointer increments on read request
cnt<=cnt-1; //counter decrements
end // internal else if end
end // external if  end
end // always_ff end
endmodule
