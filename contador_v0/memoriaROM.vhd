library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 13;
          addrWidth: natural := 9
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

 
  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ  : std_logic_vector(3 downto 0) := "0111";
  constant CEQ  : std_logic_vector(3 downto 0) := "1000";
  constant JSR  : std_logic_vector(3 downto 0) := "1001";
  constant RET  : std_logic_vector(3 downto 0) := "1010";
   constant OP_AND:std_logic_vector(3 downto 0) := "1011";


  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
-- RESET:
tmp(1) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(2) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(3) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando segundos
tmp(4) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(5) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(6) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(7) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(8) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(9) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(10) := x"5" & "00" & '0'& '1' & x"20";	-- STA @288 	# Limpando endereço do HEX0
tmp(11) := x"5" & "00" & '0'& '1' & x"21";	-- STA @289 	# Limpando endereço do HEX1
tmp(12) := x"5" & "00" & '0'& '1' & x"22";	-- STA @290 	# Limpando endereço do HEX2
tmp(13) := x"5" & "00" & '0'& '1' & x"23";	-- STA @291 	# Limpando endereço do HEX3
tmp(14) := x"5" & "00" & '0'& '1' & x"24";	-- STA @292 	# Limpando endereço do HEX4
tmp(15) := x"5" & "00" & '0'& '1' & x"25";	-- STA @293 	# Limpando endereço do HEX5
tmp(16) := x"4" & "00" & '0'& '0' & x"02";	-- LDI $2 	# Carregando 2 no acumulador
tmp(17) := x"5" & "00" & '0'& '0' & x"34";	-- STA @52 	# Carregando 2 na posição 52
tmp(18) := x"4" & "00" & '0'& '0' & x"03";	-- LDI $3 	# Carregando 4 no acumulador
tmp(19) := x"5" & "00" & '0'& '0' & x"35";	-- STA @53 	# Carregando 4 na posição 53
tmp(20) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5 	# Carregando 5 no acumulador
tmp(21) := x"5" & "00" & '0'& '0' & x"37";	-- STA @55 	# Carregando 5 na posição 55
tmp(22) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9 	# Carregando 9 no acumulador
tmp(23) := x"5" & "00" & '0'& '0' & x"3B";	-- STA @59 	# Carregando 9 na posição 59
tmp(24) := x"4" & "00" & '0'& '0' & x"0A";	-- LDI $10 	# Carregando 10 no acumulador
tmp(25) := x"5" & "00" & '0'& '0' & x"3C";	-- STA @60 	# Carergando 10 na posição 60
tmp(26) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1 	# Carregando 1 no acumulador
tmp(27) := x"5" & "00" & '0'& '0' & x"33";	-- STA @51 	# Carregando 1 na posição 51
tmp(28) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9
tmp(29) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40 	# Limpando endereço de temp 1
tmp(30) := x"5" & "00" & '0'& '0' & x"0A";	-- STA @10 	# Limite das unidades
tmp(31) := x"5" & "00" & '0'& '0' & x"0C";	-- STA @12 	# Limite das centenas
tmp(32) := x"5" & "00" & '0'& '0' & x"2A";	-- STA @42 	# Limpando endereço de temp 3
tmp(33) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5 
tmp(34) := x"5" & "00" & '0'& '0' & x"0B";	-- STA @11 	# Limite das dezenas
tmp(35) := x"5" & "00" & '0'& '0' & x"29";	-- STA @41 	# Limpando endereço de temp 2
tmp(36) := x"5" & "00" & '0'& '0' & x"0D";	-- STA @13 	# Limite dos milhares
tmp(37) := x"5" & "00" & '0'& '0' & x"2B";	-- STA @43 	# Limpando endereço de temp 4
tmp(38) := x"4" & "00" & '0'& '0' & x"03";	-- LDI $3 
tmp(39) := x"5" & "00" & '0'& '0' & x"0E";	-- STA @14 	# Limite das dezenas de milhares
tmp(40) := x"5" & "00" & '0'& '0' & x"2C";	-- STA @44 	# Limpando endereço de temp 5
tmp(41) := x"4" & "00" & '0'& '0' & x"02";	-- LDI $2
tmp(42) := x"5" & "00" & '0'& '0' & x"0F";	-- STA @15 	# Limite das centenas de milhares
tmp(43) := x"5" & "00" & '0'& '0' & x"2D";	-- STA @45 	# Limpando endereço de temp 6
tmp(44) := x"4" & "00" & '0'& '0' & x"63";	-- LDI $99 	# Carregando 99 no acumulador
tmp(45) := x"5" & "00" & '0'& '0' & x"1D";	-- STA @29 	# Carregando 100 na posição 29
tmp(46) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carregando 0 no acumulador
tmp(47) := x"5" & "00" & '0'& '1' & x"F4";	-- STA @500 	# Desligando o display 0
tmp(48) := x"5" & "00" & '0'& '0' & x"14";	-- STA @20 	#temporizador 1
tmp(49) := x"5" & "00" & '0'& '0' & x"15";	-- STA @21 	#temporizador 2
tmp(50) := x"5" & "00" & '0'& '0' & x"16";	-- STA @22 	#temporizador 3
tmp(51) := x"5" & "00" & '0'& '0' & x"17";	-- STA @23 	# PISCA OU NÃO PISCA
tmp(52) := x"6" & "00"& '0' & '1' & x"60";	-- JMP %le_key 	# Vai para o label le_key
-- temporizador_1_segundo:
tmp(54) := x"1" & "00" & '0'& '0' & x"14";	-- LDA @20 	# Carrega o acumulador com o endereço de temporizador 1
tmp(55) := x"8" & "00" & '0'& '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(56) := x"7" & "00" & '0' & '0' & x"3D";	-- JEQ %temporizador_2_segundo 	# Se for igual, vai para o label temporizador_2_segundo
tmp(57) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(58) := x"5" & "00" & '0'& '0' & x"14";	-- STA @20 	# Armazena o valor do acumulador no endereço de temporizador 1
tmp(59) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- temporizador_2_segundo:
tmp(61) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(62) := x"5" & "00" & '0'& '0' & x"14";	-- STA @20 	# Armazena o valor do acumulador no endereço de temporizador 1
tmp(63) := x"1" & "00" & '0'& '0' & x"15";	-- LDA @21 	# Carrega o acumulador com o endereço de temporizador 2
tmp(64) := x"8" & "00" & '0'& '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(65) := x"7" & "00" & '0' & '0' & x"46";	-- JEQ %temporizador_3_segundo 	# Se for igual, vai para o label temporizador_3_segundo
tmp(66) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(67) := x"5" & "00" & '0'& '0' & x"15";	-- STA @21 	# Armazena o valor do acumulador no endereço de temporizador 2
tmp(68) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- temporizador_3_segundo:
tmp(70) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(71) := x"5" & "00" & '0'& '0' & x"15";	-- STA @21 	# Armazena o valor do acumulador no endereço de temporizador 2
tmp(72) := x"1" & "00" & '0'& '0' & x"16";	-- LDA @22 	# Carrega o acumulador com o endereço de temporizador 3
tmp(73) := x"8" & "00" & '0'& '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(74) := x"7" & "00" & '0' & '0' & x"4F";	-- JEQ %PISCA 	# Se for igual, vai para o label LIMPA
tmp(75) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(76) := x"5" & "00" & '0'& '0' & x"16";	-- STA @22 	# Armazena o valor do acumulador no endereço de temporizador 3
tmp(77) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- PISCA:
tmp(79) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(80) := x"5" & "00" & '0'& '0' & x"16";	-- STA @22 	# Limpando temporizador 3
tmp(81) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(82) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(83) := x"7" & "00" & '0' & '0' & x"58";	-- JEQ %LIMPA 	# Se for igual, vai para o label LIMPA
tmp(84) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1 	# Carrega 1 no acumulador
tmp(85) := x"5" & "00" & '0'& '0' & x"17";	-- STA @23 	# Armazena o valor do acumulador no endereço de PISCA
tmp(86) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- LIMPA:
tmp(88) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(89) := x"5" & "00" & '0'& '0' & x"17";	-- STA @23 	# Armazena o valor do acumulador no endereço de PISCA
tmp(90) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_unidades:
tmp(92) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(93) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(94) := x"9" & "00" & '1' & '0' & x"29";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_unidades:
tmp(96) := x"9" & "00" & '0' & '0' & x"36";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(97) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(98) := x"5" & "00" & '0'& '1' & x"F4";	-- STA @500 	# Desliga o display unidade
tmp(99) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(100) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(101) := x"7" & "00" & '0' & '0' & x"78";	-- JEQ %define_limites_dezenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(102) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(103) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(104) := x"7" & "00" & '0' & '0' & x"60";	-- JEQ %checa_limites_unidades 	# Se for igual, vai para o label checa_limites_unidades
tmp(105) := x"9" & "00" & '0' & '0' & x"6C";	-- JSR %adiciona_unidade 	# Se não for igual, vai para o label adiciona_unidade
tmp(106) := x"6" & "00" & '0' & '0' & x"5C";	-- JMP %define_limites_unidades 	# Se não for igual, volta para o label define_limites_unidades
-- adiciona_unidade:
tmp(108) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(109) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40 	# Carrega o acumulador com o endereço de Limite de unidade
tmp(110) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(111) := x"7" & "00" & '0' & '0' & x"74";	-- JEQ %zera_unidade 	# Se for igual, vai para o label zera_unidade
tmp(112) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(113) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40 	# Armazena o valor do acumulador no endereço de Limite de unidade
tmp(114) := x"A" & "00" & '0' & '0' & x"00";	-- RET 
-- zera_unidade:
tmp(116) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(117) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40 	# Armazena o valor do acumulador no endereço de Limite de unidade
tmp(118) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_dezenas:
tmp(120) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(121) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(122) := x"9" & "00" & '1' & '0' & x"29";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas:
tmp(124) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(125) := x"5" & "00" & '0'& '1' & x"F4";	-- STA @500 	# liga o display unidade
tmp(126) := x"9" & "00" & '0' & '0' & x"36";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(127) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(128) := x"5" & "00" & '0'& '1' & x"F5";	-- STA @501 	# Desliga o display unidade
tmp(129) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(130) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(131) := x"7" & "00" & '0' & '0' & x"95";	-- JEQ %define_limites_centenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(132) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(133) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(134) := x"7" & "00" & '0' & '0' & x"7C";	-- JEQ %checa_limites_dezenas 	# Se for igual, vai para o label checa_limites_dezenas
tmp(135) := x"9" & "00" & '0' & '0' & x"8B";	-- JSR %adiciona_dezena 	# Se não for igual, vai para o label adiciona_dezena
tmp(136) := x"5" & "00" & '0'& '0' & x"29";	-- STA @41 	# Armazena o valor do acumulador no endereço de Limite de dezenas
tmp(137) := x"6" & "00" & '0' & '0' & x"78";	-- JMP %define_limites_dezenas 	# Se não for igual, volta para o label define_limites_dezenas
-- adiciona_dezena:
tmp(139) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(140) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41 	# Carrega o acumulador com o endereço de Limite de dezena
tmp(141) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55 	# Compara o valor do acumulador com o valor 5
tmp(142) := x"7" & "00" & '0' & '0' & x"92";	-- JEQ %zera_dezena 	# Se for igual, vai para o label zera_dezena
tmp(143) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(144) := x"A" & "00" & '0' & '0' & x"00";	-- RET 
-- zera_dezena:
tmp(146) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(147) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_centenas:
tmp(149) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(150) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(151) := x"9" & "00" & '1' & '0' & x"29";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas:
tmp(153) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(154) := x"5" & "00" & '0'& '1' & x"F5";	-- STA @501 	# liga o display DEZENA
tmp(155) := x"9" & "00" & '0' & '0' & x"36";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(156) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(157) := x"5" & "00" & '0'& '1' & x"F6";	-- STA @502 	# Desliga o display unidade
tmp(158) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(159) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(160) := x"7" & "00" & '0' & '0' & x"B2";	-- JEQ %define_limites_milhares 	# Se for igual, vai para o label define_limites_centenas
tmp(161) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(162) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(163) := x"7" & "00" & '0' & '0' & x"99";	-- JEQ %checa_limites_centenas 	# Se for igual, vai para o label checa_limites_centenas
tmp(164) := x"9" & "00" & '0' & '0' & x"A8";	-- JSR %adiciona_centena 	# Se não for igual, vai para o label adiciona_centena
tmp(165) := x"5" & "00" & '0'& '0' & x"2A";	-- STA @42 	# Armazena o valor do acumulador no endereço de Limite de centenas
tmp(166) := x"6" & "00" & '0' & '0' & x"95";	-- JMP %define_limites_centenas 	# Se não for igual, volta para o label define_limites_centenas
-- adiciona_centena:
tmp(168) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(169) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42 	# Carrega o acumulador com o endereço de Limite de centena
tmp(170) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(171) := x"7" & "00" & '0' & '0' & x"AF";	-- JEQ %zera_centena 	# Se for igual, vai para o label zera_centena
tmp(172) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(173) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_centena:
tmp(175) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(176) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_milhares:
tmp(178) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(179) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(180) := x"9" & "00" & '1' & '0' & x"29";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_milhares:
tmp(182) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(183) := x"5" & "00" & '0'& '1' & x"F6";	-- STA @502 	# liga o display unidade
tmp(184) := x"9" & "00" & '0' & '0' & x"36";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(185) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(186) := x"5" & "00" & '0'& '1' & x"F7";	-- STA @503 	# Desliga o display unidade
tmp(187) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(188) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(189) := x"7" & "00" & '0' & '0' & x"CF";	-- JEQ %define_limites_dezenas_de_milhares 	# Se for igual, vai para o label define_limites_milhares
tmp(190) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(191) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(192) := x"7" & "00" & '0' & '0' & x"B6";	-- JEQ %checa_limites_milhares 	# Se for igual, vai para o label checa_limites_milhares
tmp(193) := x"9" & "00" & '0' & '0' & x"C5";	-- JSR %adiciona_milhar 	# Se não for igual, vai para o label adiciona_milhar
tmp(194) := x"5" & "00" & '0'& '0' & x"2B";	-- STA @43 	# Armazena o valor do acumulador no endereço de Limite de milhares
tmp(195) := x"6" & "00" & '0' & '0' & x"B2";	-- JMP %define_limites_milhares 	# Se não for igual, volta para o label define_limites_milhares
-- adiciona_milhar:
tmp(197) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(198) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43 	# Carrega o acumulador com o endereço de Limite de milhar
tmp(199) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55 	# Compara o valor do acumulador com o valor 9
tmp(200) := x"7" & "00" & '0' & '0' & x"CC";	-- JEQ %zera_milhar 	# Se for igual, vai para o label zera_milhar
tmp(201) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(202) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_milhar:
tmp(204) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(205) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_dezenas_de_milhares:
tmp(207) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(208) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(209) := x"9" & "00" & '1' & '0' & x"29";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas_de_milhares:
tmp(211) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(212) := x"5" & "00" & '0'& '1' & x"F7";	-- STA @503 	# liga o display unidade
tmp(213) := x"9" & "00" & '0' & '0' & x"36";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(214) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(215) := x"5" & "00" & '0'& '1' & x"F8";	-- STA @504 	# Desliga o display unidade
tmp(216) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(217) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(218) := x"7" & "00" & '0' & '0' & x"F5";	-- JEQ %define_limites_centenas_de_milhares 	# Se for igual, vai para o label define_limites_dezenas_de_milhares
tmp(219) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(220) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(221) := x"7" & "00" & '0' & '0' & x"D3";	-- JEQ %checa_limites_dezenas_de_milhares 	# Se for igual, vai para o label checa_limites_dezenas_de_milhares
tmp(222) := x"9" & "00" & '0' & '0' & x"E2";	-- JSR %adiciona_dezena_de_milhar 	# Se não for igual, vai para o label adiciona_dezena_de_milhar
tmp(223) := x"5" & "00" & '0'& '0' & x"2C";	-- STA @44 	# Armazena o valor do acumulador no endereço de Limite de dezenas de milhares
tmp(224) := x"6" & "00" & '0' & '0' & x"CF";	-- JMP %define_limites_dezenas_de_milhares 	# Se não for igual, volta para o label define_limites_dezenas_de_milhares
-- adiciona_dezena_de_milhar:
tmp(226) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(227) := x"1" & "00" & '0'& '0' & x"0F";	-- LDA @15 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(228) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador com o valor 9
tmp(229) := x"7" & "00" & '0' & '0' & x"EF";	-- JEQ %limite_caso_20
tmp(230) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(231) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(232) := x"7" & "00" & '0' & '0' & x"EC";	-- JEQ %zera_dezena_de_milhar 	# Se for igual, vai para o label zera_dezena_de_milhar
tmp(233) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(234) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_dezena_de_milhar:
tmp(236) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(237) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- limite_caso_20:
tmp(239) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(240) := x"8" & "00" & '0'& '0' & x"35";	-- CEQ @53 	# Compara o valor do acumulador com o valor 9
tmp(241) := x"7" & "00" & '0' & '0' & x"EC";	-- JEQ %zera_dezena_de_milhar 	# Se for igual, vai para o label zera_dezena_de_milhar
tmp(242) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(243) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_centenas_de_milhares:
tmp(245) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(246) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(247) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando key 0
tmp(248) := x"9" & "00" & '1' & '0' & x"29";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas_de_milhares:
tmp(250) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(251) := x"5" & "00" & '0'& '1' & x"F8";	-- STA @504 	# liga o display unidade
tmp(252) := x"9" & "00" & '0' & '0' & x"36";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(253) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(254) := x"5" & "00" & '0'& '1' & x"F9";	-- STA @505 	# Desliga o display unidade
tmp(255) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(256) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(257) := x"7" & "00"& '0' & '1' & x"16";	-- JEQ %salva 	# Se for igual, vai para o label salva
tmp(258) := x"1" & "00" & '0'& '1' & x"62";	-- LDA @354 	# Carrega o acumulador com o key 2
tmp(259) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(260) := x"7" & "00"& '0' & '1' & x"24";	-- JEQ %salva_tempo 	# Se for igual, vai para o label salva
tmp(261) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(262) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(263) := x"7" & "00" & '0' & '0' & x"FA";	-- JEQ %checa_limites_centenas_de_milhares 	# Se for igual, vai para o label checa_limites_centenas_de_milhares
tmp(264) := x"9" & "00"& '0' & '1' & x"0C";	-- JSR %adiciona_centena_de_milhar 	# Se não for igual, vai para o label adiciona_centena_de_milhar
tmp(265) := x"5" & "00" & '0'& '0' & x"2D";	-- STA @45 	# Armazena o valor do acumulador no endereço de Limite de centenas de milhares
tmp(266) := x"6" & "00" & '0' & '0' & x"F5";	-- JMP %define_limites_centenas_de_milhares 	# Se não for igual, volta para o label define_limites_centenas_de_milhares
-- adiciona_centena_de_milhar:
tmp(268) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(269) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45 	# Carrega o acumulador com o endereço de Limite de centena de milhar
tmp(270) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador com o valor 2
tmp(271) := x"7" & "00"& '0' & '1' & x"13";	-- JEQ %zera_centena_de_milhar 	# Se for igual, vai para o label zera_centena_de_milhar
tmp(272) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(273) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_centena_de_milhar:
tmp(275) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(276) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- salva:
tmp(278) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45 	# Carrega o acumulador com o endereço de Limite de centena de milhar
tmp(279) := x"5" & "00" & '0'& '0' & x"0F";	-- STA @15 	# Armazena o valor do acumulador no endereço de Limite de dezena de milhar
tmp(280) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(281) := x"5" & "00" & '0'& '0' & x"0E";	-- STA @14 	# Armazena o valor do acumulador no endereço de Limite de milhares
tmp(282) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43 	# Carrega o acumulador com o endereço de Limite de milhares
tmp(283) := x"5" & "00" & '0'& '0' & x"0D";	-- STA @13 	# Armazena o valor do acumulador no endereço de Limite de centenas
tmp(284) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42 	# Carrega o acumulador com o endereço de Limite de centenas
tmp(285) := x"5" & "00" & '0'& '0' & x"0C";	-- STA @12 	# Armazena o valor do acumulador no endereço de Limite de dezenas
tmp(286) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41 	# Carrega o acumulador com o endereço de Limite de dezenas
tmp(287) := x"5" & "00" & '0'& '0' & x"0B";	-- STA @11 	# Armazena o valor do acumulador no endereço de Limite de unidades
tmp(288) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40 	# Carrega o acumulador com o endereço de Limite de unidades
tmp(289) := x"5" & "00" & '0'& '0' & x"0A";	-- STA @10 	# Armazena o valor do acumulador no endereço de Limite de unidades
tmp(290) := x"6" & "00"& '0' & '1' & x"49";	-- JMP %reset_temp 	# Se não for igual, volta para o label define_limites_unidades
-- salva_tempo:
tmp(292) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45 	# Carrega o acumulador com o endereço de Limite de centena de milhar
tmp(293) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço de Limite de dezena de milhar
tmp(294) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(295) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço de Limite de milhares
tmp(296) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43 	# Carrega o acumulador com o endereço de Limite de milhares
tmp(297) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço de Limite de centenas
tmp(298) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42 	# Carrega o acumulador com o endereço de Limite de centenas
tmp(299) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço de Limite de dezenas
tmp(300) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41 	# Carrega o acumulador com o endereço de Limite de dezenas
tmp(301) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço de Limite de unidades
tmp(302) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40 	# Carrega o acumulador com o endereço de Limite de unidades
tmp(303) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de Limite de unidades
tmp(304) := x"4" & "00" & '0'& '0' & x"55";	-- LDI $85 	# Carrega 85 no acumulador
tmp(305) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Armazena o valor do acumulador nos LED 7 - 8
tmp(306) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357 	# Carrega o acumulador com o segundos
tmp(307) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(308) := x"7" & "00"& '0' & '1' & x"37";	-- JEQ %pre_salva_tempo_pt2
tmp(309) := x"6" & "00"& '0' & '1' & x"24";	-- JMP %salva_tempo
-- pre_salva_tempo_pt2:
tmp(311) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando key 0
-- salva_tempo_pt2:
tmp(313) := x"4" & "00" & '0'& '0' & x"55";	-- LDI $85 	# Carrega 85 no acumulador
tmp(314) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Armazena o valor do acumulador nos LED 7 - 8
tmp(315) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357 	# Carrega o acumulador com o segundos
tmp(316) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(317) := x"7" & "00"& '0' & '1' & x"40";	-- JEQ %pre_salva_tempo_pt3 	# Se não for igual, volta para o label define_limites_unidades
tmp(318) := x"6" & "00"& '0' & '1' & x"39";	-- JMP %salva_tempo_pt2
-- pre_salva_tempo_pt3:
tmp(320) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando key 0
-- salva_tempo_pt3:
tmp(322) := x"4" & "00" & '0'& '0' & x"AA";	-- LDI $170 	# Carrega 85 no acumulador
tmp(323) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Armazena o valor do acumulador nos LED 7 - 8
tmp(324) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357 	# Carrega o acumulador com o segundos
tmp(325) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(326) := x"7" & "00"& '0' & '1' & x"49";	-- JEQ %reset_temp 	# Se não for igual, volta para o label define_limites_unidades
tmp(327) := x"6" & "00"& '0' & '1' & x"42";	-- JMP %salva_tempo_pt3
-- reset_temp:
tmp(329) := x"1" & "00" & '0'& '0' & x"0A";	-- LDA @10 	# Carrega o acumulador com o endereço de Limite de unidades
tmp(330) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40 	# Limpando endereço de temp 1
tmp(331) := x"1" & "00" & '0'& '0' & x"0C";	-- LDA @12 	# Carrega o acumulador com o endereço de Limite de CENTENAS
tmp(332) := x"5" & "00" & '0'& '0' & x"2A";	-- STA @42 	# Limpando endereço de temp 3
tmp(333) := x"1" & "00" & '0'& '0' & x"0B";	-- LDA @11 	# Carrega o acumulador com o endereço de Limite de CENTENAS
tmp(334) := x"5" & "00" & '0'& '0' & x"29";	-- STA @41 	# Limpando endereço de temp 2
tmp(335) := x"1" & "00" & '0'& '0' & x"0D";	-- LDA @13 	# Carrega o acumulador com o endereço de Limite de CENTENAS
tmp(336) := x"5" & "00" & '0'& '0' & x"2B";	-- STA @43 	# Limpando endereço de temp 4
tmp(337) := x"1" & "00" & '0'& '0' & x"0E";	-- LDA @14 	# Carrega o acumulador com o endereço de Limite de CENTENAS
tmp(338) := x"5" & "00" & '0'& '0' & x"2C";	-- STA @44 	# Limpando endereço de temp 5
tmp(339) := x"1" & "00" & '0'& '0' & x"0F";	-- LDA @15 	# Carrega o acumulador com o endereço de Limite de CENTENAS
tmp(340) := x"5" & "00" & '0'& '0' & x"2D";	-- STA @45 	# Limpando endereço de temp 6
tmp(341) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 85 no acumulador
tmp(342) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Armazena o valor do acumulador nos LED 7 - 8
tmp(343) := x"6" & "00"& '0' & '1' & x"59";	-- JMP %pre_le_key
-- pre_le_key:
tmp(345) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(346) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(347) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 1 no acumulador
tmp(348) := x"5" & "00" & '0'& '1' & x"F9";	-- STA @505 	# Liga o display 0
tmp(349) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays
tmp(350) := x"6" & "00"& '0' & '1' & x"60";	-- JMP %le_key 	# Vai para o label le_key
-- le_key:
tmp(352) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357 	# Carrega o acumulador com o segundos
tmp(353) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(354) := x"7" & "00"& '0' & '1' & x"83";	-- JEQ %incrementa_unidade 	# Se for igual, vai para o label incrementa
tmp(355) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(356) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(357) := x"7" & "00" & '0' & '0' & x"5C";	-- JEQ %define_limites_unidades 	# Se for igual, vai para o label incrementa
tmp(358) := x"9" & "00"& '0' & '1' & x"6D";	-- JSR %checa_op 	# checa se é + ou -
tmp(359) := x"9" & "00"& '0' & '1' & x"78";	-- JSR %checa_timer 	# checa se ta ligado ou nao
tmp(360) := x"1" & "00" & '0'& '1' & x"64";	-- LDA @356		# Carrega o acumulador com o endereço de fpga_reset
tmp(361) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(362) := x"7" & "00" & '1' & '0' & x"5A";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(363) := x"6" & "00"& '0' & '1' & x"60";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- checa_op:
tmp(365) := x"1" & "00" & '0'& '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(366) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(367) := x"7" & "00"& '0' & '1' & x"74";	-- JEQ %mais 	# Se for igual, vai para o label le_key
tmp(368) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1 	# Carrega o acumulador com o valor 1
tmp(369) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258 	# Liga led 9
tmp(370) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- mais:
tmp(372) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(373) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258 	# Liga led 9
tmp(374) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- checa_timer:
tmp(376) := x"1" & "00" & '0'& '1' & x"41";	-- LDA @321 	# Carrega o acumulador com o endereço de SW8
tmp(377) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(378) := x"7" & "00"& '0' & '1' & x"7F";	-- JEQ %desativado 	# Se for igual, vai para o label desativado
tmp(379) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1 	# Carrega o acumulador com o valor 1
tmp(380) := x"5" & "00" & '0'& '1' & x"01";	-- STA @257 	# Liga led 8
tmp(381) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- desativado:
tmp(383) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(384) := x"5" & "00" & '0'& '1' & x"01";	-- STA @257 	# Liga led 8
tmp(385) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- incrementa_unidade:
tmp(387) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando key 0
tmp(388) := x"1" & "00" & '0'& '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(389) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(390) := x"7" & "00"& '0' & '1' & x"90";	-- JEQ %sub_unidade 	# Se for igual, vai para o label sub_unidade
tmp(391) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(392) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(393) := x"7" & "00"& '0' & '1' & x"97";	-- JEQ %incrementa_dezena 	# Se for igual, vai para o label incrementa_dezena
tmp(394) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(395) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(396) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(397) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258 	# Desliga led 9
tmp(398) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- sub_unidade:
tmp(400) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(401) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(402) := x"7" & "00"& '0' & '1' & x"A1";	-- JEQ %decremeta_dezena 	# Se for igual, vai para o label decremeta_dezena
tmp(403) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(404) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(405) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- incrementa_dezena:
tmp(407) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(408) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(409) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(410) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(411) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(412) := x"7" & "00"& '0' & '1' & x"AB";	-- JEQ %incrementa_centena 	# Se for igual a 9, vai para o incrementa_centena
tmp(413) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(414) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(415) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_dezena:
tmp(417) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9
tmp(418) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(419) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(420) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(421) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(422) := x"7" & "00"& '0' & '1' & x"B5";	-- JEQ %decremeta_centena 	# Se for igual a 0, vai para o decremeta_centena
tmp(423) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(424) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(425) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena:
tmp(427) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(428) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(429) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(430) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(431) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (centena) com o valor 9
tmp(432) := x"7" & "00"& '0' & '1' & x"BF";	-- JEQ %incrementa_milhar 	# Se for igual a 9, vai para o incrementa_milhar
tmp(433) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(434) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(435) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena:
tmp(437) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5
tmp(438) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(439) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(440) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(441) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (centena) com o valor 0
tmp(442) := x"7" & "00"& '0' & '1' & x"C9";	-- JEQ %decremeta_milhar 	# Se for igual a 0, vai para o decremeta_milhar
tmp(443) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(444) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(445) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_milhar:
tmp(447) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(448) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(449) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(450) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(451) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(452) := x"7" & "00"& '0' & '1' & x"D3";	-- JEQ %incrementa_dezena_de_milhar 	# Se for igual a 9, vai para o incrementa_dezena_de_milhar
tmp(453) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(454) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(455) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- decremeta_milhar:
tmp(457) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9
tmp(458) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(459) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(460) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(461) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(462) := x"7" & "00"& '0' & '1' & x"E6";	-- JEQ %decremeta_dezena_de_milhar 	# Se for igual a 0, vai para o decremeta_dezena_de_milhar
tmp(463) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(464) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(465) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- incrementa_dezena_de_milhar:
tmp(467) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(468) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(469) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(470) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena de milhar
tmp(471) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador (dezena) com o valor 2
tmp(472) := x"7" & "00"& '0' & '1' & x"E1";	-- JEQ %outro_incremente_dezena_de_milhar 	# Se for igual a 2, vai para o incremenoutro_incremente_dezena_de_milharta_centena_milhar
tmp(473) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(474) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(475) := x"7" & "00"& '0' & '1' & x"F0";	-- JEQ %incrementa_centena_milhar 	# Se for igual a 9, vai para o incrementa_centena_milhar
-- volta:
tmp(477) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(478) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(479) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- outro_incremente_dezena_de_milhar:
tmp(481) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(482) := x"8" & "00" & '0'& '0' & x"35";	-- CEQ @53 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(483) := x"7" & "00"& '0' & '1' & x"F0";	-- JEQ %incrementa_centena_milhar 	# Se for igual a 9, vai para o incrementa_centena_milhar
tmp(484) := x"6" & "00"& '0' & '1' & x"DD";	-- JMP %volta 	# Se não for igual, volta para o label volta
-- decremeta_dezena_de_milhar:
tmp(486) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5
tmp(487) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(488) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(489) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(490) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(491) := x"7" & "00"& '0' & '1' & x"FA";	-- JEQ %decremeta_centena_milhar 	# Se for igual a 0, vai para o decremeta_centena_milhar
tmp(492) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(493) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(494) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena_milhar:
tmp(496) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(497) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(498) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(499) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(500) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador (centena) com o valor 9
tmp(501) := x"7" & "00" & '1' & '0' & x"0C";	-- JEQ %zerou 	# Se for igual a 9, vai para o atualiza_displays
tmp(502) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(503) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(504) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena_milhar:
tmp(506) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(507) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador com o valor 2 (limite de centena de milhar)
tmp(508) := x"7" & "00" & '1' & '0' & x"08";	-- JEQ %caso20 	# Se for igual, vai para o label caso20
tmp(509) := x"4" & "00" & '0'& '0' & x"03";	-- LDI $3
tmp(510) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
-- volta_caso20:
tmp(512) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(513) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(514) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (centena) com o valor 0
tmp(515) := x"7" & "00" & '1' & '0' & x"0C";	-- JEQ %zerou 	# Se for igual a 0, vai para o atualiza_displays
tmp(516) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(517) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(518) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- caso20:
tmp(520) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9  
tmp(521) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(522) := x"6" & "00" & '1' & '0' & x"00";	-- JMP %volta_caso20 	# Se não for igual, volta para o label volta_caso20
-- zerou:
tmp(524) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(525) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(526) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(527) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(528) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(529) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(530) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(531) := x"1" & "00" & '0'& '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(532) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(533) := x"7" & "00" & '1' & '0' & x"69";	-- JEQ %final 	# Se for igual, vai para o label final
tmp(534) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(535) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando Key 1
tmp(536) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- atualiza_displays:
tmp(538) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(539) := x"5" & "00" & '0'& '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(540) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(541) := x"5" & "00" & '0'& '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(542) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(543) := x"5" & "00" & '0'& '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(544) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(545) := x"5" & "00" & '0'& '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(546) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(547) := x"5" & "00" & '0'& '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(548) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(549) := x"5" & "00" & '0'& '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(550) := x"9" & "00" & '1' & '0' & x"37";	-- JSR %verifica_centena_de_milhar 	# Vai para o label verifica_centena_de_milhar
tmp(551) := x"6" & "00"& '0' & '1' & x"60";	-- JMP %le_key 	# Vai para o label le_key
-- atualiza_displays_limites:
tmp(553) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40 	# Carrega o acumulador com o Limites das unidades
tmp(554) := x"5" & "00" & '0'& '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(555) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41 	# Carrega o acumulador com o Limites das dezenas
tmp(556) := x"5" & "00" & '0'& '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(557) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42 	# Carrega o acumulador com o Limites de centena
tmp(558) := x"5" & "00" & '0'& '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(559) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43 	# Carrega o acumulador com o Limites de milhar
tmp(560) := x"5" & "00" & '0'& '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(561) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o Limites de dezena de milhar
tmp(562) := x"5" & "00" & '0'& '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(563) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45 	# Carrega o acumulador com o Limites de centena de milhar
tmp(564) := x"5" & "00" & '0'& '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(565) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_centena_de_milhar:
tmp(567) := x"1" & "00" & '0'& '1' & x"41";	-- LDA @321 	# Carrega o acumulador com o endereço de SW8
tmp(568) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 0
tmp(569) := x"7" & "00" & '1' & '0' & x"3C";	-- JEQ %continua_verifica_centena_de_milhar 	# Se for igual, vai para o label continua_verifica_centena_de_milhar
tmp(570) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- continua_verifica_centena_de_milhar: 
tmp(572) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(573) := x"8" & "00" & '0'& '0' & x"0F";	-- CEQ @15 	# Compara o valor do acumulador com o valor maximo de centena de milhar
tmp(574) := x"7" & "00" & '1' & '0' & x"41";	-- JEQ %verifica_dezena_de_milhar 	# Se for igual, vai para o label verifica_dezena_de_milhar
tmp(575) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_dezena_de_milhar:
tmp(577) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(578) := x"8" & "00" & '0'& '0' & x"0E";	-- CEQ @14 	# Compara o valor do acumulador com o valor maximo de dezena de milhar
tmp(579) := x"7" & "00" & '1' & '0' & x"46";	-- JEQ %verifica_milhar 	# Se for igual, vai para o label verifica_milhar
tmp(580) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_milhar:
tmp(582) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(583) := x"8" & "00" & '0'& '0' & x"0D";	-- CEQ @13 	# Compara o valor do acumulador com o valor maximo de milhar
tmp(584) := x"7" & "00" & '1' & '0' & x"4B";	-- JEQ %verifica_centena 	# Se for igual, vai para o label verifica_centena
tmp(585) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_centena:
tmp(587) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(588) := x"8" & "00" & '0'& '0' & x"0C";	-- CEQ @12 	# Compara o valor do acumulador com o valor maximo de centena
tmp(589) := x"7" & "00" & '1' & '0' & x"50";	-- JEQ %verifica_dezena 	# Se for igual, vai para o label verifica_dezena
tmp(590) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_dezena:
tmp(592) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(593) := x"8" & "00" & '0'& '0' & x"0B";	-- CEQ @11 	# Compara o valor do acumulador com o valor maximo de dezena
tmp(594) := x"7" & "00" & '1' & '0' & x"55";	-- JEQ %verifica_unidade 	# Se for igual, vai para o label verifica_unidade
tmp(595) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_unidade:
tmp(597) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(598) := x"8" & "00" & '0'& '0' & x"0A";	-- CEQ @10 	# Compara o valor do acumulador com o valor maximo de unidade
tmp(599) := x"7" & "00" & '1' & '0' & x"69";	-- JEQ %final 	# Se for igual, vai para o label final
tmp(600) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- RESET_FPGA:
tmp(602) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(603) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(604) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando reset_key
tmp(605) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carregando 0 no acumulador
tmp(606) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(607) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(608) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(609) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(610) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(611) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(612) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258 	# Desliga led 9
tmp(613) := x"5" & "00" & '0'& '1' & x"01";	-- STA @257 	# Desliga o led 8
tmp(614) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Desliga o led 7 ao led 0
tmp(615) := x"6" & "00" & '1' & '0' & x"1A";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- final:
tmp(617) := x"1" & "00" & '0'& '0' & x"33";	-- LDA @51 	# Carrega 1 no acumulador
tmp(618) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258 	# Liga led 9
tmp(619) := x"5" & "00" & '0'& '1' & x"01";	-- STA @257 	# Liga o led 8
tmp(620) := x"4" & "00" & '0'& '0' & x"FF";	-- LDI $255 	# Carrega 255 no acumulador
tmp(621) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Liga o led 7 ao led 0
tmp(622) := x"1" & "00" & '0'& '1' & x"64";	-- LDA @356		# Carrega o acumulador com o endereço de fpga_reset
tmp(623) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(624) := x"7" & "00" & '1' & '0' & x"5A";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(625) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(626) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(627) := x"7" & "00" & '0' & '0' & x"5C";	-- JEQ %define_limites_unidades 	# Se for igual, vai para o label incrementa
tmp(628) := x"6" & "00" & '1' & '0' & x"69";	-- JMP %final







        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;