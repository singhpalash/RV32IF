`timescale 1ns / 1ps

module mem_stage_tb;
    // Testbench signals
    reg clk, rst, mem_enable, mem_read, mem_write, wb_enable_mems, ld_mems;
    reg [4:0] rd_mems;
    reg [31:0] write_data;
    reg [31:0] alu_out;
    wire [31:0] mem_data;
    wire [31:0] result_out;
    wire wb_enable_wb;
    wire [4:0] rd_wb;
    wire ld_wb;

    // Instantiate the memory stage module
    mem_stage uut (
        .clk(clk),
        .rst(rst),
        .mem_enable(mem_enable),
        .wb_enable_mems(wb_enable_mems),
        .rd_mems(rd_mems),
        .ld_mems(ld_mems),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .write_data(write_data),
        .alu_out(alu_out),
        .mem_data(mem_data),
        .result_out(result_out),
        .wb_enable_wb(wb_enable_wb),
        .rd_wb(rd_wb),
        .ld_wb(ld_wb)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        mem_enable = 0;
        mem_read = 0;
        mem_write = 0;
        wb_enable_mems = 0;
        rd_mems = 5'b00000;
        ld_mems = 0;
        write_data = 0;
        alu_out = 0;
        $monitor("Time=%0t, MemEnable=%b, MemRead=%b, AluOut=%0d, MemData=%0d, ResultOut=%0d, LdWb=%b address %0d mem_data_wire %0d", 
                 $time, mem_enable, mem_read, alu_out, mem_data, result_out, ld_wb,uut.address,uut.mem_data_wire);

        // Reset sequence
        #10 rst = 0;
        
        // **Test 1: Load from memory address 0x10**
        #10;
        mem_enable = 1;    // Enable memory access
        mem_write = 1;      // Enable memory read
        alu_out = 32'h10;  // Load from address 0x10
        write_data=32'd9;
        wb_enable_mems = 1;
        ld_mems = 1;
        rd_mems = 5'd3;    // Destination register x3

        #10;
        mem_read = 0;      // Stop memory read
        mem_enable = 0;

        // **Test 2: Load from memory address 0x20**
        #10;
        mem_enable = 1;
        mem_read = 1;
        alu_out = 32'h10;  // Load from address 0x20
        wb_enable_mems = 1;
        ld_mems = 1;
        rd_mems = 5'd5;    // Destination register x5

        #10;
        mem_read = 0;
        mem_enable = 0;

        // **Test 3: Load from memory address 0x30**
        #10;
        mem_enable = 1;
        mem_read = 1;
        alu_out = 32'h30;  // Load from address 0x30
        wb_enable_mems = 1;
        ld_mems = 1;
        rd_mems = 5'd7;    // Destination register x7

        #10;
        mem_read = 1;
        mem_enable = 1;

        // End simulation
        #20;
        $finish;
    end

    // Monitor output
 
endmodule
