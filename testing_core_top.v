`timescale 1ns / 1ps

module testing_core_top(
    input wire clk, 
    input wire rst
);


    // IF Stage Outputs
    wire [31:0] pc_out;        // Current PC value
    wire [31:0] instr_out;     // Instruction fetched from memory

    // Branch Target & Control Signals
    wire [31:0] nagout;        // Branch Target Address (Calculated in ID stage)
    wire branch_enable;        // Branch enable signal
    wire jal_en;               // JAL enable signal
    wire jalr_en;              // JALR enable signal

    // ID Stage Outputs (Additional Signals)
    wire [31:0] mux_out_pcora;  // Selected PC or Register A output
    wire [31:0] mux_out_borimm; // Selected Register B or Immediate
    wire [31:0] rs1_data;       // Register Source 1 Data
    wire [31:0] rs2_data;       // Register Source 2 Data
    wire [31:0] imm_value;      // Immediate Value
    wire [31:0] pc_value;       // PC Value passed to EX stage
    wire [31:0] nextpc;         // Next PC when branch/jump occurs
    wire [4:0] rd_register;     // Destination Register (Propagated to WB)
    wire [2:0] func_data_out;   // Function Field (Funct3)
    wire [6:0] func_7_out;      // Function7 Field (Funct7)
    wire [6:0] op_code_out;     // Opcode Field
    wire [31:0] linkreg;        // Link Register for JAL/JALR
    wire [31:0] instr_dec_out;  // Instruction forwarded to FP unit
    wire flush_out;
    wire mem_enable_out;
    wire mem_read_out;
    wire mem_write_out;
    wire wb_enable_out;
    wire ld_enable_out;
    wire [4:0] rs1_fwd;
    wire [4:0] rs2_fwd;
    
    // EX Stage Outputs
    wire [31:0] ex_result;
    wire ex_jump_taken;
    wire ex_branch_taken;
    wire [31:0] ex_branch_addr;
    wire [31:0] ex_jump_address;
    wire [31:0] ex_link_register;
    wire [31:0] ex_data_for_writing_for_sw;
    wire ex_mem_enable_mem;
    wire ex_mem_read_mem;
    wire ex_mem_write_mem;
    wire ex_wb_enable_mem;
    wire [4:0] ex_rd_mem;
    wire ex_ld_mem;
    wire mem_wben_fwd;
    wire [4:0] rd_fwd;
    
    //mem stage output //
    wire [31:0] mem_data_out;
    wire [31:0] result_out_mem;
    wire wb_enable_wb;
    wire [4:0] rd_wb;
    wire ld_wb;
    wire wb_enable_fwd;
    wire [4:0] rd_wb_fwd;
   
   //fwd unit outputs//
   wire [1:0] forward_a, forward_b;
   wire [31:0] fwd_a,fwd_b;
   
   // wb stage outputs//
   
   wire [4:0] rd_out;
   wire [31:0] wb_data_out;
   wire reg_write_enable;

    

    if_stage_p1 if_stage (
        .clk(clk),
        .rst(rst),
        .nagout(nextpc),  // Next Address Generator Output (Branch Target)
        .branch_enable(branch_enable),
        .jal_en(jal_en),
        .jalr_en(jalr_en),
        .pc_out(pc_out),
        .instr_out(instr_out),
        .flush_out(flush_out)
    );

 
    Id_stage id_stage (
        .clk(clk),
        .rst(rst),
        .instruction(instr_out),  // Instruction from IF stage
        .wb_data(wb_data_out),         // coming from wb_stage
        .reg_write_en(reg_write_enable),     // coming from wb_stage
        .pc(pc_out),             // Current PC value
        .rd_in(rd_out),            // coming from wb_stage
        .flush_out(flush_out),        // No flush needed
        .mux_out_pcora(mux_out_pcora),
        .mux_out_borimm(mux_out_borimm),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm_value(imm_value),
        .pc_value(pc_value),
        .nextpc(nextpc),
        .rd_register(rd_register),
        .func_data_out(func_data_out),
        .func_7_out(func_7_out),
        .op_code_out(op_code_out),
        .linkreg(linkreg),
        .instr_out(instr_dec_out),
        .branch_enable_out(branch_enable),
        .jal_en_out(jal_en),
        .jalr_en_out(jalr_en),
        .mem_enable_out(mem_enable_out),
        .mem_read_out(mem_read_out),
        .mem_write_out(mem_write_out),
        .wb_enable_out(wb_enable_out),
        .ld_enable_out(ld_enable_out),
        .rs1_fwd(rs1_fwd),
        .rs2_fwd(rs2_fwd)
    );
    
   
    ex_stage ex_stage (
        .clk(clk),
        .rst(rst),
        .a(rs1_data),
        .b(rs2_data),
        .fwd_a(fwd_a),
        .fwd_b(fwd_b),
        .forward_a(forward_a),
        .forward_b(forward_b),
        .rd(rd_register),
        .linkreg(linkreg),
        .ld(ld_enable_out),
        .mem_enable(mem_enable_out),
        .mem_read(mem_read_out),
        .mem_write(mem_write_out),
        .wb_enable(wb_enable_out),
        .imm_value(imm_value),
        .op_code(op_code_out),
        .pc(pc_value),
        .func(func_data_out),
        .funct7(func_7_out),
        .result(ex_result),
        .jump_taken(ex_jump_taken),
        .branch_taken(ex_branch_taken),
        .branch_addr(ex_branch_addr),
        .jump_address(ex_jump_address),
        .link_register(ex_link_register),
        .data_for_writing_for_sw(ex_data_for_writing_for_sw),
        .mem_enable_mem(ex_mem_enable_mem),
        .mem_read_mem(ex_mem_read_mem),
        .mem_write_mem(ex_mem_write_mem),
        .wb_enable_mem(ex_wb_enable_mem),
        .rd_mem(ex_rd_mem),
        .ld_mem(ex_ld_mem),
        .flush_out(flush_out),
        .mem_wben_fwd(mem_wben_fwd),
        .rd_fwd(rd_fwd)
    );
    
    forwd_unit fwd_unit (.ex_rs1(rs1_fwd),.ex_rs2(rs2_fwd),.mem_rd(rd_fwd),
                         .wb_rd(rd_wb_fwd),.mem_reg_write(mem_wben_fwd),
                         .wb_reg_write(wb_enable_fwd),.ex_result(ex_result),
                         .mem_result(result_out_mem),
                         .forward_a(forward_a),
                         .forward_b(forward_b),
                         .fwd_a_data(fwd_a),
                         .fwd_b_data(fwd_b));

    
    
    mem_stage mem_stage (
        .clk(clk),
        .rst(rst),
        .mem_enable(ex_mem_enable_mem),
        .wb_enable_mems(ex_wb_enable_mem),
        .rd_mems(ex_rd_mem),
        .ld_mems(ex_ld_mem),
        .mem_read(ex_mem_read_mem),
        .mem_write(ex_mem_write_mem),
        .write_data(ex_data_for_writing_for_sw),
        .alu_out(ex_result),
        .mem_data(mem_data_out),
        .result_out(result_out_mem),
        .wb_enable_wb(wb_enable_wb),
        .rd_wb(rd_wb),
        .ld_wb(ld_wb),
        .rd_wb_fwd(rd_wb_fwd),
        .wb_enable_fwd(wb_enable_fwd)
    );
    
     wb_stage wb_stage (
        .clk(clk),
        .rst(rst),
        .wb_enable(wb_enable_wb),
        .rd(rd_wb),
        .wb_data(result_out_mem),
        .mem_data(mem_data_out),
        .ld_instr(ld_wb),
        .rd_out(rd_out),
        .wb_data_out(wb_data_out),
        .reg_write_enable(reg_write_enable)
    );
    
    
    
    
endmodule






