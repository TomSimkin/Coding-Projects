library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-------------------------------
entity PIC_tb is
end entity PIC_tb;

architecture arc_PIC_tb of PIC_tb is
component PIC is
	port
	(
	   clk : in    std_logic;
	   rst_n : in    std_logic;
	   cs_n  : in    std_logic;
	   rd_n  : in    std_logic;
	   wr_n  : in    std_logic;
	   inta_n: in    std_logic;
	   irq : in    std_logic_vector(7 downto 0);
	   d   : inout std_logic_vector(7 downto 0);
	   irq_pic : out   std_logic
	);
end component PIC;
signal clk : std_logic:='0';
signal rst_n : std_logic:='0';
signal cs_n  : std_logic:='1';
signal rd_n  : std_logic:='1';
signal wr_n  : std_logic:='1';
signal inta_n: std_logic:='1';
signal irq : std_logic_vector(7 downto 0):=(others =>'1');
signal d   : std_logic_vector(7 downto 0):=(others =>'Z');
signal irq_pic : std_logic;
signal flag: boolean:=false;
begin
   clk<= not clk after 5 ns;
   rst_n<='1' after 13 ns;

   dut: PIC
   port map
   (
	clk => clk,
	rst_n => rst_n,
	cs_n  => cs_n,
	rd_n  => rd_n,
	wr_n  => wr_n,
	inta_n=> inta_n,
	irq => irq,
	d   => d,
	irq_pic => irq_pic
   );
   
   process is
   begin
     l1: loop
     l2: for i in 0 to 4 loop
	    assert(not flag)
			report "SECOND LOOP"
		severity NOTE;
        if (not flag) then		
			wait until irq_pic='0';
		end if;	
		wait until rising_edge(clk);
		assert(not flag)
			report "SECOND READ CYCLE"
		severity NOTE;	
		cs_n<='0';
		rd_n<='0';
		d<=(others =>'Z');
		wait for 50 ns;
		wait until rising_edge(clk);
		inta_n<='0';
		cs_n<='1';
		rd_n<='1';
		wait until rising_edge(clk);
		inta_n<='1';
	    exit l1 when (flag);
	  end loop l2;
	  wait for 100 ns;
	  wait until rising_edge(clk);
	  if(not flag) then
		cs_n<='0';
		wr_n<='0';
		d<=x"0f";
		wait until rising_edge(clk);
		cs_n<='1';
		wr_n<='1';
		wait until rising_edge(clk);
	  end if;	
	  flag<=true;
	  wait for 1 ns;
	  end loop l1;
	  wait;  
   end process;	
   irq<= (not irq(0) & irq(7 downto 1)) when rising_edge(inta_n);
end architecture arc_PIC_tb;