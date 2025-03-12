`timescale 1 ps/ 1 ps
module CortexM0_SoC_vlg_tst();

reg clk;
reg RSTn;
reg [7:0] sw;
                        
CortexM0_SoC i1 (
    .clk(clk),
    .RSTn(RSTn),
    .SW(sw)
);

initial begin                                                  
    clk = 0;
    RSTn=0;
    #100
    RSTn=1;
    sw = 8'haa;
end  
    
always begin                                                  
    #10 clk = ~clk;
end       

endmodule
