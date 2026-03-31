module uart_rx(
    input clk,
    input reset,
    input rx,
    output reg [7:0] data_out,
    output reg done
);

parameter CLKS_PER_BIT = 50;

reg [15:0] clk_count = 0;
reg [3:0] bit_index = 0;
reg [7:0] rx_shift = 0;
reg receiving = 0;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        clk_count <= 0;
        bit_index <= 0;
        receiving <= 0;
        done <= 0;
        data_out <= 0;
        rx_shift <= 0;
    end else begin
        done <= 0;

        // Detect start bit
        if(!receiving && rx == 0) begin
            receiving <= 1;
            clk_count <= 0;
            bit_index <= 0;
        end

        else if(receiving) begin
            if(clk_count < CLKS_PER_BIT - 1) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;

                if(bit_index < 8) begin
                    rx_shift[bit_index] <= rx;
                    bit_index <= bit_index + 1;
                end else begin
                    data_out <= rx_shift;
                    done <= 1;
                    receiving <= 0;
                end
            end
        end
    end
end

endmodule