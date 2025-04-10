# RV32IF
 # INTRODUCTION
This project presents the design and implementation of an RV32IF pipelined processor based on the RISC-V architecture. It includes full support for RV32I (integer instructions) and is being extended to support RV32F (floating-point instructions).

The processor is implemented entirely in Verilog, structured in a modular and synthesizable fashion. The design emphasizes clarity, reusability, and scalability, making it suitable for academic purposes and FPGA deployment.
Note: Tomasulo’s algorithm for floating-point instruction scheduling is under development and will be integrated soon.

# Key Features
 # 1) 5-stage pipeline architecture:

  - Instruction Fetch (IF)

  - Instruction Decode (ID)

  - Execute (EX)

  - Memory Access (MEM)

  - Write Back (WB)

 # 2) RV32I instruction support:

  - Arithmetic and logic instructions

  - Load/store operations

  - Branches, jumps, and immediate variants

  - Basic RV32F support (in progress):

  - All instructions of base class supported except byte level load,store and system calls

 # 3) Pipelined floating-point ALU for Add/Sub, Multiply, Div/Sqrt in floating point

  - Each operation (FADD.S, FSUB.S, FMUL.S, FDIV.S, FSQRT.S) is implemented in separate pipelined units to allow parallelism and reduce execution latency.

  - FP ALUs are designed to support multi-cycle operations using stage-wise handshaking, ensuring proper sequencing and pipeline flushing when needed.

 # 4) Separate register files for integer and floating-point units
 
  - The processor uses dedicated register files for x0–x31 (integer) and f0–f31 (floating-point) as per RISC-V conventions, allowing parallel access without contention.

  - Each register file is dual-port, enabling simultaneous read/write operations essential for pipelined execution.

 # 5) Integration with Tomasulo’s algorithm is ongoing

 -  Design includes reservation stations, common data bus (CDB), and reorder buffer (ROB) to support out-of-order execution of floating-point instructions.

 - Tomasulo’s integration aims to eliminate structural and WAW/RAW hazards in floating-point pipelines, allowing dynamic scheduling and latency hiding for long-latency 
   operations like division/sqrt.

 # 6) Hazard handling:

  - Basic data forwarding and hazard detection implemented for RV32I

  - Floating-point hazard handling will be handled via Tomasulo’s mechanism

 # 7) Memory modules:

  - Instruction and data memory implemented in Verilog

 # 8) FPGA-ready:

  - Synthesizable design, compatible with FPGA platforms like ZedBoard, Spartan-3, or Virtex-7

# Tools & Technologies

- Language: Verilog HDL

- Simulation: Vivado Simulator

- Synthesis: Xilinx Vivado

- Target FPGAs: ZedBoard, Spartan-3, Virtex-7

# Work in Progress

 - Tomasulo’s algorithm for dynamic scheduling of RV32F instructions

 - Scoreboarding and reservation stations for FP execution

 - Stall and replay handling for out-of-order floating-point instructions

 - Formal verification using assertion-based testbenches



