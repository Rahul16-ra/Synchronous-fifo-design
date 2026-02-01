`timescale 1ns / 1ps

module fifo_sync_tb;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] din;

    wire [7:0] dout;
    wire full;
    wire empty;

    fifo_sync #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(3)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;

       
        #20 rst = 0;

        
        repeat (5) begin
            @(posedge clk);
            wr_en = 1;
            din = din + 1;
        end
        @(posedge clk);
        wr_en = 0;

        
        repeat (5) begin
            @(posedge clk);
            rd_en = 1;
        end
        @(posedge clk);
        rd_en = 0;

        #50 $stop;
    end

endmodule
