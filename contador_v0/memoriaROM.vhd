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

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
-- RESET:
tmp(1) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(2) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(3) := x"5" & '1' & x"FD";	-- STA @509 	# Limpando reset_key
tmp(4) := x"5" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(5) := x"5" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(6) := x"5" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(7) := x"5" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(8) := x"5" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(9) := x"5" & '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(10) := x"5" & '1' & x"20";	-- STA @288 	# Limpando endereço do HEX0
tmp(11) := x"5" & '1' & x"21";	-- STA @289 	# Limpando endereço do HEX1
tmp(12) := x"5" & '1' & x"22";	-- STA @290 	# Limpando endereço do HEX2
tmp(13) := x"5" & '1' & x"23";	-- STA @291 	# Limpando endereço do HEX3
tmp(14) := x"5" & '1' & x"24";	-- STA @292 	# Limpando endereço do HEX4
tmp(15) := x"5" & '1' & x"25";	-- STA @293 	# Limpando endereço do HEX5
tmp(16) := x"4" & '0' & x"09";	-- LDI $9 	# Carregando 9 no acumulador
tmp(17) := x"5" & '0' & x"3B";	-- STA @59 	# Carregando 9 na posição 59
tmp(18) := x"4" & '0' & x"0A";	-- LDI $10 	# Carregando 10 no acumulador
tmp(19) := x"5" & '0' & x"3C";	-- STA @60 	# Carergando 10 na posição 60
tmp(20) := x"4" & '0' & x"01";	-- LDI $1 	# Carregando 1 no acumulador
tmp(21) := x"5" & '0' & x"33";	-- STA @51 	# Carregando 1 na posição 51
tmp(22) := x"4" & '0' & x"09";	-- LDI $9
tmp(23) := x"5" & '0' & x"0A";	-- STA @10 	# Limite das unidades
tmp(24) := x"5" & '0' & x"0B";	-- STA @11 	# Limite das dezenas
tmp(25) := x"5" & '0' & x"0C";	-- STA @12 	# Limite das centenas
tmp(26) := x"5" & '0' & x"0D";	-- STA @13 	# Limite dos milhares
tmp(27) := x"5" & '0' & x"0E";	-- STA @14 	# Limite das dezenas de milhares
tmp(28) := x"5" & '0' & x"0F";	-- STA @15 	# Limite das centenas de milhares
tmp(29) := x"4" & '0' & x"63";	-- LDI $99 	# Carregando 78 no acumulador
tmp(30) := x"5" & '0' & x"1D";	-- STA @29 	# Carregando 100 na posição 29
tmp(31) := x"4" & '0' & x"00";	-- LDI $0 	# Carregando 0 no acumulador
tmp(32) := x"5" & '1' & x"F4";	-- STA @500 	# Desligando o display 0
tmp(33) := x"5" & '0' & x"14";	-- STA @20 	#temporizador 1
tmp(34) := x"5" & '0' & x"15";	-- STA @21 	#temporizador 2
tmp(35) := x"5" & '0' & x"16";	-- STA @22 	#temporizador 3
tmp(36) := x"5" & '0' & x"17";	-- STA @23 	# PISCA OU NÃO PISCA
tmp(37) := x"6" & '1' & x"01";	-- JMP %le_key 	# Vai para o label le_key
-- temporizador_1_segundo:
tmp(39) := x"1" & '0' & x"14";	-- LDA @20 	# Carrega o acumulador com o endereço de temporizador 1
tmp(40) := x"8" & '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(41) := x"7" & '0' & x"2E";	-- JEQ %temporizador_2_segundo 	# Se for igual, vai para o label temporizador_2_segundo
tmp(42) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(43) := x"5" & '0' & x"14";	-- STA @20 	# Armazena o valor do acumulador no endereço de temporizador 1
tmp(44) := x"A" & '0' & x"00";	-- RET
-- temporizador_2_segundo:
tmp(46) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(47) := x"5" & '0' & x"14";	-- STA @20 	# Armazena o valor do acumulador no endereço de temporizador 1
tmp(48) := x"1" & '0' & x"15";	-- LDA @21 	# Carrega o acumulador com o endereço de temporizador 2
tmp(49) := x"8" & '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(50) := x"7" & '0' & x"37";	-- JEQ %temporizador_3_segundo 	# Se for igual, vai para o label temporizador_3_segundo
tmp(51) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(52) := x"5" & '0' & x"15";	-- STA @21 	# Armazena o valor do acumulador no endereço de temporizador 2
tmp(53) := x"A" & '0' & x"00";	-- RET
-- temporizador_3_segundo:
tmp(55) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(56) := x"5" & '0' & x"15";	-- STA @21 	# Armazena o valor do acumulador no endereço de temporizador 2
tmp(57) := x"1" & '0' & x"16";	-- LDA @22 	# Carrega o acumulador com o endereço de temporizador 3
tmp(58) := x"8" & '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(59) := x"7" & '0' & x"40";	-- JEQ %PISCA 	# Se for igual, vai para o label LIMPA
tmp(60) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(61) := x"5" & '0' & x"16";	-- STA @22 	# Armazena o valor do acumulador no endereço de temporizador 3
tmp(62) := x"A" & '0' & x"00";	-- RET
-- PISCA:
tmp(64) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(65) := x"5" & '0' & x"16";	-- STA @22 	# Limpando temporizador 3
tmp(66) := x"1" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(67) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(68) := x"7" & '0' & x"49";	-- JEQ %LIMPA 	# Se for igual, vai para o label LIMPA
tmp(69) := x"4" & '0' & x"01";	-- LDI $1 	# Carrega 1 no acumulador
tmp(70) := x"5" & '0' & x"17";	-- STA @23 	# Armazena o valor do acumulador no endereço de PISCA
tmp(71) := x"A" & '0' & x"00";	-- RET
-- LIMPA:
tmp(73) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(74) := x"5" & '0' & x"17";	-- STA @23 	# Armazena o valor do acumulador no endereço de PISCA
tmp(75) := x"A" & '0' & x"00";	-- RET
-- define_limites_unidades:
tmp(77) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(78) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(79) := x"9" & '1' & x"A9";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_unidades:
tmp(81) := x"9" & '0' & x"27";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(82) := x"1" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(83) := x"5" & '1' & x"F4";	-- STA @500 	# Desliga o display unidade
tmp(84) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(85) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(86) := x"7" & '0' & x"69";	-- JEQ %define_limites_dezenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(87) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(88) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(89) := x"7" & '0' & x"51";	-- JEQ %checa_limites_unidades 	# Se for igual, vai para o label checa_limites_unidades
tmp(90) := x"9" & '0' & x"5D";	-- JSR %adiciona_unidade 	# Se não for igual, vai para o label adiciona_unidade
tmp(91) := x"6" & '0' & x"4D";	-- JMP %define_limites_unidades 	# Se não for igual, volta para o label define_limites_unidades
-- adiciona_unidade:
tmp(93) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(94) := x"1" & '0' & x"0A";	-- LDA @10 	# Carrega o acumulador com o endereço de Limite de unidade
tmp(95) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(96) := x"7" & '0' & x"65";	-- JEQ %zera_unidade 	# Se for igual, vai para o label zera_unidade
tmp(97) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(98) := x"5" & '0' & x"0A";	-- STA @10 	# Armazena o valor do acumulador no endereço de Limite de unidade
tmp(99) := x"A" & '0' & x"00";	-- RET 
-- zera_unidade:
tmp(101) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(102) := x"5" & '0' & x"0A";	-- STA @10 	# Armazena o valor do acumulador no endereço de Limite de unidade
tmp(103) := x"A" & '0' & x"00";	-- RET
-- define_limites_dezenas:
tmp(105) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(106) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(107) := x"9" & '1' & x"A9";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas:
tmp(109) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(110) := x"5" & '1' & x"F4";	-- STA @500 	# liga o display unidade
tmp(111) := x"9" & '0' & x"27";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(112) := x"1" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(113) := x"5" & '1' & x"F5";	-- STA @501 	# Desliga o display unidade
tmp(114) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(115) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(116) := x"7" & '0' & x"86";	-- JEQ %define_limites_centenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(117) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(118) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(119) := x"7" & '0' & x"6D";	-- JEQ %checa_limites_dezenas 	# Se for igual, vai para o label checa_limites_dezenas
tmp(120) := x"9" & '0' & x"7C";	-- JSR %adiciona_dezena 	# Se não for igual, vai para o label adiciona_dezena
tmp(121) := x"5" & '0' & x"0B";	-- STA @11 	# Armazena o valor do acumulador no endereço de Limite de dezenas
tmp(122) := x"6" & '0' & x"69";	-- JMP %define_limites_dezenas 	# Se não for igual, volta para o label define_limites_dezenas
-- adiciona_dezena:
tmp(124) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(125) := x"1" & '0' & x"0B";	-- LDA @11 	# Carrega o acumulador com o endereço de Limite de dezena
tmp(126) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(127) := x"7" & '0' & x"83";	-- JEQ %zera_dezena 	# Se for igual, vai para o label zera_dezena
tmp(128) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(129) := x"A" & '0' & x"00";	-- RET 
-- zera_dezena:
tmp(131) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(132) := x"A" & '0' & x"00";	-- RET
-- define_limites_centenas:
tmp(134) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(135) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(136) := x"9" & '1' & x"A9";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas:
tmp(138) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(139) := x"5" & '1' & x"F5";	-- STA @501 	# liga o display unidade
tmp(140) := x"9" & '0' & x"27";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(141) := x"1" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(142) := x"5" & '1' & x"F6";	-- STA @502 	# Desliga o display unidade
tmp(143) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(144) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(145) := x"7" & '0' & x"A3";	-- JEQ %define_limites_milhares 	# Se for igual, vai para o label define_limites_centenas
tmp(146) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(147) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(148) := x"7" & '0' & x"8A";	-- JEQ %checa_limites_centenas 	# Se for igual, vai para o label checa_limites_centenas
tmp(149) := x"9" & '0' & x"99";	-- JSR %adiciona_centena 	# Se não for igual, vai para o label adiciona_centena
tmp(150) := x"5" & '0' & x"0C";	-- STA @12 	# Armazena o valor do acumulador no endereço de Limite de centenas
tmp(151) := x"6" & '0' & x"86";	-- JMP %define_limites_centenas 	# Se não for igual, volta para o label define_limites_centenas
-- adiciona_centena:
tmp(153) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(154) := x"1" & '0' & x"0C";	-- LDA @12 	# Carrega o acumulador com o endereço de Limite de centena
tmp(155) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(156) := x"7" & '0' & x"A0";	-- JEQ %zera_centena 	# Se for igual, vai para o label zera_centena
tmp(157) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(158) := x"A" & '0' & x"00";	-- RET
-- zera_centena:
tmp(160) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(161) := x"A" & '0' & x"00";	-- RET
-- define_limites_milhares:
tmp(163) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(164) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(165) := x"9" & '1' & x"A9";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_milhares:
tmp(167) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(168) := x"5" & '1' & x"F6";	-- STA @502 	# liga o display unidade
tmp(169) := x"9" & '0' & x"27";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(170) := x"1" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(171) := x"5" & '1' & x"F7";	-- STA @503 	# Desliga o display unidade
tmp(172) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(173) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(174) := x"7" & '0' & x"C0";	-- JEQ %define_limites_dezenas_de_milhares 	# Se for igual, vai para o label define_limites_milhares
tmp(175) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(176) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(177) := x"7" & '0' & x"A7";	-- JEQ %checa_limites_milhares 	# Se for igual, vai para o label checa_limites_milhares
tmp(178) := x"9" & '0' & x"B6";	-- JSR %adiciona_milhar 	# Se não for igual, vai para o label adiciona_milhar
tmp(179) := x"5" & '0' & x"0D";	-- STA @13 	# Armazena o valor do acumulador no endereço de Limite de milhares
tmp(180) := x"6" & '0' & x"A3";	-- JMP %define_limites_milhares 	# Se não for igual, volta para o label define_limites_milhares
-- adiciona_milhar:
tmp(182) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(183) := x"1" & '0' & x"0D";	-- LDA @13 	# Carrega o acumulador com o endereço de Limite de milhar
tmp(184) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(185) := x"7" & '0' & x"BD";	-- JEQ %zera_milhar 	# Se for igual, vai para o label zera_milhar
tmp(186) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(187) := x"A" & '0' & x"00";	-- RET
-- zera_milhar:
tmp(189) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(190) := x"A" & '0' & x"00";	-- RET
-- define_limites_dezenas_de_milhares:
tmp(192) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(193) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(194) := x"9" & '1' & x"A9";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas_de_milhares:
tmp(196) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(197) := x"5" & '1' & x"F7";	-- STA @503 	# liga o display unidade
tmp(198) := x"9" & '0' & x"27";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(199) := x"1" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(200) := x"5" & '1' & x"F8";	-- STA @504 	# Desliga o display unidade
tmp(201) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(202) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(203) := x"7" & '0' & x"DD";	-- JEQ %define_limites_centenas_de_milhares 	# Se for igual, vai para o label define_limites_dezenas_de_milhares
tmp(204) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(205) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(206) := x"7" & '0' & x"C4";	-- JEQ %checa_limites_dezenas_de_milhares 	# Se for igual, vai para o label checa_limites_dezenas_de_milhares
tmp(207) := x"9" & '0' & x"D3";	-- JSR %adiciona_dezena_de_milhar 	# Se não for igual, vai para o label adiciona_dezena_de_milhar
tmp(208) := x"5" & '0' & x"0E";	-- STA @14 	# Armazena o valor do acumulador no endereço de Limite de dezenas de milhares
tmp(209) := x"6" & '0' & x"C0";	-- JMP %define_limites_dezenas_de_milhares 	# Se não for igual, volta para o label define_limites_dezenas_de_milhares
-- adiciona_dezena_de_milhar:
tmp(211) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(212) := x"1" & '0' & x"0E";	-- LDA @14 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(213) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(214) := x"7" & '0' & x"DA";	-- JEQ %zera_dezena_de_milhar 	# Se for igual, vai para o label zera_dezena_de_milhar
tmp(215) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(216) := x"A" & '0' & x"00";	-- RET
-- zera_dezena_de_milhar:
tmp(218) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(219) := x"A" & '0' & x"00";	-- RET
-- define_limites_centenas_de_milhares:
tmp(221) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(222) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(223) := x"9" & '1' & x"A9";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas_de_milhares:
tmp(225) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(226) := x"5" & '1' & x"F8";	-- STA @504 	# liga o display unidade
tmp(227) := x"9" & '0' & x"27";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(228) := x"1" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(229) := x"5" & '1' & x"F9";	-- STA @505 	# Desliga o display unidade
tmp(230) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(231) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(232) := x"7" & '0' & x"FA";	-- JEQ %pre_le_key 	# Se for igual, vai para o label pre_le_key
tmp(233) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(234) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(235) := x"7" & '0' & x"E1";	-- JEQ %checa_limites_centenas_de_milhares 	# Se for igual, vai para o label checa_limites_centenas_de_milhares
tmp(236) := x"9" & '0' & x"F0";	-- JSR %adiciona_centena_de_milhar 	# Se não for igual, vai para o label adiciona_centena_de_milhar
tmp(237) := x"5" & '0' & x"0F";	-- STA @15 	# Armazena o valor do acumulador no endereço de Limite de centenas de milhares
tmp(238) := x"6" & '0' & x"DD";	-- JMP %define_limites_centenas_de_milhares 	# Se não for igual, volta para o label define_limites_centenas_de_milhares
-- adiciona_centena_de_milhar:
tmp(240) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(241) := x"1" & '0' & x"0F";	-- LDA @15 	# Carrega o acumulador com o endereço de Limite de centena de milhar
tmp(242) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(243) := x"7" & '0' & x"F7";	-- JEQ %zera_centena_de_milhar 	# Se for igual, vai para o label zera_centena_de_milhar
tmp(244) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(245) := x"A" & '0' & x"00";	-- RET
-- zera_centena_de_milhar:
tmp(247) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(248) := x"A" & '0' & x"00";	-- RET
-- pre_le_key:
tmp(250) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(251) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(252) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 1 no acumulador
tmp(253) := x"5" & '1' & x"F9";	-- STA @505 	# Liga o display 0
tmp(254) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays
tmp(255) := x"6" & '1' & x"01";	-- JMP %le_key 	# Vai para o label le_key
-- le_key:
tmp(257) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(258) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(259) := x"7" & '1' & x"18";	-- JEQ %incrementa_unidade 	# Se for igual, vai para o label incrementa
tmp(260) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(261) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(262) := x"7" & '0' & x"4D";	-- JEQ %define_limites_unidades 	# Se for igual, vai para o label incrementa
tmp(263) := x"9" & '1' & x"0D";	-- JSR %checa_op 	# checa se é + ou -
tmp(264) := x"1" & '1' & x"64";	-- LDA @356		# Carrega o acumulador com o endereço de fpga_reset
tmp(265) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(266) := x"7" & '1' & x"D5";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(267) := x"6" & '1' & x"01";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- checa_op:
tmp(269) := x"1" & '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(270) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(271) := x"7" & '1' & x"14";	-- JEQ %mais 	# Se for igual, vai para o label le_key
tmp(272) := x"4" & '0' & x"01";	-- LDI $1 	# Carrega o acumulador com o valor 1
tmp(273) := x"5" & '1' & x"02";	-- STA @258 	# Liga led 9
tmp(274) := x"A" & '0' & x"00";	-- RET
-- mais:
tmp(276) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(277) := x"5" & '1' & x"02";	-- STA @258 	# Liga led 9
tmp(278) := x"A" & '0' & x"00";	-- RET
-- incrementa_unidade:
tmp(280) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(281) := x"1" & '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(282) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(283) := x"7" & '1' & x"25";	-- JEQ %sub_unidade 	# Se for igual, vai para o label sub_unidade
tmp(284) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(285) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(286) := x"7" & '1' & x"2C";	-- JEQ %incrementa_dezena 	# Se for igual, vai para o label incrementa_dezena
tmp(287) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(288) := x"5" & '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(289) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(290) := x"5" & '1' & x"02";	-- STA @258 	# Desliga led 9
tmp(291) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- sub_unidade:
tmp(293) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(294) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(295) := x"7" & '1' & x"36";	-- JEQ %decremeta_dezena 	# Se for igual, vai para o label decremeta_dezena
tmp(296) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(297) := x"5" & '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(298) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- incrementa_dezena:
tmp(300) := x"4" & '0' & x"00";	-- LDI $0
tmp(301) := x"5" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(302) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(303) := x"1" & '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(304) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(305) := x"7" & '1' & x"40";	-- JEQ %incrementa_centena 	# Se for igual a 9, vai para o incrementa_centena
tmp(306) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(307) := x"5" & '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(308) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_dezena:
tmp(310) := x"4" & '0' & x"09";	-- LDI $9
tmp(311) := x"5" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(312) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(313) := x"1" & '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(314) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(315) := x"7" & '1' & x"4A";	-- JEQ %decremeta_centena 	# Se for igual a 0, vai para o decremeta_centena
tmp(316) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(317) := x"5" & '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(318) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena:
tmp(320) := x"4" & '0' & x"00";	-- LDI $0
tmp(321) := x"5" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(322) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(323) := x"1" & '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(324) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (centena) com o valor 9
tmp(325) := x"7" & '1' & x"54";	-- JEQ %incrementa_milhar 	# Se for igual a 9, vai para o incrementa_milhar
tmp(326) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(327) := x"5" & '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(328) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena:
tmp(330) := x"4" & '0' & x"09";	-- LDI $9
tmp(331) := x"5" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(332) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(333) := x"1" & '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(334) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (centena) com o valor 0
tmp(335) := x"7" & '1' & x"5E";	-- JEQ %decremeta_milhar 	# Se for igual a 0, vai para o decremeta_milhar
tmp(336) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(337) := x"5" & '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(338) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_milhar:
tmp(340) := x"4" & '0' & x"00";	-- LDI $0
tmp(341) := x"5" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(342) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(343) := x"1" & '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(344) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(345) := x"7" & '1' & x"68";	-- JEQ %incrementa_dezena_de_milhar 	# Se for igual a 9, vai para o incrementa_dezena_de_milhar
tmp(346) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(347) := x"5" & '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(348) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- decremeta_milhar:
tmp(350) := x"4" & '0' & x"09";	-- LDI $9
tmp(351) := x"5" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(352) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(353) := x"1" & '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(354) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(355) := x"7" & '1' & x"72";	-- JEQ %decremeta_dezena_de_milhar 	# Se for igual a 0, vai para o decremeta_dezena_de_milhar
tmp(356) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(357) := x"5" & '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(358) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- incrementa_dezena_de_milhar:
tmp(360) := x"4" & '0' & x"00";	-- LDI $0
tmp(361) := x"5" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(362) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(363) := x"1" & '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(364) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(365) := x"7" & '1' & x"7C";	-- JEQ %incrementa_centena_milhar 	# Se for igual a 9, vai para o incrementa_centena_milhar
tmp(366) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(367) := x"5" & '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(368) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_dezena_de_milhar:
tmp(370) := x"4" & '0' & x"09";	-- LDI $9
tmp(371) := x"5" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(372) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(373) := x"1" & '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(374) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(375) := x"7" & '1' & x"86";	-- JEQ %decremeta_centena_milhar 	# Se for igual a 0, vai para o decremeta_centena_milhar
tmp(376) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(377) := x"5" & '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(378) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena_milhar:
tmp(380) := x"4" & '0' & x"00";	-- LDI $0
tmp(381) := x"5" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(382) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(383) := x"1" & '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(384) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (centena) com o valor 9
tmp(385) := x"7" & '1' & x"9A";	-- JEQ %atualiza_displays 	# Se for igual a 9, vai para o atualiza_displays
tmp(386) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(387) := x"5" & '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(388) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena_milhar:
tmp(390) := x"4" & '0' & x"09";	-- LDI $9
tmp(391) := x"5" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(392) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(393) := x"1" & '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(394) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (centena) com o valor 0
tmp(395) := x"7" & '1' & x"90";	-- JEQ %zerou 	# Se for igual a 0, vai para o atualiza_displays
tmp(396) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(397) := x"5" & '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(398) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- zerou:
tmp(400) := x"4" & '0' & x"00";	-- LDI $0
tmp(401) := x"5" & '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(402) := x"5" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(403) := x"5" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(404) := x"5" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(405) := x"5" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(406) := x"5" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(407) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(408) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- atualiza_displays:
tmp(410) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(411) := x"5" & '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(412) := x"1" & '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(413) := x"5" & '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(414) := x"1" & '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(415) := x"5" & '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(416) := x"1" & '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(417) := x"5" & '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(418) := x"1" & '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(419) := x"5" & '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(420) := x"1" & '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(421) := x"5" & '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(422) := x"9" & '1' & x"B7";	-- JSR %verifica_centena_de_milhar 	# Vai para o label verifica_centena_de_milhar
tmp(423) := x"6" & '1' & x"01";	-- JMP %le_key 	# Vai para o label le_key
-- atualiza_displays_limites:
tmp(425) := x"1" & '0' & x"0A";	-- LDA @10 	# Carrega o acumulador com o Limites das unidades
tmp(426) := x"5" & '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(427) := x"1" & '0' & x"0B";	-- LDA @11 	# Carrega o acumulador com o Limites das dezenas
tmp(428) := x"5" & '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(429) := x"1" & '0' & x"0C";	-- LDA @12 	# Carrega o acumulador com o Limites de centena
tmp(430) := x"5" & '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(431) := x"1" & '0' & x"0D";	-- LDA @13 	# Carrega o acumulador com o Limites de milhar
tmp(432) := x"5" & '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(433) := x"1" & '0' & x"0E";	-- LDA @14 	# Carrega o acumulador com o Limites de dezena de milhar
tmp(434) := x"5" & '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(435) := x"1" & '0' & x"0F";	-- LDA @15 	# Carrega o acumulador com o Limites de centena de milhar
tmp(436) := x"5" & '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(437) := x"A" & '0' & x"00";	-- RET
-- verifica_centena_de_milhar:
tmp(439) := x"1" & '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(440) := x"8" & '0' & x"0F";	-- CEQ @15 	# Compara o valor do acumulador com o valor maximo de centena de milhar
tmp(441) := x"7" & '1' & x"BC";	-- JEQ %verifica_dezena_de_milhar 	# Se for igual, vai para o label verifica_dezena_de_milhar
tmp(442) := x"A" & '0' & x"00";	-- RET
-- verifica_dezena_de_milhar:
tmp(444) := x"1" & '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(445) := x"8" & '0' & x"0E";	-- CEQ @14 	# Compara o valor do acumulador com o valor maximo de dezena de milhar
tmp(446) := x"7" & '1' & x"C1";	-- JEQ %verifica_milhar 	# Se for igual, vai para o label verifica_milhar
tmp(447) := x"A" & '0' & x"00";	-- RET
-- verifica_milhar:
tmp(449) := x"1" & '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(450) := x"8" & '0' & x"0D";	-- CEQ @13 	# Compara o valor do acumulador com o valor maximo de milhar
tmp(451) := x"7" & '1' & x"C6";	-- JEQ %verifica_centena 	# Se for igual, vai para o label verifica_centena
tmp(452) := x"A" & '0' & x"00";	-- RET
-- verifica_centena:
tmp(454) := x"1" & '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(455) := x"8" & '0' & x"0C";	-- CEQ @12 	# Compara o valor do acumulador com o valor maximo de centena
tmp(456) := x"7" & '1' & x"CB";	-- JEQ %verifica_dezena 	# Se for igual, vai para o label verifica_dezena
tmp(457) := x"A" & '0' & x"00";	-- RET
-- verifica_dezena:
tmp(459) := x"1" & '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(460) := x"8" & '0' & x"0B";	-- CEQ @11 	# Compara o valor do acumulador com o valor maximo de dezena
tmp(461) := x"7" & '1' & x"D0";	-- JEQ %verifica_unidade 	# Se for igual, vai para o label verifica_unidade
tmp(462) := x"A" & '0' & x"00";	-- RET
-- verifica_unidade:
tmp(464) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(465) := x"8" & '0' & x"0A";	-- CEQ @10 	# Compara o valor do acumulador com o valor maximo de unidade
tmp(466) := x"7" & '1' & x"E4";	-- JEQ %final 	# Se for igual, vai para o label final
tmp(467) := x"A" & '0' & x"00";	-- RET
-- RESET_FPGA:
tmp(469) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(470) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(471) := x"5" & '1' & x"FD";	-- STA @509 	# Limpando reset_key
tmp(472) := x"4" & '0' & x"00";	-- LDI $0 	# Carregando 0 no acumulador
tmp(473) := x"5" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(474) := x"5" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(475) := x"5" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(476) := x"5" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(477) := x"5" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(478) := x"5" & '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(479) := x"5" & '1' & x"02";	-- STA @258 	# Desliga led 9
tmp(480) := x"5" & '1' & x"01";	-- STA @257 	# Desliga o led 8
tmp(481) := x"5" & '1' & x"00";	-- STA @256 	# Desliga o led 7 ao led 0
tmp(482) := x"6" & '1' & x"9A";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- final:
tmp(484) := x"1" & '0' & x"33";	-- LDA @51 	# Carrega 1 no acumulador
tmp(485) := x"5" & '1' & x"02";	-- STA @258 	# Liga led 9
tmp(486) := x"5" & '1' & x"01";	-- STA @257 	# Liga o led 8
tmp(487) := x"4" & '0' & x"FF";	-- LDI $255 	# Carrega 255 no acumulador
tmp(488) := x"5" & '1' & x"00";	-- STA @256 	# Liga o led 7 ao led 0
tmp(489) := x"1" & '1' & x"64";	-- LDA @356		# Carrega o acumulador com o endereço de fpga_reset
tmp(490) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(491) := x"7" & '1' & x"D5";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(492) := x"6" & '1' & x"E4";	-- JMP %final


        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;