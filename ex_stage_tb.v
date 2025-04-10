`timescale 1ns / 1ps


module ex_stage_tb;
    reg clk, rst;
    reg [31:0] a, b, imm_value, pc;
    reg [4:0] rd;
    reg [31:0] linkreg;
    reg ld;
    reg [6:0] op_code;
    reg [2:0] func;
    reg [6:0] funct7;
    reg mem_enable;
    reg mem_read;
    reg mem_write;
    reg wb_enable;
    reg [31:0] fwd_a;
    reg [31:0] fwd_b;
    reg [1:0] forward_a;
    reg [1:0] forward_b;
    
    wire [31:0] result;
    wire flag, jump_taken, branch_taken;
    wire [31:0] branch_addr, jump_address, link_register;
    wire [31:0] data_for_writing_for_sw;
    wire mem_enable_mem, mem_read_mem, mem_write_mem, wb_enable_mem;
    wire [4:0] rd_mem;
    wire ld_mem,flush_out;
    wire mem_wben_fwd;
    wire [4:0] rd_fwd;

    // Instantiate ex_stage module
    ex_stage uut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .fwd_a(fwd_a),
        .fwd_b(fwd_b),
        .forward_a(forward_a),
        .forward_b(forward_b),
        .rd(rd),
        .linkreg(linkreg),
        .ld(ld),
        .mem_enable(mem_enable),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .wb_enable(wb_enable),
        .imm_value(imm_value),
        .op_code(op_code),
        .pc(pc),
        .func(func),
        .funct7(funct7),
        .result(result),
        .flag(flag),
        .jump_taken(jump_taken),
        .branch_taken(branch_taken),
        .branch_addr(branch_addr),
        .jump_address(jump_address),
        .link_register(link_register),
        .data_for_writing_for_sw(data_for_writing_for_sw),
        .mem_enable_mem(mem_enable_mem),
        .mem_read_mem(mem_read_mem),
        .mem_write_mem(mem_write_mem),
        .wb_enable_mem(wb_enable_mem),
        .rd_mem(rd_mem),
        .ld_mem(ld_mem),
        .flush_out(flush_out),
        .mem_wben_fwd(mem_wben_fwd),
        .rd_fwd(rd_fwd)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0;
        
        $monitor("TIME:%0t result:%h flag:%b jump_taken:%b branch_taken:%b rd_mem:%b ld_mem:%b flush_out:%b mem_wben_fwd %0b mem rd_fwd %0b",
                 $time, result, flag, jump_taken, branch_taken, rd_mem, ld_mem,flush_out,
                 mem_wben_fwd,rd_fwd);
        
        // Initialize values
        mem_enable = 1'b1;
        mem_read = 1'b1;
        mem_write = 1'b1;
        wb_enable = 1'b1;
        ld = 1'b1;
        rd = 5'b00000;
        a = 32'h00000005;
        b = 32'h00000003;
        op_code = 7'b0110011;
        func = 3'b000;
        funct7 = 7'b0000000;
        forward_a=2'b00;
        forward_b=2'b00;

        #10;
        
        // Test1 SLL
        $display("SLL");
        func = 3'b001;
        #10;

        // Test2 SLT
        $display("SLT");
        func = 3'b010;
        #10;

        // Test3 XOR operation
        $display("xor");
        func = 3'b100;
        #10;

        // Test4 OR operation
        $display("or");
        func = 3'b110;
        #10;

        // Test5 ADDI
        $display("addi");
        op_code = 7'b0010011;
        func = 3'b000;
        imm_value = 32'h00000004;
        rd = 5'b00001;
        #10;

        // Test6 BEQ
        $display("beq(taken case)");
        op_code = 7'b1100011;
        func = 3'b000;
        a = 32'h00000005;
        b = 32'h00000005;
        pc = 32'h00000010;
        imm_value = 32'h4;
        #10;
        
        // Test7 BEQ for branch not taken
        $display("beq(not taken case)");
        op_code = 7'b1100011;
        func = 3'b000;
        a = 32'h00000005;
        b = 32'h00000004;
        pc = 32'h00000010;
        imm_value = 32'h4;
        #10;

        // Test8 JAL
        $display("JAL");
        op_code = 7'b1101111;
        linkreg = 32'd1024;
        #10;

        // Test9 SW
        $display("sw");
        op_code = 7'b0100011;
        imm_value = 32'h5;
        a = 32'd5;
        b = 32'd7;
        #10;
        
        //Test10 forwarding operation
        $display("fwd check");
        forward_a=2'b10;
        fwd_a=32'd4;
        op_code = 7'b0010011;
        func = 3'b000;
        imm_value = 32'h00000004;
        rd = 5'b00001;
        $display("result:%0h",result);
        #10;
        

        $stop;
    end
endmodule

