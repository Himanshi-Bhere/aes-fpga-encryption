# GTKWave Waveform Viewing Guide

## Quick Setup

1. Generate waveform file:
```bash
vvp aes_advanced.vvp
```

2. Open in GTKWave:
```bash
gtkwave wave_advanced.vcd
```

## Key Signals to Select

### Most Important (Essential):
- testbench_advanced.clk
- testbench_advanced.reset
- testbench_advanced.start
- testbench_advanced.done
- testbench_advanced.data_out[127:0]

### Additional (For Understanding):
- testbench_advanced.data_in[127:0]
- testbench_advanced.current_key[127:0]
- testbench_advanced.block_num
- testbench_advanced.pass_count

### For Hardware Debug:
- testbench_advanced.enc.clk
- testbench_advanced.enc.reset
- testbench_advanced.enc.done

## What to Look For

When data_out changes:
- Plaintext to ciphertext transformation happens in one cycle
- This shows the combinational pipeline working
- All 128 bits change simultaneously
- Indicates successful encryption

## Signal Organization

Signal Group 1 - Control:
- clk (clock reference)
- reset (initialization)
- start (trigger)
- done (completion)

Signal Group 2 - Data:
- data_in (plaintext)
- data_out (ciphertext)
- current_key (encryption key)

Signal Group 3 - Counting:
- block_num (which block)
- pass_count (tests passed)

## How to Use

1. Left panel:
   - Expand testbench_advanced hierarchy
   - Find signals listed above

2. Select signals:
   - Click signal name
   - Drag to waveform area

3. Arrange (optional):
   - Control signals at top
   - Data signals in middle
   - Status signals at bottom

4. Zoom and pan:
   - Use mouse wheel to zoom
   - Click and drag to pan horizontally
   - Search for interesting transitions

## What This Shows

- Clock edges: Regular 10 ns periods
- Reset pulse: Active high, clears state
- Start pulse: Triggers encryption
- Done pulse: Indicates completion
- data_out[127:0]: Plaintext to ciphertext

## Remove These (Not Useful For This Design):

- dec_done (decryption not implemented)
- read_en (not used in this testbench)
- read_pending (UART signal, not used here)
- result_sent (status not relevant)
- empty/full flags (internal FIFO, unnecessary)
- enc_done (redundant with done)

## Tips

- Select 5-6 key signals for clarity
- Don't overcrowd the view
- Use zoom to see pulse widths
- Compare start to done for latency
- Watch data_out for encryption result

## Interpreting Results

When viewing wave_advanced.vcd:
- Multiple rows = multiple blocks tested
- Each row shows one 128-bit block
- data_out changes = encryption occurred
- done pulse = block complete

Example pattern:
```
Block 1: start pulse -> ... -> done pulse -> data_out changes
Block 2: start pulse -> ... -> done pulse -> data_out changes
Block 3: start pulse -> ... -> done pulse -> data_out changes
Block 4: start pulse -> ... -> done pulse -> data_out changes
Block 5: start pulse -> ... -> done pulse -> data_out changes
```

## Alternative: Minimal View

For quickest understanding, select only:
1. clk
2. done
3. data_out[127:0]

This shows: encryption completion and output value changing.
