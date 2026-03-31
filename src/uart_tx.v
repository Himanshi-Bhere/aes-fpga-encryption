module uart_tx(
    input clk, reset,
    input start,
    input [7:0] data_in,
    output reg tx,
    output reg busy
);

parameter CLKS_PER_BIT = 50;

reg [13:0] clk_count;
reg [3:0]  bit_index;
reg [9:0]  tx_shift;   // {stop, d7..d0, start}

always @(posedge clk or posedge reset) begin
    if(reset) begin
        tx        <= 1;   // idle high
        busy      <= 0;
        clk_count <= 0;
        bit_index <= 0;
        tx_shift  <= 10'h3FF;
    end else begin

        if(start && !busy) begin
            busy      <= 1;
            // Frame: start=0, d0..d7, stop=1  (LSB first)
            tx_shift  <= {1'b1, data_in, 1'b0};
            bit_index <= 0;
            clk_count <= 0;
            tx        <= 0;   // drive start bit immediately
        end

        if(busy) begin
            if(clk_count < CLKS_PER_BIT - 1) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;
                bit_index <= bit_index + 1;

                if(bit_index < 9) begin
                    // Shift out next bit (index 0 = start already sent)
                    tx <= tx_shift[bit_index + 1];
                end

                if(bit_index == 9) begin
                    // Stop bit just finished
                    busy <= 0;
                    tx   <= 1;
                end
            end
        end
    end
end

endmodule
