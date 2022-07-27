module up_down_16bit_counter_property(input pclk,pcount_enb,pupdn_cnt,prst,pld_cnt,
input logic [15:0] pdata_in, pdata_out);


property reset_data;
@(negedge prst) 1'b1|=> @(posedge pclk)(pdata_out==16'b0); 
endproperty 
Data_Reset: assert property (reset_data) $display($stime,,,"\t\t %m PASS");
else $display($stime,,,"\t\t %m FAIL");



sequence out_stable_conditions;
(pld_cnt & !pcount_enb) ;  // if pld_cnt is deasserted (meaning its high) and pcount_enb is not enabled (it is low)
endsequence

sequence change_out_conditions;
(pld_cnt & pcount_enb) ; // if pld_cnt is deasserted (meaning its high) and pcount_enb is enabled (it is high)
endsequence

property data_stable;
@(posedge pclk)  disable iff (!prst)  // disable this propery if reset is on (active low)
 out_stable_conditions |-> $stable(pdata_out); // trigger proper sequence of conditions and check for stable data output between two clock edges
endproperty
Data_Stable: assert property (data_stable) $display($stime,,,"\t\t %m PASS");
else $display($stime,,,"\t\t %m FAIL");

property data_change;
@(posedge pclk)  disable iff (!prst) // disable this propery if reset is on (active low)
change_out_conditions|-> if(pupdn_cnt) pdata_out==$past(pdata_out+1) else pdata_out==$past(pdata_out-1); // check conditions, then
// check with a simple if-else, whether counter is incremented or decremented using its past value +-1 accordingly
endproperty

Data_Change: assert property (data_change) $display($stime,,,"\t\t %m PASS");
else $display($stime,,,"\t\t %m FAIL");

endmodule


