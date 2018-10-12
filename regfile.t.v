//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

`include "regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire  	endtest;    	// Set High to signal test completion
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest),
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);

  // Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1:
  //   Write '42' to register 2, verify with Read Ports 1 and 2
  //   (Passes because example register file is hardwired to return 42)
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

  // Verify expectations and report test result
  if((ReadData1 !== 42) || (ReadData2 !== 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 1 Failed");
  end

  // Test Case 2:
  //   Write '15' to register 2, verify with Read Ports 1 and 2
  //   (Fails with example register file, but should pass with yours)
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 15) || (ReadData2 !== 15)) begin
    dutpassed = 0;
    $display("Test Case 2 Failed");
  end

  // Test Case 3: Write Enable is broken / ignored, Register is always written to
  WriteRegister = 5'd4;
  WriteData = 32'd22;
  RegWrite = 0;
  ReadRegister1 = 5'd4;
  ReadRegister2 = 5'd4;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 == 22) || (ReadData2 == 22)) begin // if it was written it's wrong
    dutpassed = 0;
    $display("Test Case 3 Failed, Check WrEnable");
  end

  // Test Case 4: Testing if decoder is broken, check if all registers are written to
  WriteRegister = 5'd4;
  WriteData = 32'd55;
  RegWrite = 1;
  ReadRegister1 = 5'd9; //only wrote to 4, so 9 shouldn't have been written to
  ReadRegister2 = 5'd9;
  #5 Clk=1; #5 Clk=0;

  if(ReadData1 || ReadData2) begin // if it was written to at all it's wrong
    dutpassed = 0;
    $display("Test Case 4 Failed, Check Decoder");
  end

  // Test Case 5: Testing if register 0 is actaully a register
  WriteRegister = 5'd0; //try to write as if it's a register
  WriteData = 32'd82;
  RegWrite = 1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5 Clk=1; #5 Clk=0;

  if(ReadData1 !== 0 || ReadData2 !== 0) begin // if it was written it's wrong
    dutpassed = 0;
    $display("Test Case 5 Failed, Check Zero Register");
  end

  // Test Case 6: Test if one port is not working properly
  WriteRegister = 5'd7; //try to write as if it's a register
  WriteData = 32'd82;
  RegWrite = 1;
  ReadRegister1 = 5'd7;
  ReadRegister2 = 5'd7;
  #5 Clk=1; #5 Clk=0;

  if(ReadData1 !== ReadData2) begin // if not the same, at least one is wrong
    if(ReadData1 !==82) begin
    dutpassed = 0;
    $display("Test Case 6 Failed, Check Read Port 1");
    end
    if(ReadData2 !==82) begin
    dutpassed = 0;
    $display("Test Case 6 Failed, Check Read Port 2");
    end
  end


  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule
