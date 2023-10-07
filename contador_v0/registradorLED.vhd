library ieee;
use ieee.std_logic_1164.all;

entity registradorLED is
  generic (
        larguraDados : natural := 8
  );
  port ( WR : in std_logic;
			bloco : in std_logic;
			endereco : in std_logic_vector (2 downto 0);
			dados: in std_logic_vector (7 downto 0);
      saida : out std_logic_vector(9 downto 0);
			CLK : in std_logic;
      selector : in std_logic
  );
end entity;

architecture comportamento of registradorLED is
  signal habilitaLEDR9 : std_logic;
  signal habilitaLEDR8 : std_logic;
  signal habilitaLEDR0a7 : std_logic;
  
  signal ledr9: std_logic;
  signal ledr8: std_logic;
  signal ledr0a7: std_logic_vector(7 downto 0);
  
begin
habilitaLEDR9 <= (WR and bloco and endereco(2) and (not selector));
habilitaLEDR8 <= (WR and bloco and endereco(1) and (not selector));
habilitaLEDR0a7 <= (WR and bloco and endereco(0) and (not selector));

REGLED9 : entity work.flipFlop
          port map (DIN => dados(0), DOUT => ledr9, ENABLE => habilitaLEDR9, CLK => CLK, RST => '0');

REGLED8 : entity work.flipFlop
          port map (DIN => dados(0), DOUT => ledr8, ENABLE => habilitaLEDR8, CLK => CLK, RST => '0');

REGLED0a7: entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (DIN => dados, DOUT => ledr0a7, ENABLE => habilitaLEDR0a7, CLK => CLK, RST => '0'); 		 

saida(9) <= ledr9;
saida(8) <= ledr8;
saida(7 downto 0) <= ledr0a7;
			 
end architecture;