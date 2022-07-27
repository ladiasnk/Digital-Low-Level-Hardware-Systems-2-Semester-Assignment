module FIFO_property#( parameter  WIDTH=16,DEPTH=16 ) //parameterized width and depth
(input prst,pwrt_ptr,prd_ptr,pclk,pfifo_write,pfifo_read,input logic [WIDTH-1:0] pfifo_data_in, pfifo_data_out,
input integer pcnt,output pfifo_full,pfifo_empty); // need write and read pointers as well as counter as inputs here

//property to reset FIFO 
property reset;
@(negedge prst) 1'b1|=>@(posedge pclk)( {pfifo_empty,pfifo_full,pwrt_ptr,prd_ptr}==5'b1000 & pcnt==0);
endproperty
FIFO_Reset: assert property (reset) $display($stime,,,"\t\t %m PASS");
else $display($stime,,,"\t\t %m FAIL");

//property for fifo_empty assertion
property fifo_empty;
@(posedge pclk) disable iff (!prst)  // disable this propery if reset is on (active low)
 pcnt==0|-> pfifo_empty ;
endproperty
FIFO_Empty: assert property (fifo_empty) $display($stime,,,"\t\t %m PASS");
else $display($stime,,,"\t\t %m FAIL");

//property for fifo_full assertion
property fifo_full;
@(posedge pclk) disable iff (!prst)  // disable this propery if reset is on (active low)
 pcnt>=DEPTH |-> pfifo_full ;
endproperty
FIFO_Full: assert property (fifo_full) $display($stime,,,"\t\t %m PASS");
else $display($stime,,,"\t\t %m FAIL");


property write_ptr_stable;
@(posedge pclk) (pfifo_full & pfifo_write) |=> $stable(pwrt_ptr) ;
endproperty
Write_Ptr_Stable:assert property (write_ptr_stable) $display($stime,,,"\t\t %m PASS");
else $display($stime,,,"\t\t %m FAIL");


property read_ptr_stable;
@(posedge pclk) (pfifo_empty & pfifo_read)|=>$stable(prd_ptr) ;
endproperty
Read_Ptr_Stable:assert property (read_ptr_stable) $display($stime,,,"\t\t %m PASS");
else $display($stime,,,"\t\t %m FAIL");



endmodule 
