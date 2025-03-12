//数码管位选译码模块，低电平有效
module seg_sel_decoder(bit_disp,seg_sel);
    input [2:0] bit_disp;
    output reg [3:0] seg_sel; 
    always @ (bit_disp)
        case (bit_disp)
            3'd1 : seg_sel = 4'b1110;
            3'd2 : seg_sel = 4'b1101;
            3'd3 : seg_sel = 4'b1011;
            3'd4 : seg_sel = 4'b0111;
            default : seg_sel = 4'b1111;
        endcase
endmodule