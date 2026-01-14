

module FIFO #( parameter DSIZE = 8,
               parameter ASIZE = 4)(
               
        output [DSIZE-1:0] rdata,
        output wfull, rempty, 
        input [DSIZE-1:0] wdata,
        input winc, wclk, wrst_n,
        input rinc, rclk, rrst_n);
        
        

  wire [ASIZE-1:0] waddr, raddr;
  wire [ASIZE :0] wptr, rptr, rq2_wptr, wq2_rptr;
  
  two_ff_sync #(ASIZE+1) sync_r2w (
        .din(rptr),
        .q2(wq2_rptr),
        .clk(wclk),
        .rst_n(wrst_n));
        
  
  two_ff_sync #(ASIZE+1) sync_w2r(
        .din(wptr),
        .q2(rq2_wptr),
        .clk(wclk),
        .rst_n(wrst_n));
  
  
  FIFO_memory #(DSIZE,ASIZE) fifomemory(
        .rdata(rdata),
        .wdata(wdata),
        .waddr(waddr),
        .raddr(raddr),
        .wclk_en(winc),
        .wclk(wclk),
        .wfull(wfull));

  rptr_empty #(ASIZE) rptr_empty(
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(rinc),
        .rq2_wptr(rq2_wptr),
        .rempty(rempty),
        .raddr(raddr),
        .rptr(rptr));
        
  wptr_full #(ASIZE) wptr_full (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .winc(winc),
        .wq2_rptr(wq2_rptr),
        .wfull(wfull),
        .waddr(waddr),
        .wptr(wptr));
        
        
endmodule