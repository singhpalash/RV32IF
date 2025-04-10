# RV32IF
 # INTRODUCTION
This project presents the design and implementation of an RV32IF pipelined processor based on the RISC-V architecture. It includes full support for RV32I (integer instructions) and is being extended to support RV32F (floating-point instructions).

The processor is implemented entirely in Verilog, structured in a modular and synthesizable fashion. The design emphasizes clarity, reusability, and scalability, making it suitable for academic purposes and FPGA deployment.
Note: Tomasulo’s algorithm for floating-point instruction scheduling is under development and will be integrated soon.

# Key Features
- 5-stage pipeline architecture:

- Instruction Fetch (IF)

- Instruction Decode (ID)

- Execute (EX)

- Memory Access (MEM)

- Write Back (WB)

- RV32I instruction support:

- Arithmetic and logic instructions

- Load/store operations

- Branches, jumps, and immediate variants

- Basic RV32F support (in progress):

- Pipelined floating-point ALU for Add/Sub, Multiply, Div/Sqrt in floating point

- Separate register files for integer and floating-point units

- Integration with Tomasulo’s algorithm is ongoing

- Hazard handling:

- Basic data forwarding and hazard detection implemented for RV32I

- Floating-point hazard handling will be handled via Tomasulo’s mechanism

- Memory modules:

- Instruction and data memory implemented in Verilog

- FPGA-ready:

- Synthesizable design, compatible with FPGA platforms like ZedBoard, Spartan-3, or Virtex-7




