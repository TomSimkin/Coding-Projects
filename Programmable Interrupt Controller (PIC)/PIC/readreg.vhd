library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity readreg is
port(
	prio: in std_logic_vector(7 downto 0);
	read_en: in std_logic;
	rst_n: in std_logic;
	clk: in std_logic;
	irr: out std_logic_vector(7 downto 0)
);
end entity readreg;

architecture arc_readreg of readreg is
signal din: std_logic_vector(7 downto 0);

begin
	process (clk, rst_n) is 
	begin
		if (rst_n = '1') then 
			din <= (others => '0');
		elsif rising_edge(clk) then
			if read_en = '1' then
				irr <= din;
			end if;
		end if;
	end process;
	
	irr <= din;
	
end architecture arc_readreg;