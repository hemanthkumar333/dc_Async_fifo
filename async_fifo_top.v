module async_fifo_top  #(parameter ASIZE = 3, parameter DSIZE = 8)
                  (wrclk, rdclk, in_data, in_wr_en, in_rd_en, in_resetn, out_data, out_full,out_empty);
									
input  wrclk, rdclk,in_wr_en, in_rd_en, in_resetn;
input [DSIZE-1 : 0] in_data;
output[DSIZE-1 : 0] out_data;		
output out_full,out_empty;

wire [ASIZE-1 : 0] waddr, raddr;
wire [ASIZE : 0] sync_wptr_gray, sync_rptr_gray, wptr_gray, rptr_gray;
wire wr_en_ram, rd_en_ram;



fifo_RAM #(ASIZE, DSIZE) fifo_RAM_inst 
                       (.wclk_ram(wrclk), .in_resetn(in_resetn), .write_data_ram(in_data),
							   .waddr (waddr), .raddr(raddr), .wr_en_ram(wr_en_ram), 
								.rd_en_ram(rd_en_ram), .read_data_ram(out_data));	
						
						
synchronizer #(ASIZE)  sync_wptr 
								(.async_signal(wptr_gray), .in_resetn(in_resetn), .dest_clk(rdclk), .sync_signal(sync_wptr_gray));
						

synchronizer #(ASIZE) sync_rptr 
								(.async_signal(rptr_gray), .in_resetn(in_resetn), .dest_clk(wrclk), .sync_signal(sync_rptr_gray)); 

								
wptr_handler#(ASIZE) wptr_handler_inst 
										  (.wrclk(wrclk),.in_resetn(in_resetn), .in_wr_en(in_wr_en), .sync_rptr_gray(sync_rptr_gray),.wptr_binary_addr(waddr), .wptr_gray(wptr_gray), .out_full(out_full), .wr_en_RAM(wr_en_ram));

										  
rptr_handler #(ASIZE) rptr_handler_inst 
										  (.rdclk(rdclk),.in_resetn(in_resetn), .in_rd_en(in_rd_en), .sync_wptr_gray(sync_wptr_gray),.rptr_binary_addr(raddr), .rptr_gray(rptr_gray), .out_empty(out_empty), .rd_en_RAM(rd_en_ram));
							
endmodule						