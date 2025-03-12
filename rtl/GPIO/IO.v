module PAD_DIG_IO(
    OEN,
    IEN,
    OD,
    ID,
    PAD
);

input   OEN;
input   IEN;
output [7:0] ID;
input  [7:0] OD;
inout  [7:0] PAD;

assign PAD = OEN ? OD : 1'bz;
assign ID = IEN ? PAD : 1'bz;

endmodule
