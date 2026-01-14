`timescale 1ns / 1ps


module FIFO_tb();
        
        parameter ASIZE = 3;
        parameter DSIZE = 8;
        parameter DEPTH = 1<<ASIZE ;
        
        reg [DSIZE-1:0]wdata;
        reg wclk,wrst_n,winc;
        reg rclk,rrst_n,rinc;
        wire [DSIZE-1:0]rdata;
        wire wfull,rempty;
        
        
    FIFO #(DSIZE,ASIZE) fifo (
        .rdata(rdata),
        .wdata(wdata),
        .wfull(wfull),
        .rempty(rempty),
        .wclk(wclk),
        .wrst_n(wrst_n),
        .winc(winc),
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(rinc));
        
        
  integer i=0;
  integer seed =1;
  
  
  
  always #5 wclk = ~wclk;      // faster writing 
  always #10 rclk = ~rclk;     // slower reading
  
  
  initial begin 
        wclk =0;
        rclk= 0;
        wrst_n = 1;
        rrst_n = 1;
        winc = 0;
        rinc = 0;
        wdata = 0;
        
 // reset the fifo 
 
 #40 wrst_n = 0; rrst_n = 0;
 #40 wrst_n = 1; rrst_n = 1;
 
 // TEST CASE 1: Write data and read it back
        rinc = 1;
        for (i = 0; i < 10; i = i + 1) begin
            wdata = $random(seed) % 256;
            winc = 1;
            #10;
            winc = 0;
            #10;
            $display("Time: %t | write_addr: %d | wdata: %d ",$time, fifo.waddr, wdata);
        end
        
// TEST CASE 2: Write data to make FIFO full and try to write more data
        rinc = 0;
        winc = 1;
        for (i = 0; i < DEPTH + 3; i = i + 1) begin
            wdata = $random(seed) % 256;
            #10;
        end
        
 // TEST CASE 3: Read data from empty FIFO and try to read more data
        winc = 0;
        rinc = 1;
        for (i = 0; i < DEPTH + 3; i = i + 1) begin
            #20;
        end
 
 
  $finish;
  end  
 
 endmodule
