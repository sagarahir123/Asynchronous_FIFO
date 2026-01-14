

module wptr_full #( parameter ADDR_SIZE =4)(
    
    input [ADDR_SIZE:0] wq2_rptr,
    input winc, wclk, wrst_n,
    output reg wfull,
    output [ADDR_SIZE-1:0] waddr,
    output reg [ADDR_SIZE:0] wptr);
    
    
 wire wfull_val;  
 wire [ADDR_SIZE:0]wbin_next,wgray_next;
 reg [ADDR_SIZE:0]wbin;
    

always@(posedge wclk or negedge wrst_n)begin
    if (!wrst_n)
       {wbin,wptr}<= 0;
    else 
    {wbin,wptr}<= {wbin_next, wgray_next};
    
 end 
 
 assign wbin_next = wbin + (winc && ~wfull);
 assign waddr = wbin[ADDR_SIZE-1:0];
 assign wgray_next = (wbin_next >>1)^ wbin_next;
 
 
 assign wfull_val = (wgray_next == { ~wq2_rptr[ADDR_SIZE:ADDR_SIZE-1], wq2_rptr[ADDR_SIZE-2:0]});
 
 always@(posedge wclk or negedge wrst_n )begin
    if (!wrst_n)
        wfull<= 1'b0;
    else 
      wfull<= wfull_val;
  end 
  
endmodule