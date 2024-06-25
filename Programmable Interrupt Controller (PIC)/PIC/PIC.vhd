library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity PIC is 
port(
	cs_n: in std_logic;
	wr_n: in std_logic;
	rd_n: in std_logic;
	clk: in std_logic;
	rst_n: in std_logic;
	inta_n: in std_logic;
	irq: in std_logic_vector(7 downto 0);
	d: inout std_logic_vector(7 downto 0);
	irq_pic: out std_logic
);
end entity PIC;

architecture arc_PIC of PIC is
	component ctrl is
		port(
			cs_n: in std_logic;
			wr_n: in std_logic;
			rd_n: in std_logic;
			irq_pic: out std_logic;
			irr: in std_logic_vector(7 downto 0);
			mask_ctrl: out std_logic_vector(7 downto 0);
			d: inout std_logic_vector(7 downto 0);
			mask_en: out std_logic;
			irr_en: out std_logic
		);
	end component ctrl;
		
	component mask_reg is
		port(
			msk: in std_logic_vector(7 downto 0);
			mask_en: in std_logic;
			rst_n: in std_logic;
			clk: in std_logic;
			mask: out std_logic_vector(7 downto 0)
		);
	end component mask_reg;
			
	component read_reg is
		port(
			prio: in std_logic_vector(7 downto 0);
			read_en: in std_logic;
			rst_n: in std_logic;
			clk: in std_logic;
			irr: out std_logic_vector(7 downto 0)
		);
	end component read_reg;
		
	component priority_encoder is
		port(
			irq: in std_logic_vector(7 downto 0);
			mask_enc: in std_logic_vector(7 downto 0);
			prio: out std_logic_vector(7 downto 0)
		);
	end component priority_encoder;

-----------------------------------------------------

signal sig_prio, sig_ctrl_out_msk, sig_mreg_out, sig_intr_req: std_logic_vector(d'range);
signal sig_mreg_en_n, sig_rreg_en_n, sig_rreg_rst_n: std_logic;

begin

	sig_rreg_rst_n <= inta_n AND rst_n;
	
	label_ctrl: ctrl
	port map(
		wr_n => wr_n,
		rd_n => rd_n,
		cs_n => cs_n,
		irq_pic => irq_pic,
		
		irr_en => sig_rreg_en_n,
		mask_en => sig_mreg_en_n,
		
		d => d,
		mask_ctrl => sig_ctrl_out_msk,
		irr => sig_intr_req
	);

	label_mask: mask_reg
	port map(
		rst_n => rst_n,
		clk => clk,
		
		msk => sig_ctrl_out_msk,
		mask_en => sig_mreg_en_n,
		mask => sig_mreg_out
	);
	
	label_read: read_reg
	port map(
		rst_n => sig_rreg_en_n,
		clk => clk,
		
		prio => sig_prio,
		read_en => sig_rreg_en_n,
		irr => sig_intr_req
	);
	
	label_p_encoder: priority_encoder
	port map(
		irq => irq,
		mask_enc => sig_mreg_out,
		prio => sig_prio
	);
		
end architecture arc_PIC;