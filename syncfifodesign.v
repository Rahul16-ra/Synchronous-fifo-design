`timescale 1ns / 1ps

module fifo_sync #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   wr_en,
    input  wire                   rd_en,
    input  wire [DATA_WIDTH-1:0]  din,

    output reg  [DATA_WIDTH-1:0]  dout,
    output reg                    full,
    output reg                    empty
);

    
    localparam DEPTH = (1 << ADDR_WIDTH);
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;
    reg [ADDR_WIDTH:0] count;

   
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            full  <= 1'b0;
            empty <= 1'b1;
        end else begin
            full  <= (count == DEPTH);
            empty <= (count == 0);
        end
    end

 
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1;
                2'b01: count <= count - 1; 
                default: count <= count;   
            endcase
        end
    end

  
    always @(posedge clk) begin
        if (wr_en && !full) begin
            mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
        end
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout   <= 0;
            rd_ptr <= 0;
            wr_ptr <= 0;
        end else if (rd_en && !empty) begin
            dout <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

endmodule
