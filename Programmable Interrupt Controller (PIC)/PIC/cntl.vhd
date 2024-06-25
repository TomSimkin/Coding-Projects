library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity cntl is
port(
	cs_n: in std_logic;
	wr_n: in std_logic;
	rd_n: in std_logic;
	irq_pic: out std_logic;
	irr: in std_logic_vector(7 downto 0);
	mask: out std_logic_vector(7 downto 0);
	d: inout std_logic_vector(7 downto 0);
	mask_en: out std_logic;
	irr_en: out std_logic
);
end entity cntl;

architecture arc_cntl of cntl is
signal out_en, cmp: std_logic;

begin
	out_en <= rd_n NOR cs_n;	
	mask <= d;

	d <= irr when (out_en='1') else (others=>'Z'); 
	
	mask_en <= wr_n NOR cs_n;

	cmp <= '1' when (irr = 0) else '0';	
	irr_en <= cmp;

	irq_pic <= NOT cmp;	

end architecture arc_cntl;