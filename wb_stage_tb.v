`timescale 1ns / 1ps

`timescale 1ns/1ps

module wb_stage_tb;
    reg clk;
    reg rst;
    reg wb_enable;
    reg [4:0] rd;
    reg [31:0] wb_data;
    reg [31:0] mem_data;
    reg ld_instr;
    wire [4:0] rd_out;
    wire [31:0] wb_data_out;

    // Instantiate the DUT (Device Under Test)
    wb_stage uut (
        .clk(clk),
        .rst(rst),
        .wb_enable(wb_enable),
        .rd(rd),
        .wb_data(wb_data),
        .mem_data(mem_data),
        .ld_instr(ld_instr),
        .rd_out(rd_out),
        .wb_data_out(wb_data_out)
    );

    // Generate clock
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        wb_enable = 0;
        rd = 5'b00000;
        wb_data = 32'h00000000;
        mem_data = 32'h00000000;
        ld_instr = 0;

        // Apply reset
        #10 rst = 0;

        // Test Case 1: Writeback from ALU result
        #10;
        wb_enable = 1;
        rd = 5'b00010;
        wb_data = 32'hA5A5A5A5;
        mem_data = 32'h5A5A5A5A;
        ld_instr = 0;
        #10;
        
        // Test Case 2: Load instruction (Writeback from memory)
        ld_instr = 1;
        #10;
        
        // Test Case 3: Change register destination
        rd = 5'b00100;
        wb_data = 32'hDEADBEEF;
        mem_data = 32'hBEEFDEAD;
        ld_instr = 0;
        #10;
        
        // Test Case 4: Reset behavior
        rst = 1;
        #10;
        rst = 0;
        #10;
        
        // Stop simulation
        $stop;
    end
endmodule
