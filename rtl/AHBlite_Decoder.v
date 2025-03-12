module AHBlite_Decoder
#(
    /*RAMCODE enable parameter*/
    parameter Port0_en = 1,
    /************************/

    /*RAMDATA  enable parameter*/
    parameter Port1_en = 1,
    /************************/

    /*GPIO enable parameter*/
    parameter Port2_en = 1,
    /************************/

    /*Keyboard enable parameter*/
    parameter Port3_en = 1,
    /************************/

    /*SEG enable parameter*/
    parameter Port4_en = 1
    /************************/

    
)(
    input wire [31:0] HADDR,

    /*RAMCODE OUTPUT SELECTION SIGNAL*/
    output wire P0_HSEL,

    /*RAMDATA OUTPUT SELECTION SIGNAL*/
    output wire P1_HSEL,

    /*GPIO OUTPUT SELECTION SIGNAL*/
    output wire P2_HSEL,

    /*Keyboard OUTPUT SELECTION SIGNAL*/
    output wire P3_HSEL,       

    /*SEG OUTPUT SELECTION SIGNAL*/
    output wire P4_HSEL  
);

//------------------------------------------------------------------------------
// RAMCODE 0x00000000-0x0000ffff
//------------------------------------------------------------------------------

/*Insert RAMCODE base address there*/
assign P0_HSEL = (HADDR[31:16] == 16'h0000) ? Port0_en : 1'd0;
/***********************************/

//------------------------------------------------------------------------------
// RAMDATA 0X20000000-0X2000FFFF
//------------------------------------------------------------------------------
/*Insert RAMDATA base address there*/
assign P1_HSEL = (HADDR[31:16] == 16'h2000) ? Port1_en : 1'b0;
/***********************************/

//------------------------------------------------------------------------------
// GPIO 0X40000000-0X4000FFFF
//------------------------------------------------------------------------------
/*Insert GPIO base address there*/
assign P2_HSEL = (HADDR[31:16] == 16'h4000) ? Port2_en : 1'd0;
/***********************************/

//------------------------------------------------------------------------------
// Keyboard 0X40010000-0X4001FFFF
//------------------------------------------------------------------------------
/*Insert Keyboard base address there*/
assign P3_HSEL = (HADDR[31:16] == 16'h4001) ? Port3_en : 1'd0;
/***********************************/

//------------------------------------------------------------------------------
// SEG 0X40020000-0X4002FFFF
//------------------------------------------------------------------------------
/*Insert SEG base address there*/
assign P4_HSEL = (HADDR[31:16] == 16'h4002) ? Port4_en : 1'd0;
/***********************************/



endmodule