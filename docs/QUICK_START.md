# Quick Start Guide

## Run the AES System

```bash
cd c:\fpga\project
iverilog -o output/aes_advanced.vvp src/aes_encrypt.v src/aes_round.v src/sbox.v tests/testbench_advanced.v
vvp output/aes_advanced.vvp
```

Result: Shows 5 encrypted blocks with performance metrics.

## View Waveform

```bash
cd c:\fpga\project
gtkwave output/wave_advanced.vcd
```

## Which Signals to Select in GTKWave

Essential (must have):
- testbench_advanced.clk
- testbench_advanced.start
- testbench_advanced.done
- testbench_advanced.data_out[127:0]

Optional:
- testbench_advanced.data_in[127:0]
- testbench_advanced.current_key[127:0]

See WAVEFORM_GUIDE.md for detailed signal list.

## Test Results

All tests passing: 5/5 PASS

Test vectors:
1. HIMANSHI key (68696d616e7368690000000000000000) - PASS
2. ADITI key (61646974690000000000000000000000) - PASS
3. KISHOR key (6b6973686f7200000000000000000000) - PASS
4. VEDANT key (766564616e7400000000000000000000) - PASS
5. REFERENCE (00000000000000000000000000000000) - PASS

## Performance

Throughput: 533 Mbps
Latency: 240 ns per block
Blocks/sec: 4,166

## Project Files

Source code (ready to use):
- aes_encrypt.v (main encryption)
- aes_round.v (single round)
- sbox.v (lookup table)
- aes_top.v (system integration)
- uart_rx.v, uart_tx.v, fifo.v (peripherals)

Test benches (ready to run):
- testbench_advanced.v (recommended)
- testbench_direct.v (core verification)
- testbench.v (integration)

## Documentation

README.md
- Complete project overview
- Architecture details
- All design choices explained
- No fluff, all technical content

WAVEFORM_GUIDE.md
- Which signals to view
- How to interpret waveforms
- Tips and tricks

## Project is Clean, Organized, Ready to Present

- No unnecessary files
- All code tested and verified
- Documentation simplified (no scattered md files)
- Waveform guide included
- Performance metrics included
- FIPS 197 compliant
