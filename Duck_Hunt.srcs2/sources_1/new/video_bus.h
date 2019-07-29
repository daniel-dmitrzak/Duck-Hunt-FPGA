/*
W celu uproszczenia projektu zmodyfikowano spos�b przesy�ania sygna��w video mi�dzy modu�ami. 
Nie przesy�amy ju� wszystkich sygna��w vblnk, hblnk, vsync, hsync poniewa� ma�o kt�ry modu�
korzysta z tych sygna��w. W wi�kszo�ci przypadk�w i tak s� po prostu przekazywane na wyj�cie. 
W zwi�zku z tym stworzyli�my magistral� video zawieraj�c� tylko sygna�y hcount, vcount, rgb i pclk
upakowane w jeden sygna�. U�atwia to dodawanie modu��w i upraszcza znacz�co kod.
S� dwa rodzaje magistrali. Standardowa i "extended". Magistrala extended zawiera dodatkowo sygna�y
vsync, hsync, vblnk i hblnk 
*/

`ifndef _video_bus_vh_
`define _video_bus_vh
`include "vesa_vga.vh"

// Definicje wymiar�w magistrali oraz lokalizacji poszczeg�lnych sygna��w w jej wn�trzu
`define BUS_WIDTH 34
`define BUS_WIDTH_EXT 38
`define BUS_HC 10:0
`define BUS_VC 21:11
`define BUS_RGB 33:22
`define BUS_PCLK 34

`define BUS_HB 38
`define BUS_VB 37
`define BUS_HS 36
`define BUS_VS 35

// Makra

// Tworzenie sygna��w wej�ciowych 
`define MAKE_IN_SIGNALS() \
    wire [10:0] hcount_in, vcount_in; \
    wire [11:0] rgb_in; \
    wire pclk;
    
// Tworzenie sygna��w wyj�ciowych    
`define MAKE_OUT_SIGNALS() \
    reg [10:0] hcount_out, vcount_out; \
    reg [11:0] rgb_out; 

// Tworzenie sygna��w wej�ciowych magistrali rozszerzonej
`define MAKE_IN_SIGNALS_EXT() \
    wire [10:0] hcount_in, vcount_in; \
    wire [11:0] rgb_in; \
    wire vsync_in, hsync_in; \
    wire vblnk_in, hblnk_in; \
    wire pclk;

// Tworzenie sygna��w wyj�ciowych magistrali rozszerzonej
`define MAKE_OUT_SIGNALS_EXT() \
    reg [10:0] hcount_out, vcount_out; \
    reg [11:0] rgb_out; \
    reg vsync_out, hsync_out; \
    reg vblnk_out, hblnk_out; 

// Przypisanie sygna��w wej�ciowych do sygna��w w magistrali wej�ciowej
`define MAKE_IN_BUS(INPUT) \
    assign hcount_in = INPUT[`BUS_HC]; \
    assign vcount_in = INPUT[`BUS_VC]; \
    assign rgb_in = INPUT[`BUS_RGB]; \
    assign pclk = INPUT[`BUS_PCLK]; 

// Przypisanie wygna��w w magistrali wyj�ciowej do sygna��w wyj�ciowych
`define MAKE_OUT_BUS(INPUT) \
    assign INPUT[`BUS_HC] = hcount_out; \
    assign INPUT[`BUS_VC] = vcount_out; \
    assign INPUT[`BUS_RGB] = rgb_out; \
    assign INPUT[`BUS_PCLK] = pclk; 

// Przypisanie sygna��w wej�ciowych do sygna��w w rozszerzonej magistrali wej�ciowej
`define MAKE_IN_BUSEXT(INPUT) \
    assign hcount_in = INPUT[`BUS_HC]; \
    assign vcount_in = INPUT[`BUS_VC]; \
    assign rgb_in = INPUT[`BUS_RGB]; \
    assign pclk = INPUT[`BUS_PCLK]; \
    assign vsync_in = INPUT[`BUS_VS]; \
    assign hsync_in = INPUT[`BUS_HS]; \
    assign vblnk_in = INPUT[`BUS_VB]; \
    assign hblnk_in = INPUT[`BUS_HB]; 

// Przypisanie wygna��w w rozszerzonej magistrali wyj�ciowej do sygna��w wyj�ciowych
`define MAKE_OUT_BUSEXT(INPUT) \
    assign INPUT[`BUS_HC] = hcount_out; \
    assign INPUT[`BUS_VC] = vcount_out; \
    assign INPUT[`BUS_RGB] = rgb_out; \
    assign INPUT[`BUS_PCLK] = pclk; \
    assign INPUT[`BUS_VS] = vsync_out; \
    assign INPUT[`BUS_HS] = hsync_out; \
    assign INPUT[`BUS_VB] = vblnk_out; \
    assign INPUT[`BUS_HB] = hblnk_out; 

// Makra do tworzenia brakuj�cych sygna��w synchronizacji na wypadek, gdyby kt�ry� modu� ich potrzebowa�.
`define MAKE_VSYNC(INPUT) wire vsync; sync_gen #(.WIDTH(11), .START(`VS_START), .END(`VS_END))  vsync_gen(.din(INPUT[`BUS_VC]), .sync_out(vsync));
`define MAKE_HSYNC(INPUT) wire hsync; sync_gen #(.WIDTH(11), .START(`HS_START), .END(`HS_END))  hsync_gen(.din(INPUT[`BUS_HC]), .sync_out(hsync));
`define MAKE_VBLNK(INPUT) wire vblnk; sync_gen #(.WIDTH(11), .START(`VB_START), .END(`VB_END))  vblnk_gen(.din(INPUT[`BUS_VC]), .sync_out(vblnk));
`define MAKE_HBLNK(INPUT) wire hblnk; sync_gen #(.WIDTH(11), .START(`HB_START), .END(`HB_END))  hblnk_gen(.din(INPUT[`BUS_HC]), .sync_out(hblnk));
    
`endif