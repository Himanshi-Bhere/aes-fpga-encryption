module fifo #(parameter WIDTH=8, DEPTH=16)(
    input clk, reset,
    input write_en, read_en,
    input  [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output full, empty
);

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [4:0] w_ptr, r_ptr, count;

assign full  = (count == DEPTH);
assign empty = (count == 0);

always @(posedge clk or posedge reset) begin
    if(reset) begin
        w_ptr    <= 0;
        r_ptr    <= 0;
        count    <= 0;
        data_out <= 0;
    end else begin
        // Write port
        if(write_en && !full) begin
            mem[w_ptr] <= data_in;
            w_ptr      <= w_ptr + 1;
            count      <= count + 1;
        end
        // Read port — data_out is valid the cycle AFTER read_en
        if(read_en && !empty) begin
            data_out <= mem[r_ptr];
            r_ptr    <= r_ptr + 1;
            count    <= count - 1;
        end
    end
end

endmodule
