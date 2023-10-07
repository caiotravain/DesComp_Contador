library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hexComponent is
  generic   (
	 larguraDados : natural := 4
  );
  port   (
	  CLK: in std_logic;
	  wr: in std_logic;
	  Data_OUT: in std_logic_vector(larguraDados -1 downto 0);
	  dec_bloco: in std_logic;
	  dec_ende: in std_logic;
	  habilita_hex: in std_logic;
	  saida_7seg: out std_logic_vector(6 downto 0)
  );
end entity;


architecture arch_name of hexComponent is
	signal saida_REG: std_logic_vector(larguraDados -1 downto 0); 
	signal saida7seg: std_logic_vector(6 downto 0); 
begin

REG: entity work.registradorGenerico generic map (larguraDados => larguraDados)
   	  port map (CLK => CLK, DIN => Data_OUT, ENABLE => (habilita_hex and wr and dec_bloco and dec_ende),  RST => '0', DOUT => saida_REG);
		
converSeg: entity work.conversorHex7Seg
		  port map(dadoHex => saida_REG,
				  apaga => '0',
				  negativo => '0',
				  overflow => '0',
				  saida7seg => saida7seg);

saida_7seg <= saida7seg;
		
end architecture;