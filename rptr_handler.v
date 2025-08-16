module rptr_handler #(parameter ASIZE = 3) (rdclk,in_resetn, in_rd_en, sync_wptr_gray,rptr_binary_addr, rptr_gray, out_empty, rd_en_RAM);
input [ASIZE:0] sync_wptr_gray;
input in_rd_en, rdclk,in_resetn;
output [ASIZE-1:0] rptr_binary_addr;
output [ASIZE:0] rptr_gray;
output rd_en_RAM, out_empty;

reg [ASIZE:0] rptr_binary;
assign out_empty = ( sync_wptr_gray == rptr_gray);
assign rd_en_RAM = ( sync_wptr_gray != rptr_gray) && in_rd_en; // out_empty && in_rd_en;
assign rptr_gray = ( rptr_binary) ^ (rptr_binary >>1);
assign rptr_binary_addr = rptr_binary [ASIZE-1:0];

always @ (posedge rdclk or negedge in_resetn) begin
	if(!in_resetn) begin
		rptr_binary <= 0;
	end
	else begin
		rptr_binary <= rptr_binary + 	(( sync_wptr_gray != rptr_gray) && in_rd_en) ;
	end
end
endmodule 