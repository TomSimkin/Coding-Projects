library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity maskreg is
port(
	msk: in std_logic_vector(7 downto 0);
	en_n: in std_logic;
	rst_n: in std_logic;
	clk: in std_logic;
	mask: out std_logic_vector(7 downto 0)
);
end entity maskreg;

architecture arc_maskreg of maskreg is
signal din: std_logic_vector(7 downto 0);

begin
	process (clk, rst_n) is 
	begin
		if (rst_n = '1') then 
			din <= (others => '0');
		elsif rising_edge(clk) then
			if en_n = '1' then
				mask <= din;
			end if;
		end if;
	end process;
	
end architecture arc_maskreg;