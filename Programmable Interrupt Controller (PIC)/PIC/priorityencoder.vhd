library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity priorityencoder is 
port(
	irq: in std_logic_vector(7 downto 0);
	mask: in std_logic_vector(7 downto 0);
	prio: out std_logic_vector(7 downto 0)
);
end entity priorityencoder;

architecture arc_priorityencoder of priorityencoder is
signal post_msk	: std_logic_vector(7 downto 0);

begin
	post_msk 	<= mask AND irq;

	prio(7) 	<= post_msk(7);
	prio(6) 	<= post_msk(6) AND NOT post_msk(7);
	prio(5) 	<= post_msk(5) AND NOT post_msk(6) AND NOT post_msk(7);
	prio(4) 	<= post_msk(4) AND NOT post_msk(5) AND NOT post_msk(6) AND NOT post_msk(7);
	prio(3) 	<= post_msk(3) AND NOT post_msk(4) AND NOT post_msk(5) AND NOT post_msk(6) AND NOT post_msk(7);
	prio(2) 	<= post_msk(2) AND NOT post_msk(3) AND NOT post_msk(4) AND NOT post_msk(5) AND NOT post_msk(6) AND NOT post_msk(7);
	prio(1) 	<= post_msk(1) AND NOT post_msk(2) AND NOT post_msk(3) AND NOT post_msk(4) AND NOT post_msk(5) AND NOT post_msk(6) AND NOT post_msk(7);
	prio(0) 	<= post_msk(0) AND NOT post_msk(1) AND NOT post_msk(2) AND NOT post_msk(3) AND NOT post_msk(4) AND NOT post_msk(5) AND NOT post_msk(6) AND NOT post_msk(7);
	
end architecture arc_priorityencoder;
