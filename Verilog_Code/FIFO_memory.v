

module FIFO_memory #(parameter DATA_SIZE =8,
                     parameter ADDR_SIZE =4)(
                     
       output[DATA_SIZE-1:0] rdata,
       input [DATA_SIZE-1:0] wdata,
       input [ADDR_SIZE-1:0]waddr,raddr,
       input wclk_en, wclk, wfull);
       
       
  localparam DEPTH = 1<< ADDR_SIZE ;
  
  reg [DATA_SIZE-1:0] mem [0:DEPTH-1];         // memory array
  
// read data
  
  assign rdata = mem[raddr];
  
// write data 

 always@( posedge wclk)begin
    if (wclk_en && ~wfull)
        mem[waddr] <= wdata;
 end 

endmodule
   