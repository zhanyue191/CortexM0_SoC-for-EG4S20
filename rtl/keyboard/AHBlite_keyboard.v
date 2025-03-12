module AHBlite_keyboard(
    input  wire          HCLK,    
    input  wire          HRESETn, 
    input  wire          HSEL,    
    input  wire   [31:0] HADDR,   
    input  wire   [1:0]  HTRANS,  
    input  wire   [2:0]  HSIZE,   
    input  wire   [3:0]  HPROT,   
    input  wire          HWRITE,  
    input  wire   [31:0] HWDATA,  
    input  wire          HREADY,  
    output wire          HREADYOUT, 
    output wire   [31:0] HRDATA,  
    output wire          HRESP,
    input  wire   [3:0]  col,
    output wire   [3:0]  row,
    output wire          key_interrupt
);
//------------------------------------------------------------------------------
// Internal wires declarations
//------------------------------------------------------------------------------
wire trans_req= HREADY & HSEL & HTRANS[1];
// transfer request issued only in SEQ and NONSEQ status and slave is
// selected and last transfer finish

wire S_ahb_rd_trig  = trans_req & (~HWRITE);// AHB read request
wire S_ahb_wr_trig  = trans_req &  HWRITE;  // AHB write request

reg        S_ahb_wr_trig_1d;
reg        S_ahb_wr_trig_2d;
reg [31:0] S_ahb_wr_addr;
reg [31:0] S_ahb_wr_data; 
    
// Registers
reg [31:0] S0_reg;
reg [31:0] S1_reg;
reg [31:0] S2_reg;
reg [31:0] S3_reg;

assign HREADYOUT  = 1'b1;  // slave always ready
assign HRESP      = 1'b0;  // OKAY response from slave

//------------------------------------------------------------------------------
// AHB Write Logic
//------------------------------------------------------------------------------

always @(posedge HCLK) begin
    S_ahb_wr_trig_1d <= S_ahb_wr_trig;
    S_ahb_wr_trig_2d <= S_ahb_wr_trig_1d;
end

always @(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        S_ahb_wr_addr <= 'd0;
    else
        if(S_ahb_wr_trig)
            S_ahb_wr_addr <= HADDR;
        else
            S_ahb_wr_addr <= S_ahb_wr_addr;
end

always @(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        S_ahb_wr_data <= 'd0;
    else
        if(S_ahb_wr_trig_1d)
            S_ahb_wr_data <= HWDATA;
        else
            S_ahb_wr_data <= S_ahb_wr_data;
end

always @(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        begin
            S0_reg <= 'd0;  
            S1_reg <= 'd0;
            S2_reg <= 'd0;
            S3_reg <= 'd0;  	    	
        end
    else
        begin
            if(S_ahb_wr_trig_2d)
                begin
                    case(S_ahb_wr_addr[7:0])
                        8'h00:  S0_reg <= S_ahb_wr_data;
                        8'h04:  S1_reg <= S_ahb_wr_data;
                        8'h08:  S2_reg <= S_ahb_wr_data;
                        8'h0c:  S3_reg <= S_ahb_wr_data;   
                    endcase
                end
            else
                begin
                    S0_reg <= S0_reg;
                    S1_reg <= S1_reg;
                    S2_reg <= S2_reg;
                    S3_reg <= S3_reg;
                end
        end
end

//------------------------------------------------------------------------------
// AHB Read Logic
//------------------------------------------------------------------------------
reg	[31:0] HRDATA_reg;
wire [3:0] data_in;

always @(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        HRDATA_reg <= 'd0;
    else
        begin
            if(S_ahb_rd_trig)
                begin
                    case(HADDR[7:0])
                        8'h00: HRDATA_reg <= S0_reg;
                        8'h04: HRDATA_reg <= S1_reg;
                        8'h08: HRDATA_reg <= S2_reg;
                        8'h0c: HRDATA_reg <= S3_reg;
                        8'h10: HRDATA_reg <= data_in;
                    endcase
                end
            else
                HRDATA_reg <= HRDATA_reg;
        end
end

assign HRDATA = HRDATA_reg;

//------------------------------------------------------------------------------
// User Logic
//------------------------------------------------------------------------------
wire [15:0] key;
keyboard_scan u_keyboard_scan(
    .clk(HCLK),
    .col(col),
    .row(row),
    .key(key)
);
//例化按键消抖模块
wire [15:0] key_deb;
key_filter u_key_filter(
    .clk(HCLK),
    .rstn(HRESETn),
    .key_in(key),
    .key_deb(key_deb),
    .en(key_interrupt)
);
//例化独热码转BCD码模块
onehot2bin1ry u_onehot2bin1ry(
    .clk(HCLK),
    .onehot(key_deb),
    .bin1ry(data_in)
);

endmodule


