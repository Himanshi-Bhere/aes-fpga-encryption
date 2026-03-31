module aes_round(
    input  [127:0] state_in,
    input  [127:0] round_key,
    output [127:0] state_out
);

// ── SubBytes ─────────────────────────────────────────────────────────────────
// AES state is stored as bytes: state_in[127:120]=byte0, ..., state_in[7:0]=byte15
wire [7:0] sb [0:15];

genvar i;
generate
    for(i = 0; i < 16; i = i+1) begin : sbox_loop
        sbox sbox_inst(
            .in (state_in[127 - i*8 -: 8]),
            .out(sb[i])
        );
    end
endgenerate

// ── ShiftRows ────────────────────────────────────────────────────────────────
// AES state as 4x4 byte matrix (column-major, row r / col c = byte[r+4c]):
//   byte index: 0  4  8  12
//               1  5  9  13
//               2  6  10 14
//               3  7  11 15
//
// ShiftRows: row 0 no shift, row 1 left-1, row 2 left-2, row 3 left-3
//
//   Row 0: sb[0],  sb[4],  sb[8],  sb[12]  → unchanged
//   Row 1: sb[1],  sb[5],  sb[9],  sb[13]  → sb[5], sb[9],  sb[13], sb[1]
//   Row 2: sb[2],  sb[6],  sb[10], sb[14]  → sb[10],sb[14], sb[2],  sb[6]
//   Row 3: sb[3],  sb[7],  sb[11], sb[15]  → sb[15],sb[3],  sb[7],  sb[11]
//
// Resulting column-major order after ShiftRows:
wire [7:0] sr [0:15];

assign sr[0]  = sb[0];   assign sr[4]  = sb[4];   assign sr[8]  = sb[8];   assign sr[12] = sb[12];
assign sr[1]  = sb[5];   assign sr[5]  = sb[9];   assign sr[9]  = sb[13];  assign sr[13] = sb[1];
assign sr[2]  = sb[10];  assign sr[6]  = sb[14];  assign sr[10] = sb[2];   assign sr[14] = sb[6];
assign sr[3]  = sb[15];  assign sr[7]  = sb[3];   assign sr[11] = sb[7];   assign sr[15] = sb[11];

// ── MixColumns ───────────────────────────────────────────────────────────────
// GF(2^8) multiply-by-2: left shift, XOR 0x1b if bit 7 was set
function [7:0] xtime;
    input [7:0] a;
    xtime = (a[7] == 1'b1) ? ((a << 1) ^ 8'h1b) : (a << 1);
endfunction

// MixColumns column transform:
//   [2 3 1 1]   [a0]
//   [1 2 3 1] × [a1]
//   [1 1 2 3]   [a2]
//   [3 1 1 2]   [a3]
// where multiplication is in GF(2^8) and addition is XOR
wire [7:0] mc [0:15];

genvar c;
generate
    for(c = 0; c < 4; c = c+1) begin : mixcol
        wire [7:0] a0 = sr[c*4+0];
        wire [7:0] a1 = sr[c*4+1];
        wire [7:0] a2 = sr[c*4+2];
        wire [7:0] a3 = sr[c*4+3];
        // 2*x ^ 3*x = xtime(x) ^ x ^ x  (3x = 2x XOR x)
        assign mc[c*4+0] = xtime(a0) ^ (xtime(a1)^a1) ^ a2          ^ a3;
        assign mc[c*4+1] = a0         ^ xtime(a1)      ^ (xtime(a2)^a2) ^ a3;
        assign mc[c*4+2] = a0         ^ a1              ^ xtime(a2)      ^ (xtime(a3)^a3);
        assign mc[c*4+3] = (xtime(a0)^a0) ^ a1         ^ a2              ^ xtime(a3);
    end
endgenerate

// ── AddRoundKey ──────────────────────────────────────────────────────────────
wire [127:0] mix_out;
assign mix_out = {
    mc[0],  mc[1],  mc[2],  mc[3],
    mc[4],  mc[5],  mc[6],  mc[7],
    mc[8],  mc[9],  mc[10], mc[11],
    mc[12], mc[13], mc[14], mc[15]
};

assign state_out = mix_out ^ round_key;

endmodule
