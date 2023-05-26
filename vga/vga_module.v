module vga_module #(
	parameter Tvw       = 12'd6   ,   //VSYNC Pulse Width
	parameter Tvbp      = 12'd29  ,   //VSYNC Back Porch
	parameter Tvfp      = 12'd3   ,   //Vertical Front Porch
	parameter Tvdw      = 12'd768 ,   //Vertical valid data width
	parameter Thw       = 12'd136 ,   //HSYNC Pulse Width        
	parameter Thbp      = 12'd160 ,   //HSYNC Back Porch         
	parameter Thfp      = 12'd24  ,   //Horizontal Front Porch     
	parameter Thdw      = 12'd1024,   //Horizontal valid data width
	parameter Vsync_pol = 1'b1    ,   //VSync Polarity, 0 = Active High, 1 = Active Low
	parameter Hsync_pol = 1'b1        //HSync Polarity, 0 = Active High, 1 = Active Low
) (
	/*****************************************************
	** Input Signal Define                              **
	*****************************************************/
	input  wire             clk_65         ,
	input  wire             rst         ,
	input wire[63:0] current_state,
	/*****************************************************
	** Output Signal Define                             **
	*****************************************************/ 
	output wire             vga_vs      ,
	output wire             vga_hs      ,
	output reg [03:0]      vga_r       ,
	output reg [03:0]      vga_g       ,
	output reg [03:0]      vga_b       
);

	/*****************************************************
	** Parameter Definition                             **
	*****************************************************/
	localparam Tvp       = Tvw + Tvbp + Tvfp + Tvdw;//VSYNC Period   
	localparam Thp       = Thw + Thbp + Thfp + Thdw;//HSYNC Period     
	localparam VSYNC_ACT = ~Vsync_pol;
	localparam HSYNC_ACT = ~Hsync_pol;

	/*****************************************************
	** Offset Definition                                **
	*****************************************************/

	localparam block_size = 12'd150;

	localparam h_first_block_offset = 12'd150;
	localparam h_second_block_offset = 12'd330;
	localparam h_third_block_offset = 12'd510;
	localparam h_last_block_offset = 12'd690;

	localparam v_first_block_offset = 12'd30;
	localparam v_second_block_offset = 12'd210;
	localparam v_third_block_offset = 12'd390;
	localparam v_last_block_offset = 12'd570;

	/*****************************************************
	** Reg Definition                                  **
	*****************************************************/
	reg[3:0] pat_sel_buf ;
	reg[11:0] hcnt;
	reg[11:0] vcnt;
	reg[11:0] pat_hcnt;
	reg[11:0] pat_vcnt;
	reg pat_vs;
	reg pat_hs;
	reg pat_de;
	reg[3:0] pat_r;
	reg[3:0] pat_g;
	reg[3:0] pat_b;


	/*****************************************************
	** block vga definition                            **
	*****************************************************/

	wire[11:0] vga_block_15;
	wire[11:0] vga_block_14;
	wire[11:0] vga_block_13;
	wire[11:0] vga_block_12;
	wire[11:0] vga_block_11;
	wire[11:0] vga_block_10;
	wire[11:0] vga_block_9;
	wire[11:0] vga_block_8;
	wire[11:0] vga_block_7;
	wire[11:0] vga_block_6;
	wire[11:0] vga_block_5;
	wire[11:0] vga_block_4;
	wire[11:0] vga_block_3;
	wire[11:0] vga_block_2;
	wire[11:0] vga_block_1;
	wire[11:0] vga_block_0;

	block_vga_module block_15 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[63:60]),
		.h_cnt(pat_hcnt - h_first_block_offset),
		.v_cnt(pat_vcnt - v_first_block_offset),
		.vga_data(vga_block_15)
	);

	block_vga_module block_14 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[59:56]),
		.h_cnt(pat_hcnt - h_second_block_offset),
		.v_cnt(pat_vcnt - v_first_block_offset),
		.vga_data(vga_block_14)
	);

	block_vga_module block_13 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[55:52]),
		.h_cnt(pat_hcnt - h_third_block_offset),
		.v_cnt(pat_vcnt - v_first_block_offset),
		.vga_data(vga_block_13)
	);

	block_vga_module block_12 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[51:48]),
		.h_cnt(pat_hcnt - h_last_block_offset),
		.v_cnt(pat_vcnt - v_first_block_offset),
		.vga_data(vga_block_12)
	);

	block_vga_module block_11 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[47:44]),
		.h_cnt(pat_hcnt - h_first_block_offset),
		.v_cnt(pat_vcnt - v_second_block_offset),
		.vga_data(vga_block_11)
	);

	block_vga_module block_10 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[43:40]),
		.h_cnt(pat_hcnt - h_second_block_offset),
		.v_cnt(pat_vcnt - v_second_block_offset),
		.vga_data(vga_block_10)
	);

	block_vga_module block_9 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[39:36]),
		.h_cnt(pat_hcnt - h_third_block_offset),
		.v_cnt(pat_vcnt - v_second_block_offset),
		.vga_data(vga_block_9)
	);

	block_vga_module block_8 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[35:32]),
		.h_cnt(pat_hcnt - h_last_block_offset),
		.v_cnt(pat_vcnt - v_second_block_offset),
		.vga_data(vga_block_8)
	);

	block_vga_module block_7 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[31:28]),
		.h_cnt(pat_hcnt - h_first_block_offset),
		.v_cnt(pat_vcnt - v_third_block_offset),
		.vga_data(vga_block_7)
	);
	
	block_vga_module block_6 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[27:24]),
		.h_cnt(pat_hcnt - h_second_block_offset),
		.v_cnt(pat_vcnt - v_third_block_offset),
		.vga_data(vga_block_6)
	);

	block_vga_module block_5 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[23:20]),
		.h_cnt(pat_hcnt - h_third_block_offset),
		.v_cnt(pat_vcnt - v_third_block_offset),
		.vga_data(vga_block_5)
	);

	block_vga_module block_4 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[19:16]),
		.h_cnt(pat_hcnt - h_last_block_offset),
		.v_cnt(pat_vcnt - v_third_block_offset),
		.vga_data(vga_block_4)
	);

	block_vga_module block_3 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[15:12]),
		.h_cnt(pat_hcnt - h_first_block_offset),
		.v_cnt(pat_vcnt - v_last_block_offset),
		.vga_data(vga_block_3)
	);

	block_vga_module block_2 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[11:8]),
		.h_cnt(pat_hcnt - h_second_block_offset),
		.v_cnt(pat_vcnt - v_last_block_offset),
		.vga_data(vga_block_2)
	);

	block_vga_module block_1 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[7:4]),
		.h_cnt(pat_hcnt - h_third_block_offset),
		.v_cnt(pat_vcnt - v_last_block_offset),
		.vga_data(vga_block_1)
	);

	block_vga_module block_0 (
		.clk(clk_65),
		.rst(rst),
		.state(current_state[3:0]),
		.h_cnt(pat_hcnt - h_last_block_offset),
		.v_cnt(pat_vcnt - v_last_block_offset),
		.vga_data(vga_block_0)
	);

	/*****************************************************
	** HSYNC Period/VSYNC Period Count                  **
	*****************************************************/
	always @ (posedge clk_65 ) begin
		if (!rst) begin
			hcnt <= 12'd0;
			vcnt <= 12'd0;
		end else begin
			/* HSYNC period */
			if (hcnt == (Thp - 1)) begin
				hcnt <= 12'd0;
			end else begin
				hcnt <= hcnt + 1'b1;
			end
			/* VSYNC period */
			if (hcnt == (Thp - 1)) begin
				if (vcnt == (Tvp - 1)) begin
					vcnt <= 12'd0;
				end else begin
					vcnt <= vcnt + 1'b1;
				end
			end
		end
	end

	// VSYNC signal generate
	always @ (posedge clk_65 ) begin
		if (!rst) begin
			pat_vs <= VSYNC_ACT;
		end else begin
			if (hcnt == (Thp - 1)) begin
				if (vcnt == (Tvw - 1)) begin
					pat_vs <= ~VSYNC_ACT;
				end else if (vcnt == (Tvp - 1)) begin
					pat_vs <= VSYNC_ACT;
				end
			end
		end
	end

	// Hsync signal generate
	always @ (posedge clk_65 ) begin
		if (!rst) begin
			pat_hs <= HSYNC_ACT;
		end else begin
			if (hcnt == (Thw - 1)) begin
				pat_hs <= ~HSYNC_ACT;
			end else if (hcnt == (Thp - 1)) begin
				pat_hs <= HSYNC_ACT;
			end
		end
	end

	// hsync / vsync data enable signal generate
	always @ (posedge clk_65 ) begin
		if (!rst) begin
			pat_de <= 1'b0;
		end else begin
			if ((vcnt >= (Tvw + Tvbp)) && (vcnt <= (Tvp - Tvfp - 1))) begin
				if (hcnt == (Thw + Thbp - 1)) begin
					pat_de <= 1'b1;
				end else if (hcnt == (Thp - Thfp - 1)) begin
					pat_de <= 1'b0;
				end
			end
		end
	end

	// horizontal valid pixel count
	always @(posedge clk_65 ) begin
		if (!rst) begin
			pat_hcnt <= 'd0;
		end else begin
			if (pat_de) begin
				pat_hcnt <= pat_hcnt + 'b1;
			end else begin
				pat_hcnt <= 'd0;
			end
		end
	end

	// vertical valid pixel count
	always @ (posedge clk_65 ) begin
		if (!rst) begin
			pat_vcnt <= 'd0;
		end else begin
			if ((vcnt >= (Tvw + Tvbp)) && (vcnt <= (Tvp - Tvfp - 1))) begin
				if (hcnt == (Thp - 1)) begin
					pat_vcnt <= pat_vcnt + 'd1;
				end
			end else begin
				pat_vcnt <= 'd0;
			end
		end
	end
	always @ (posedge clk_65 ) begin
		if (!rst) begin
			vga_r <= 'd0;
			vga_g <= 'd0;
			vga_b <= 'd0;
		end else if (pat_vcnt >= v_first_block_offset && pat_vcnt < v_first_block_offset + block_size) begin
			if (pat_hcnt >= h_first_block_offset && pat_hcnt < h_first_block_offset + block_size) begin
				vga_r <= vga_block_15[11:8];
				vga_g <= vga_block_15[7:4];
				vga_b <= vga_block_15[3:0];
			end else if (pat_hcnt >= h_second_block_offset && pat_hcnt < h_second_block_offset + block_size) begin
				vga_r <= vga_block_14[11:8];
				vga_g <= vga_block_14[7:4];
				vga_b <= vga_block_14[3:0];
			end else if (pat_hcnt >= h_third_block_offset && pat_hcnt < h_third_block_offset + block_size) begin
				vga_r <= vga_block_13[11:8];
				vga_g <= vga_block_13[7:4];
				vga_b <= vga_block_13[3:0];
			end else if (pat_hcnt >= h_last_block_offset && pat_hcnt < h_last_block_offset + block_size) begin
				vga_r <= vga_block_12[11:8];
				vga_g <= vga_block_12[7:4];
				vga_b <= vga_block_12[3:0];
			end else begin
				vga_r <= 'd0;
				vga_g <= 'd0;
				vga_b <= 'd0;
			end
		end else if (pat_vcnt >= v_second_block_offset && pat_vcnt < v_second_block_offset + block_size) begin
			if (pat_hcnt >= h_first_block_offset && pat_hcnt < h_first_block_offset + block_size) begin
				vga_r <= vga_block_11[11:8];
				vga_g <= vga_block_11[7:4];
				vga_b <= vga_block_11[3:0];
			end else if (pat_hcnt >= h_second_block_offset && pat_hcnt < h_second_block_offset + block_size) begin
				vga_r <= vga_block_10[11:8];
				vga_g <= vga_block_10[7:4];
				vga_b <= vga_block_10[3:0];
			end else if (pat_hcnt >= h_third_block_offset && pat_hcnt < h_third_block_offset + block_size) begin
				vga_r <= vga_block_9[11:8];
				vga_g <= vga_block_9[7:4];
				vga_b <= vga_block_9[3:0];
			end else if (pat_hcnt >= h_last_block_offset && pat_hcnt < h_last_block_offset + block_size) begin
				vga_r <= vga_block_8[11:8];
				vga_g <= vga_block_8[7:4];
				vga_b <= vga_block_8[3:0];
			end else begin
				vga_r <= 'd0;
				vga_g <= 'd0;
				vga_b <= 'd0;
			end
		end else if (pat_vcnt >= v_third_block_offset && pat_vcnt < v_third_block_offset + block_size) begin
			if (pat_hcnt >= h_first_block_offset && pat_hcnt < h_first_block_offset + block_size) begin
				vga_r <= vga_block_7[11:8];
				vga_g <= vga_block_7[7:4];
				vga_b <= vga_block_7[3:0];
			end else if (pat_hcnt >= h_second_block_offset && pat_hcnt < h_second_block_offset + block_size) begin
				vga_r <= vga_block_6[11:8];
				vga_g <= vga_block_6[7:4];
				vga_b <= vga_block_6[3:0];
			end else if (pat_hcnt >= h_third_block_offset && pat_hcnt < h_third_block_offset + block_size) begin
				vga_r <= vga_block_5[11:8];
				vga_g <= vga_block_5[7:4];
				vga_b <= vga_block_5[3:0];
			end else if (pat_hcnt >= h_last_block_offset + block_size && pat_hcnt < h_last_block_offset + block_size) begin
				vga_r <= vga_block_4[11:8];
				vga_g <= vga_block_4[7:4];
				vga_b <= vga_block_4[3:0];
			end else begin
				vga_r <= 'd0;
				vga_g <= 'd0;
				vga_b <= 'd0;
			end
		end else if (pat_vcnt >= v_last_block_offset && pat_vcnt < v_last_block_offset + block_size) begin
			if (pat_hcnt >= h_first_block_offset && pat_hcnt < h_first_block_offset + block_size) begin
				vga_r <= vga_block_3[11:8];
				vga_g <= vga_block_3[7:4];
				vga_b <= vga_block_3[3:0];
			end else if (pat_hcnt >= h_second_block_offset && pat_hcnt < h_second_block_offset + block_size) begin
				vga_r <= vga_block_2[11:8];
				vga_g <= vga_block_2[7:4];
				vga_b <= vga_block_2[3:0];
			end else if (pat_hcnt >= h_third_block_offset && pat_hcnt < h_third_block_offset + block_size) begin
				vga_r <= vga_block_1[11:8];
				vga_g <= vga_block_1[7:4];
				vga_b <= vga_block_1[3:0];
			end else if (pat_hcnt >= h_last_block_offset && pat_hcnt < h_last_block_offset + block_size) begin
				vga_r <= vga_block_0[11:8];
				vga_g <= vga_block_0[7:4];
				vga_b <= vga_block_0[3:0];
			end else begin
				vga_r <= 'd0;
				vga_g <= 'd0;
				vga_b <= 'd0;
			end
		end else begin
			vga_r <= 'd0;
			vga_g <= 'd0;
			vga_b <= 'd0;
		end
	end

	assign vga_vs  = pat_vs;
	assign vga_hs  = pat_hs;

endmodule