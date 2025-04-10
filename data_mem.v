
module data_mem(
    input wire clk,
    input wire mem_enable,
    input wire mem_read,
    input wire mem_write,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output reg [31:0] mem_data_out
);

    reg [31:0] memory [0:255];  // Example: 256-word memory
    integer i;
    


    // Asynchronous Read: Get data in the same cycle
    always @(*) begin
        if (mem_enable && mem_read)
            mem_data_out = memory[address];  // Word-aligned access
        else
            mem_data_out = 32'b0; // Default when not reading
    end

    // Synchronous Write: Data is written on clock edge
    always @(posedge clk) begin
        if (mem_enable && mem_write)
            memory[address] <= write_data;  // Write at next clock edge
    end

endmodule
