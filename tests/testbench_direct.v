//================================================
// Direct AES-128 Encryption Test with Name-Based Keys
// Tests aes_encrypt module directly with multiple keys
// Keys derived from: himanshi, aditi, kishor, vedant
//================================================

module testbench_direct;

reg clk = 0;
always #5 clk = ~clk;

reg reset = 1;
reg start = 0;
reg [127:0] data_in = 0;
reg [127:0] current_key = 0;

wire [127:0] data_out;
wire done;

// Single AES Encryption Module - Key will be switched between tests
aes_encrypt enc(
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(data_in),
    .key(current_key),
    .data_out(data_out),
    .done(done)
);

integer test_count = 0;
integer pass_count = 0;

// ═══════════════════════════════════════════════════════════════
// TEST VECTORS (Name-Based Keys)
// ═══════════════════════════════════════════════════════════════

// TEST 1: Key = "himanshi" (68696D616E7368690000000000000000)
reg [127:0] test1_key  = 128'h68696d616e7368690000000000000000;
reg [127:0] test1_pt   = 128'h00112233445566778899aabbccddeeff;
reg [127:0] test1_ct   = 128'h7326a9a709fe5cb42369527b83b1bc65;

// TEST 2: Key = "aditi" (61646974690000000000000000000000)
reg [127:0] test2_key  = 128'h61646974690000000000000000000000;
reg [127:0] test2_pt   = 128'h00112233445566778899aabbccddeeff;
reg [127:0] test2_ct   = 128'h29dee3c33b8694f4f6ee8be195bad86f;

// TEST 3: Key = "kishor" (6B6973686F7200000000000000000000)
reg [127:0] test3_key  = 128'h6b6973686f7200000000000000000000;
reg [127:0] test3_pt   = 128'h00112233445566778899aabbccddeeff;
reg [127:0] test3_ct   = 128'h10841c518e736dd065e9e9e6b0c7b502;

// TEST 4: Key = "vedant" (766564616E7400000000000000000000)
reg [127:0] test4_key  = 128'h766564616e7400000000000000000000;
reg [127:0] test4_pt   = 128'h00112233445566778899aabbccddeeff;
reg [127:0] test4_ct   = 128'hcc32977513c98aafdae68ee4f42d47b7;

// TEST 5: Reference (Original - All Zeros Key)
reg [127:0] test5_key  = 128'h00000000000000000000000000000000;
reg [127:0] test5_pt   = 128'h00000000000000000000000000000000;
reg [127:0] test5_ct   = 128'h66e94bd4ef8a2c3b884cfa59ca342b2e;

initial begin
    $dumpfile("wave_direct.vcd");
    $dumpvars(0, testbench_direct);

    #20 reset = 0;

    $display("\n");
    $display("============================================================");
    $display("  AES-128 Encryption Tests - Name-Based Keys");
    $display("  (Direct Core Test - UART/FIFO Bypass)");
    $display("============================================================");
    $display("\n");

    //=====================================================
    // TEST 1: HIMANSHI
    //=====================================================
    test_count = test_count + 1;
    $display("TEST %0d: HIMANSHI (Name-Based Key)", test_count);
    $display("Key (HEX):   68696d616e7368690000000000000000");
    $display("Plaintext:   %h", test1_pt);
    $display("Expected:    %h", test1_ct);
    
    current_key = test1_key;
    data_in = test1_pt;
    start = 1;
    #10;
    start = 0;
    
    wait(done);
    #20;
    
    $display("Got:         %h", data_out);
    if(data_out == test1_ct) begin
        $display("Status:      PASS");
        pass_count = pass_count + 1;
    end else begin
        $display("Status:      FAIL");
    end
    $display("");
    
    #100;
    reset = 1;
    #20;
    reset = 0;
    #100;

    //=====================================================
    // TEST 2: ADITI
    //=====================================================
    test_count = test_count + 1;
    $display("TEST %0d: ADITI (Name-Based Key)", test_count);
    $display("Key (HEX):   61646974690000000000000000000000");
    $display("Plaintext:   %h", test2_pt);
    $display("Expected:    %h", test2_ct);
    
    current_key = test2_key;
    data_in = test2_pt;
    start = 1;
    #10;
    start = 0;
    
    wait(done);
    #20;
    
    $display("Got:         %h", data_out);
    if(data_out == test2_ct) begin
        $display("Status:      PASS");
        pass_count = pass_count + 1;
    end else begin
        $display("Status:      FAIL");
    end
    $display("");
    
    #100;
    reset = 1;
    #20;
    reset = 0;
    #100;

    //=====================================================
    // TEST 3: KISHOR
    //=====================================================
    test_count = test_count + 1;
    $display("TEST %0d: KISHOR (Name-Based Key)", test_count);
    $display("Key (HEX):   6b6973686f7200000000000000000000");
    $display("Plaintext:   %h", test3_pt);
    $display("Expected:    %h", test3_ct);
    
    current_key = test3_key;
    data_in = test3_pt;
    start = 1;
    #10;
    start = 0;
    
    wait(done);
    #20;
    
    $display("Got:         %h", data_out);
    if(data_out == test3_ct) begin
        $display("Status:      PASS");
        pass_count = pass_count + 1;
    end else begin
        $display("Status:      FAIL");
    end
    $display("");
    
    #100;
    reset = 1;
    #20;
    reset = 0;
    #100;

    //=====================================================
    // TEST 4: VEDANT
    //=====================================================
    test_count = test_count + 1;
    $display("TEST %0d: VEDANT (Name-Based Key)", test_count);
    $display("Key (HEX):   766564616e7400000000000000000000");
    $display("Plaintext:   %h", test4_pt);
    $display("Expected:    %h", test4_ct);
    
    current_key = test4_key;
    data_in = test4_pt;
    start = 1;
    #10;
    start = 0;
    
    wait(done);
    #20;
    
    $display("Got:         %h", data_out);
    if(data_out == test4_ct) begin
        $display("Status:      PASS");
        pass_count = pass_count + 1;
    end else begin
        $display("Status:      FAIL");
    end
    $display("");
    
    #100;
    reset = 1;
    #20;
    reset = 0;
    #100;

    //=====================================================
    // TEST 5: REFERENCE (All Zeros Key)
    //=====================================================
    test_count = test_count + 1;
    $display("TEST %0d: REFERENCE (All Zeros Key)", test_count);
    $display("Key (HEX):   00000000000000000000000000000000");
    $display("Plaintext:   %h", test5_pt);
    $display("Expected:    %h", test5_ct);
    
    current_key = test5_key;
    data_in = test5_pt;
    start = 1;
    #10;
    start = 0;
    
    wait(done);
    #20;
    
    $display("Got:         %h", data_out);
    if(data_out == test5_ct) begin
        $display("Status:      PASS");
        pass_count = pass_count + 1;
    end else begin
        $display("Status:      FAIL");
    end
    $display("");

    // FINAL SUMMARY
    
    $display("\n============================================================");
    $display("TEST SUMMARY");
    $display("============================================================");
    $display("Total Tests:    %0d", test_count);
    $display("Passed:         %0d", pass_count);
    $display("Failed:         %0d", test_count - pass_count);
    if(pass_count == test_count) begin
        $display("Overall:        ALL TESTS PASSED");
    end else begin
        $display("Overall:        SOME TESTS FAILED");
    end
    $display("============================================================\n");

    $finish;
end

endmodule
