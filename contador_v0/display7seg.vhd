library IEEE;
use ieee.std_logic_1164.all;

entity display7Seg is
	 generic(
		larguraDados : natural := 4
	 );
    port
    (
		  CLK : in std_logic;
      data : in  std_logic_vector(3 downto 0);
		  enable : in std_logic;
		  liga : in std_logic;
      saida : out std_logic_vector(6 downto 0) 
    );
end entity;

architecture comportamento of display7Seg is
  signal outRegister: std_logic_vector (3 downto 0);
  signal outRegister7Seg: std_logic_vector (6 downto 0);
  signal out_liga: std_logic;
  
begin

REG: entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (DIN => data, DOUT => outRegister, ENABLE => enable, CLK => CLK, RST => '0');
			 
REG_liga: entity work.FlipFlop
          port map (DIN => data(0), DOUT => out_liga, ENABLE => liga, CLK => CLK, RST => '0');

DECODER7SEG:  entity work.conversorHex7Seg
        port map(dadoHex => outRegister,
                 apaga =>  out_liga,
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => outRegister7Seg);
					  
saida <= outRegister7Seg;

end architecture;