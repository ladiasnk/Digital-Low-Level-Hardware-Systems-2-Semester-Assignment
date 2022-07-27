module up_down_16bit_counter(input clk,count_enb,updn_cnt,rst,ld_cnt,
input logic [15:0] data_in,output logic [15:0] data_out);

always_ff@(posedge clk,negedge rst) begin
if (!rst) data_out <= 16'b0;   //Priority on active low reset
else begin
   if(!ld_cnt) data_out<=data_in; // Load operation has priority over count_enb
   else if (count_enb) begin        // Count up or down according to count_enb
         if(updn_cnt)  data_out<=data_out+1;  
         else      data_out<=data_out-1;  
   end
 //no else here, if count_enb is low, data remains stable, no operation needed
end

end
endmodule 
