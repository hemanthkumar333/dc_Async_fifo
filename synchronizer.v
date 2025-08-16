module synchronizer #(parameter ASIZE = 3) (async_signal, in_resetn, dest_clk, sync_signal);
input [ASIZE:0] async_signal;
input in_resetn, dest_clk;
output [ASIZE:0] sync_signal;

reg [ASIZE:0]intrm_sig1, intrm_sig2;

assign sync_signal = intrm_sig2;

always @(posedge dest_clk or negedge in_resetn) begin
	if (!in_resetn)
		begin
		{intrm_sig2,intrm_sig1} <= 0;
		end
	else
		begin
		{intrm_sig2,intrm_sig1} <= {intrm_sig1, async_signal};
		
		end

end

endmodule 