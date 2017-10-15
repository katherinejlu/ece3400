// Quartus Prime Verilog Template
// Single Port ROM

module sin_rom
(
	input [7:0] addr,
	input clk, 
	output reg [7:0] q
);

	// Declare the ROM variable
	reg [7:0] sine[255:0];

	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file single_port_rom_init.txt.  Without this file,
	// this design will not compile.

	// See Verilog LRM 1364-2001 Section 17.2.8 for details on the
	// format of this file, or see the "Using $readmemb and $readmemh"
	// template later in this section.

	initial
	begin
		//$readmemh("sinetablehex.txt", rom);
		sine[0]<= 8'd127;
		sine[1]<= 8'd130;
		sine[2]<= 8'd133;
		sine[3]<= 8'd136;
		sine[4]<= 8'd139;
		sine[5]<= 8'd143;
		sine[6]<= 8'd146;
		sine[7]<= 8'd149;
		sine[8]<= 8'd152;
		sine[9]<= 8'd155;
		sine[10]<= 8'd158;
		sine[11]<= 8'd161;
		sine[12]<= 8'd164;
		sine[13]<= 8'd167;
		sine[14]<= 8'd170;
		sine[15]<= 8'd173;
		sine[16]<= 8'd176;
		sine[17]<= 8'd178;
		sine[18]<= 8'd181;
		sine[19]<= 8'd184;
		sine[20]<= 8'd187;
		sine[21]<= 8'd190;
		sine[22]<= 8'd192;
		sine[23]<= 8'd195;
		sine[24]<= 8'd198;
		sine[25]<= 8'd200;
		sine[26]<= 8'd203;
		sine[27]<= 8'd205;
		sine[28]<= 8'd208;
		sine[29]<= 8'd210;
		sine[30]<= 8'd212;
		sine[31]<= 8'd215;
		sine[32]<= 8'd217;
		sine[33]<= 8'd219;
		sine[34]<= 8'd221;
		sine[35]<= 8'd223;
		sine[36]<= 8'd225;
		sine[37]<= 8'd227;
		sine[38]<= 8'd229;
		sine[39]<= 8'd231;
		sine[40]<= 8'd233;
		sine[41]<= 8'd234;
		sine[42]<= 8'd236;
		sine[43]<= 8'd238;
		sine[44]<= 8'd239;
		sine[45]<= 8'd240;
		sine[46]<= 8'd242;
		sine[47]<= 8'd243;
		sine[48]<= 8'd244;
		sine[49]<= 8'd245;
		sine[50]<= 8'd247;
		sine[51]<= 8'd248;
		sine[52]<= 8'd249;
		sine[53]<= 8'd249;
		sine[54]<= 8'd250;
		sine[55]<= 8'd251;
		sine[56]<= 8'd252;
		sine[57]<= 8'd252;
		sine[58]<= 8'd253;
		sine[59]<= 8'd253;
		sine[60]<= 8'd253;
		sine[61]<= 8'd254;
		sine[62]<= 8'd254;
		sine[63]<= 8'd254;
		sine[64]<= 8'd254;
		sine[65]<= 8'd254;
		sine[66]<= 8'd254;
		sine[67]<= 8'd254;
		sine[68]<= 8'd253;
		sine[69]<= 8'd253;
		sine[70]<= 8'd253;
		sine[71]<= 8'd252;
		sine[72]<= 8'd252;
		sine[73]<= 8'd251;
		sine[74]<= 8'd250;
		sine[75]<= 8'd249;
		sine[76]<= 8'd249;
		sine[77]<= 8'd248;
		sine[78]<= 8'd247;
		sine[79]<= 8'd245;
		sine[80]<= 8'd244;
		sine[81]<= 8'd243;
		sine[82]<= 8'd242;
		sine[83]<= 8'd240;
		sine[84]<= 8'd239;
		sine[85]<= 8'd238;
		sine[86]<= 8'd236;
		sine[87]<= 8'd234;
		sine[88]<= 8'd233;
		sine[89]<= 8'd231;
		sine[90]<= 8'd229;
		sine[91]<= 8'd227;
		sine[92]<= 8'd225;
		sine[93]<= 8'd223;
		sine[94]<= 8'd221;
		sine[95]<= 8'd219;
		sine[96]<= 8'd217;
		sine[97]<= 8'd215;
		sine[98]<= 8'd212;
		sine[99]<= 8'd210;
		sine[100]<= 8'd208;
		sine[101]<= 8'd205;
		sine[102]<= 8'd203;
		sine[103]<= 8'd200;
		sine[104]<= 8'd198;
		sine[105]<= 8'd195;
		sine[106]<= 8'd192;
		sine[107]<= 8'd190;
		sine[108]<= 8'd187;
		sine[109]<= 8'd184;
		sine[110]<= 8'd181;
		sine[111]<= 8'd178;
		sine[112]<= 8'd176;
		sine[113]<= 8'd173;
		sine[114]<= 8'd170;
		sine[115]<= 8'd167;
		sine[116]<= 8'd164;
		sine[117]<= 8'd161;
		sine[118]<= 8'd158;
		sine[119]<= 8'd155;
		sine[120]<= 8'd152;
		sine[121]<= 8'd149;
		sine[122]<= 8'd146;
		sine[123]<= 8'd143;
		sine[124]<= 8'd139;
		sine[125]<= 8'd136;
		sine[126]<= 8'd133;
		sine[127]<= 8'd130;
		sine[128]<= 8'd127;
		sine[129]<= 8'd124;
		sine[130]<= 8'd121;
		sine[131]<= 8'd118;
		sine[132]<= 8'd115;
		sine[133]<= 8'd111;
		sine[134]<= 8'd108;
		sine[135]<= 8'd105;
		sine[136]<= 8'd102;
		sine[137]<= 8'd99;
		sine[138]<= 8'd96;
		sine[139]<= 8'd93;
		sine[140]<= 8'd90;
		sine[141]<= 8'd87;
		sine[142]<= 8'd84;
		sine[143]<= 8'd81;
		sine[144]<= 8'd78;
		sine[145]<= 8'd76;
		sine[146]<= 8'd73;
		sine[147]<= 8'd70;
		sine[148]<= 8'd67;
		sine[149]<= 8'd64;
		sine[150]<= 8'd62;
		sine[151]<= 8'd59;
		sine[152]<= 8'd56;
		sine[153]<= 8'd54;
		sine[154]<= 8'd51;
		sine[155]<= 8'd49;
		sine[156]<= 8'd46;
		sine[157]<= 8'd44;
		sine[158]<= 8'd42;
		sine[159]<= 8'd39;
		sine[160]<= 8'd37;
		sine[161]<= 8'd35;
		sine[162]<= 8'd33;
		sine[163]<= 8'd31;
		sine[164]<= 8'd29;
		sine[165]<= 8'd27;
		sine[166]<= 8'd25;
		sine[167]<= 8'd23;
		sine[168]<= 8'd21;
		sine[169]<= 8'd20;
		sine[170]<= 8'd18;
		sine[171]<= 8'd16;
		sine[172]<= 8'd15;
		sine[173]<= 8'd14;
		sine[174]<= 8'd12;
		sine[175]<= 8'd11;
		sine[176]<= 8'd10;
		sine[177]<= 8'd9;
		sine[178]<= 8'd7;
		sine[179]<= 8'd6;
		sine[180]<= 8'd5;
		sine[181]<= 8'd5;
		sine[182]<= 8'd4;
		sine[183]<= 8'd3;
		sine[184]<= 8'd2;
		sine[185]<= 8'd2;
		sine[186]<= 8'd1;
		sine[187]<= 8'd1;
		sine[188]<= 8'd1;
		sine[189]<= 8'd0;
		sine[190]<= 8'd0;
		sine[191]<= 8'd0;
		sine[192]<= 8'd0;
		sine[193]<= 8'd0;
		sine[194]<= 8'd0;
		sine[195]<= 8'd0;
		sine[196]<= 8'd1;
		sine[197]<= 8'd1;
		sine[198]<= 8'd1;
		sine[199]<= 8'd2;
		sine[200]<= 8'd2;
		sine[201]<= 8'd3;
		sine[202]<= 8'd4;
		sine[203]<= 8'd5;
		sine[204]<= 8'd5;
		sine[205]<= 8'd6;
		sine[206]<= 8'd7;
		sine[207]<= 8'd9;
		sine[208]<= 8'd10;
		sine[209]<= 8'd11;
		sine[210]<= 8'd12;
		sine[211]<= 8'd14;
		sine[212]<= 8'd15;
		sine[213]<= 8'd16;
		sine[214]<= 8'd18;
		sine[215]<= 8'd20;
		sine[216]<= 8'd21;
		sine[217]<= 8'd23;
		sine[218]<= 8'd25;
		sine[219]<= 8'd27;
		sine[220]<= 8'd29;
		sine[221]<= 8'd31;
		sine[222]<= 8'd33;
		sine[223]<= 8'd35;
		sine[224]<= 8'd37;
		sine[225]<= 8'd39;
		sine[226]<= 8'd42;
		sine[227]<= 8'd44;
		sine[228]<= 8'd46;
		sine[229]<= 8'd49;
		sine[230]<= 8'd51;
		sine[231]<= 8'd54;
		sine[232]<= 8'd56;
		sine[233]<= 8'd59;
		sine[234]<= 8'd62;
		sine[235]<= 8'd64;
		sine[236]<= 8'd67;
		sine[237]<= 8'd70;
		sine[238]<= 8'd73;
		sine[239]<= 8'd76;
		sine[240]<= 8'd78;
		sine[241]<= 8'd81;
		sine[242]<= 8'd84;
		sine[243]<= 8'd87;
		sine[244]<= 8'd90;
		sine[245]<= 8'd93;
		sine[246]<= 8'd96;
		sine[247]<= 8'd99;
		sine[248]<= 8'd102;
		sine[249]<= 8'd105;
		sine[250]<= 8'd108;
		sine[251]<= 8'd111;
		sine[252]<= 8'd115;
		sine[253]<= 8'd118;
		sine[254]<= 8'd121;
		sine[255]<= 8'd124;
	end

	always @ (posedge clk)
	begin
		q <= sine[addr];
	end

endmodule
