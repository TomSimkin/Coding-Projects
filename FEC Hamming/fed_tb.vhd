library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;

entity fed_tb is
end entity fed_tb;

architecture arc_fed_tb of fed_tb is
   signal   clk          : std_logic:= '0';
   signal   rst          : std_logic:= '0';
   signal   en           : std_logic:= '1';
   signal   val          : std_logic;
   signal   val_out      : std_logic;
   signal   data         : std_logic_vector(7 downto 0):= (others => '0');
   signal   dout         : std_logic_vector(7 downto 0);
   signal   codeword     : std_logic_vector(11 downto 0);
   signal   data_to_recv : std_logic_vector(11 downto 0):= (others => '0');
begin
   DUT1 : entity work.fed_hamming
      port map (
         clk      => clk,               -- [in  std_logic]
         rst      => rst,               -- [in  std_logic]
         enable       => en,                -- [in  std_logic]
         data_in     => data,              -- [in  std_logic_vector((data_width-1) downto 0)]
         valid      => val,               -- [out std_logic]
         data_out => codeword);         -- [out std_logic_vector((get_codeword_size(data_width)-1) downto 0)]

   DUT2 : entity work.fed_hamming
      port map(
         clk      => clk,               -- [in  std_logic]
         rst      => rst,               -- [in  std_logic]
         enable       => val,               -- [in  std_logic]              
         data_in_d => data_to_recv,
         data_out_d     => dout,              -- [out std_logic_vector((data_width-1) downto 0)]
         valid_d      => val_out);          -- [out std_logic]

   clk <= not clk    after 10 ns;
   rst <= '1' after 5 ns;
   
   process is
      variable seed1        : integer                                  := 100;
      variable seed2        : integer                                  := 105;
      variable rand_v       : real;
      variable bit_position : integer range data_to_recv'high downto 0 := 0;
   begin
      wait until rising_edge(rst);
      data_to_recv <= codeword;
      wait for 10 ns;
      data         <= x"ac";
      wait for 1 ns;
      data_to_recv <= codeword;
      wait until rising_edge(clk);
      data         <= x"31";
      wait for 1 ns;
      data_to_recv <= codeword;
      wait until rising_edge(clk);
      data         <= x"12";
      wait for 1 ns;
      data_to_recv <= codeword;
      wait until rising_edge(clk);
      -- 10 packets genaration with error in each one
      for i in 0 to 9 loop
         data                       <= data + x"7";
         wait for 1 ns;                  -- wait needs to data update
         uniform(seed1, seed2, rand_v);  -- from math_real library 
         bit_position               := integer(real(codeword'high) * rand_v);
         data_to_recv               <= codeword;
         data_to_recv(bit_position) <= not codeword(bit_position);
         wait until rising_edge(clk);
         seed1                      := seed1 + 1;
         seed2                      := seed2 + 1;
      end loop;
      wait;
   end process;
end architecture arc_fec_tb;