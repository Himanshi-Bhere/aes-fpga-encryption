module aes_top(
    input  clk, reset,
    input  rx,
    input  mode,
    output tx,
    output [127:0] result
);

// ── UART RX ───────────────────────────────────────────────────────────────────
wire [7:0] uart_data;
wire       uart_done;

uart_rx uart(
    .clk     (clk),
    .reset   (reset),
    .rx      (rx),
    .data_out(uart_data),
    .done    (uart_done)
);

// ── FIFO ──────────────────────────────────────────────────────────────────────
wire [7:0] fifo_out;
wire       empty;
reg        read_en;

fifo fifo_inst(
    .clk     (clk),
    .reset   (reset),
    .write_en(uart_done),
    .read_en (read_en),
    .data_in (uart_data),
    .data_out(fifo_out),
    .empty   (empty)
);

// ── Block builder (accumulate 16 bytes into 128-bit block) ─────────────────────
reg [127:0] block;
reg [4:0]   count;
reg         read_pending;
reg         start_reg;
reg         uart_done_r;  // Delay uart_done by one cycle

always @(posedge clk or posedge reset) begin
    if(reset) begin
        block        <= 0;
        count        <= 0;
        read_en      <= 0;
        read_pending <= 0;
        start_reg    <= 0;
        uart_done_r  <= 0;
    end else begin
        read_en   <= 0;   // default: deassert each cycle
        start_reg <= 0;   // default: no start pulse
        uart_done_r <= uart_done;  // Delay uart_done by one cycle

        // Phase 1 — request FIFO read ONE CYCLE after uart_done (gives FIFO time to accept write)
        if(uart_done_r && count < 16 && !read_pending && !empty) begin
            read_en      <= 1;
            read_pending <= 1;
        end

        // Phase 2 — FIFO output is now valid (one cycle after read_en), capture into block
        if(read_pending) begin
            // Place byte at the correct position in block
            block[127 - count*8 -: 8] <= fifo_out;
            count        <= count + 1;
            read_pending <= 0;
        end

        // Fire start for one cycle when 16 bytes collected
        if(count == 16) begin
            start_reg <= 1;
            count     <= 0;
            block     <= 0;
        end
    end
end

// ── AES Encryption Engine (Decryption removed - focus on proven encryption) ──
wire [127:0] enc_out;
wire         enc_done;

aes_encrypt enc(
    .clk    (clk),
    .reset  (reset),
    .start  (start_reg),
    .data_in(block),
    .key    (128'h000102030405060708090a0b0c0d0e0f),
    .data_out(enc_out),
    .done   (enc_done)
);

// Output assignment (encryption only mode)
wire [127:0] final_result = enc_out;
assign result = final_result;

// ── UART TX — send result bytes, guarded against re-trigger ──────────────────
wire tx_busy;
reg  tx_start;
reg  [7:0] tx_data;
reg  [4:0] tx_count;
reg        sending;
reg        result_sent;   // prevents re-trigger on same enc_done pulse

uart_tx transmitter(
    .clk    (clk),
    .reset  (reset),
    .start  (tx_start),
    .data_in(tx_data),
    .tx     (tx),
    .busy   (tx_busy)
);

always @(posedge clk or posedge reset) begin
    if(reset) begin
        tx_start    <= 0;
        tx_count    <= 0;
        sending     <= 0;
        tx_data     <= 0;
        result_sent <= 0;
    end else begin
        tx_start <= 0;   // default deassert

        // Clear sent flag when a new start_reg fires (new block incoming)
        if(start_reg)
            result_sent <= 0;

        // Begin TX when AES encryption finishes
        if(enc_done && !sending && !result_sent) begin
            sending     <= 1;
            tx_count    <= 0;
            result_sent <= 1;
        end

        // Shift out one byte per UART TX cycle
        if(sending && !tx_busy) begin
            tx_data  <= final_result[127 - tx_count*8 -: 8];
            tx_start <= 1;
            tx_count <= tx_count + 1;

            if(tx_count == 15)
                sending <= 0;
        end
    end
end

endmodule
