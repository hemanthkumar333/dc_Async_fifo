module fifo_RAM #(parameter ASIZE , parameter DSIZE ) (
    input wclk_ram,
    input in_resetn,
    input [DSIZE-1:0] write_data_ram,
    input [ASIZE-1:0] waddr,
    input [ASIZE-1:0] raddr,
    input wr_en_ram,
    input rd_en_ram,
    output [DSIZE-1:0] read_data_ram
);

localparam FIFO_DEPTH = 1 << ASIZE;

// Define the RAM array
reg [DSIZE-1:0] RAM [0:FIFO_DEPTH-1];
integer i;

// Write to RAM and reset logic
always @(posedge wclk_ram or negedge in_resetn) begin
    if (!in_resetn) begin
        // Asynchronous reset: set all RAM to 0
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            RAM[i] <= 0;
        end
    end else begin
        if (wr_en_ram) begin
            RAM[waddr] <= write_data_ram;
        end
    end
end

// Read data from RAM
assign read_data_ram = rd_en_ram ? RAM[raddr] : {DSIZE{1'b0}}; // zero if not reading

endmodule
