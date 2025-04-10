module instr_mem( 
    input wire [31:0] pc, 
    output reg [31:0] instr
);

  reg [31:0] instruction_mem [0:255];  
  integer i;

  // Memory initialization
  initial begin
    // Filling instruction memory with a mix of branch, R-type, and I-type instructions

    instruction_mem[0]  = 32'b0000000_00001_00010_000_00011_0110011; // ADD x3, x1, x2
    instruction_mem[1]  = 32'b0100000_00010_00001_000_00100_0110011; // SUB x4, x2, x1
    //instruction_mem[2]  = 32'b0000000_00001_00010_111_00101_0110011; // AND x5, x1, x2
    instruction_mem[2] = 32'b0000000_01001_00001_000_00010_1100011;  // BEQ x1, x2, target
 // BEQ x1, x2, target
  // BEQ x1, x2, target
    instruction_mem[3]  = 32'b0000000_00001_00010_110_00110_0110011; // OR  x6, x1, x2
    instruction_mem[4]  = 32'b0000000_00001_00010_100_00111_0110011; // XOR x7, x1, x2
    instruction_mem[5]  = 32'b0000000_00001_00010_001_01000_0110011; // SLL x8, x1, x2
    instruction_mem[6]  = 32'b0000000_00001_00010_101_01001_0110011; // SRL x9, x1, x2
    instruction_mem[7]  = 32'b0000000_00001_00010_010_01010_0110011; // SLT x10, x1, x2

    // I-type Instructions (opcode: 0010011)
    instruction_mem[8]  = 32'b000000000101_00001_000_01011_0010011; // ADDI x11, x1, 5
    instruction_mem[9]  = 32'b000000000101_00010_111_01100_0010011; // ANDI x12, x2, 5
    instruction_mem[10] = 32'b000000000101_00001_110_01101_0010011; // ORI  x13, x1, 5
    instruction_mem[11] = 32'b000000000101_00010_100_01110_0010011; // XORI x14, x2, 5
    
   
    
    // Filling remaining instruction_mem with zeros for safety
    for(i = 12; i < 64; i = i + 1) begin
      instruction_mem[i] = 32'b00000000000000000000000000000000; // NOPs
    end
  end

  // Asynchronous instruction fetch based on word-aligned PC
  always @(*) begin
    if (pc < 256)
      instr = instruction_mem[pc >> 2];  // Word-aligned access
    else
      instr = 32'h00000000; // Default instruction if address is out of range
  end

endmodule
