//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------
`include "decoders.v"
`include "multiplexer.v"
`include "register.v"

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);
  wire [31:0] regs[31:0];
  wire [31:0] decodeOut;

  decoder1to32 decoder (.out(decodeOut), .enable(RegWrite), .address(WriteRegister));

  register32zero reg0(.q(regs[0]), .d(WriteData), .wrenable(decodeOut[0]), .clk(Clk));
  register32 reg1(.q(regs[1]), .d(WriteData), .wrenable(decodeOut[1]), .clk(Clk));
  register32 reg2(.q(regs[2]), .d(WriteData), .wrenable(decodeOut[2]), .clk(Clk));
  register32 reg3(.q(regs[3]), .d(WriteData), .wrenable(decodeOut[3]), .clk(Clk));
  register32 reg4(.q(regs[4]), .d(WriteData), .wrenable(decodeOut[4]), .clk(Clk));
  register32 reg5(.q(regs[5]), .d(WriteData), .wrenable(decodeOut[5]), .clk(Clk));
  register32 reg6(.q(regs[6]), .d(WriteData), .wrenable(decodeOut[6]), .clk(Clk));
  register32 reg7(.q(regs[7]), .d(WriteData), .wrenable(decodeOut[7]), .clk(Clk));
  register32 reg8(.q(regs[8]), .d(WriteData), .wrenable(decodeOut[8]), .clk(Clk));
  register32 reg9(.q(regs[9]), .d(WriteData), .wrenable(decodeOut[9]), .clk(Clk));
  register32 reg10(.q(regs[10]), .d(WriteData), .wrenable(decodeOut[10]), .clk(Clk));
  register32 reg11(.q(regs[11]), .d(WriteData), .wrenable(decodeOut[11]), .clk(Clk));
  register32 reg12(.q(regs[12]), .d(WriteData), .wrenable(decodeOut[12]), .clk(Clk));
  register32 reg13(.q(regs[13]), .d(WriteData), .wrenable(decodeOut[13]), .clk(Clk));
  register32 reg14(.q(regs[14]), .d(WriteData), .wrenable(decodeOut[14]), .clk(Clk));
  register32 reg15(.q(regs[15]), .d(WriteData), .wrenable(decodeOut[15]), .clk(Clk));
  register32 reg16(.q(regs[16]), .d(WriteData), .wrenable(decodeOut[16]), .clk(Clk));
  register32 reg17(.q(regs[17]), .d(WriteData), .wrenable(decodeOut[17]), .clk(Clk));
  register32 reg18(.q(regs[18]), .d(WriteData), .wrenable(decodeOut[18]), .clk(Clk));
  register32 reg19(.q(regs[19]), .d(WriteData), .wrenable(decodeOut[19]), .clk(Clk));
  register32 reg20(.q(regs[20]), .d(WriteData), .wrenable(decodeOut[20]), .clk(Clk));
  register32 reg21(.q(regs[21]), .d(WriteData), .wrenable(decodeOut[21]), .clk(Clk));
  register32 reg22(.q(regs[22]), .d(WriteData), .wrenable(decodeOut[22]), .clk(Clk));
  register32 reg23(.q(regs[23]), .d(WriteData), .wrenable(decodeOut[23]), .clk(Clk));
  register32 reg24(.q(regs[24]), .d(WriteData), .wrenable(decodeOut[24]), .clk(Clk));
  register32 reg25(.q(regs[25]), .d(WriteData), .wrenable(decodeOut[25]), .clk(Clk));
  register32 reg26(.q(regs[26]), .d(WriteData), .wrenable(decodeOut[26]), .clk(Clk));
  register32 reg27(.q(regs[27]), .d(WriteData), .wrenable(decodeOut[27]), .clk(Clk));
  register32 reg28(.q(regs[28]), .d(WriteData), .wrenable(decodeOut[28]), .clk(Clk));
  register32 reg29(.q(regs[29]), .d(WriteData), .wrenable(decodeOut[29]), .clk(Clk));
  register32 reg30(.q(regs[30]), .d(WriteData), .wrenable(decodeOut[30]), .clk(Clk));
  register32 reg31(.q(regs[31]), .d(WriteData), .wrenable(decodeOut[31]), .clk(Clk));


  mux32to1by32 mux1 (ReadData1, ReadRegister1, regs[0], regs[1], regs[2],
                  regs[3], regs[4], regs[5], regs[6], regs[7], regs[8], regs[9], regs[10],
                  regs[11], regs[12], regs[13], regs[14], regs[15], regs[16], regs[17],
                  regs[18], regs[19], regs[20], regs[21], regs[22], regs[23], regs[24],
                  regs[25], regs[26], regs[27], regs[28], regs[29], regs[30], regs[31]);

  mux32to1by32 mux2 (ReadData2, ReadRegister2, regs[0], regs[1], regs[2],
                  regs[3], regs[4], regs[5], regs[6], regs[7], regs[8], regs[9], regs[10],
                  regs[11], regs[12], regs[13], regs[14], regs[15], regs[16], regs[17],
                  regs[18], regs[19], regs[20], regs[21], regs[22], regs[23], regs[24],
                  regs[25], regs[26], regs[27], regs[28], regs[29], regs[30], regs[31]);

  //assign ReadData2 = 23; testing a fail case
endmodule
