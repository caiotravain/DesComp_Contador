LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity divisorGenerico_e_Interface is
   port(clk      :   in std_logic;
      habilitaLeitura : in std_logic;
      limpaLeitura : in std_logic;
		seletor : in std_logic;
      leituraUmSegundo :  out std_logic_vector (7 downto 0)

   );
end entity;

architecture interface of divisorGenerico_e_Interface is
  signal sinalUmSegundo : std_logic;
  signal saidaclk_reg1seg : std_logic;
  signal saidaclk_reg_rapido: std_logic;
  signal qualclock :std_logic;
begin

baseTempo: entity work.divisorGenerico
           generic map (divisor =>  25000000)   -- divide por 10.
           port map (clk => clk,saida_clk => saidaclk_reg1seg);
			  
baseTempo2: entity work.divisorGenerico
           generic map (divisor =>  5000)   -- divide por 10.
           port map (clk => clk,  saida_clk => saidaclk_reg_rapido);
			  
			  
						
registraUmSegundo: entity work.flipflop
   port map (DIN => '1', DOUT => sinalUmSegundo,
         ENABLE => '1', CLK => qualclock,
         RST => limpaLeitura);
			
qualclock<= saidaclk_reg1seg when not(seletor) else saidaclk_reg_rapido;

-- Faz o tristate de saida:
leituraUmSegundo <= "0000000" & sinalUmSegundo when habilitaLeitura = '1'  else "ZZZZZZZZ";

end architecture interface;