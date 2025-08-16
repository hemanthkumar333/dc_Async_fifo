module wptr_handler #(parameter ASIZE = 3) (wrclk,in_resetn, in_wr_en, sync_rptr_gray,wptr_binary_addr, wptr_gray, out_full, wr_en_RAM);
input [ASIZE:0] sync_rptr_gray;
input in_wr_en, wrclk,in_resetn;
output [ASIZE-1:0] wptr_binary_addr;
output [ASIZE:0] wptr_gray;
output wr_en_RAM, out_full;

reg [ASIZE:0] wptr_binary;

assign out_full =  ({~sync_rptr_gray[ASIZE:ASIZE-1], sync_rptr_gray[ASIZE-2:0]} == wptr_gray);
assign wr_en_RAM = ({~sync_rptr_gray[ASIZE:ASIZE-1], sync_rptr_gray[ASIZE-2:0]} != wptr_gray) && in_wr_en; // out_full && in_wr_en;
assign wptr_gray = ( wptr_binary) ^ (wptr_binary >>1);
assign wptr_binary_addr = wptr_binary [ASIZE-1:0];
always @ (posedge wrclk or negedge in_resetn) begin
	if(!in_resetn) begin
		wptr_binary <= 0;
	end
	else begin
		wptr_binary <= wptr_binary + 	(({~sync_rptr_gray[ASIZE:ASIZE-1], sync_rptr_gray[ASIZE-2:0]} != wptr_gray) && in_wr_en) ; // wptr_binary + wr_en_RAM
	end
end
endmodule 