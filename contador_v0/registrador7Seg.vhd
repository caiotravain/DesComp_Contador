library ieee;
use ieee.std_logic_1164.all;

entity registrador7Seg is
  generic (
        larguraDados : natural := 4
  );
  port (
		CLK : in std_logic;
		WR : in std_logic;
		bloco : in std_logic;
		endereco : in std_logic_vector (5 downto 0);
		dados: in std_logic_vector (3 downto 0);
    selector: in std_logic;
    HEX0: out std_logic_vector (6 downto 0);
    HEX1: out std_logic_vector (6 downto 0);
    HEX2: out std_logic_vector (6 downto 0);
    HEX3: out std_logic_vector (6 downto 0);
    HEX4: out std_logic_vector (6 downto 0);
    HEX5: out std_logic_vector (6 downto 0)
  );
end entity;

architecture comportamento of registrador7Seg is
  signal habilitaHex0 : std_logic;
  signal habilitaHex1 : std_logic;
  signal habilitaHex2 : std_logic;
  signal habilitaHex3 : std_logic;
  signal habilitaHex4 : std_logic;
  signal habilitaHex5 : std_logic;
  
  signal OutHex0 : std_logic_vector (6 downto 0);
  signal OutHex1 : std_logic_vector (6 downto 0);
  signal OutHex2 : std_logic_vector (6 downto 0);
  signal OutHex3 : std_logic_vector (6 downto 0);
  signal OutHex4 : std_logic_vector (6 downto 0);
  signal OutHex5 : std_logic_vector (6 downto 0);
  
begin

  -- Sinais para habiltiar cada HEX
  habilitaHex0 <= (WR and bloco and endereco(0) and selector);
  habilitaHex1 <= (WR and bloco and endereco(1) and selector);
  habilitaHex2 <= (WR and bloco and endereco(2) and selector);
  habilitaHex3 <= (WR and bloco and endereco(3) and selector);
  habilitaHex4 <= (WR and bloco and endereco(4) and selector);
  habilitaHex5 <= (WR and bloco and endereco(5) and selector);


  SevenSeg0: entity work.display7Seg generic map (larguraDados => larguraDados) port map (
    CLK => CLK,
    data => dados,
    enable => habilitaHex0,
    saida => OutHex0
  );

  SevenSeg1: entity work.display7Seg generic map (larguraDados => larguraDados) port map (
    CLK => CLK,
    data => dados,
    enable => habilitaHex1,
    saida => OutHex1
  );

  SevenSeg2: entity work.display7Seg generic map (larguraDados => larguraDados) port map (
    CLK => CLK,
    data => dados,
    enable => habilitaHex2,
    saida => OutHex2
  );

  SevenSeg3: entity work.display7Seg generic map (larguraDados => larguraDados) port map (
    CLK => CLK,
    data => dados,
    enable => habilitaHex3,
    saida => OutHex3
  );

  SevenSeg4: entity work.display7Seg generic map (larguraDados => larguraDados) port map (
    CLK => CLK,
    data => dados,
    enable => habilitaHex4,
    saida => OutHex4
  );

  SevenSeg5: entity work.display7Seg generic map (larguraDados => larguraDados) port map (
    CLK => CLK,
    data => dados,
    enable => habilitaHex5,
    saida => OutHex5
  );

-- Sinais
HEX0 <= OutHex0;
HEX1 <= OutHex1;
HEX2 <= OutHex2;
HEX3 <= OutHex3;
HEX4 <= OutHex4;
HEX5 <= OutHex5;

end architecture;