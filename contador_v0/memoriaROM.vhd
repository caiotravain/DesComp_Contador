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
tmp(1) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(2) := x"5" & "00" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(3) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando segundos
tmp(4) := x"5" & "00" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(5) := x"5" & "00" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(6) := x"5" & "00" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(7) := x"5" & "00" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(8) := x"5" & "00" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(9) := x"5" & "00" & '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(10) := x"5" & "00" & '1' & x"20";	-- STA @288 	# Limpando endereço do HEX0
tmp(11) := x"5" & "00" & '1' & x"21";	-- STA @289 	# Limpando endereço do HEX1
tmp(12) := x"5" & "00" & '1' & x"22";	-- STA @290 	# Limpando endereço do HEX2
tmp(13) := x"5" & "00" & '1' & x"23";	-- STA @291 	# Limpando endereço do HEX3
tmp(14) := x"5" & "00" & '1' & x"24";	-- STA @292 	# Limpando endereço do HEX4
tmp(15) := x"5" & "00" & '1' & x"25";	-- STA @293 	# Limpando endereço do HEX5
tmp(16) := x"4" & "00" & '0' & x"02";	-- LDI $2 	# Carregando 2 no acumulador
tmp(17) := x"5" & "00" & '0' & x"34";	-- STA @52 	# Carregando 2 na posição 52
tmp(18) := x"4" & "00" & '0' & x"03";	-- LDI $3 	# Carregando 4 no acumulador
tmp(19) := x"5" & "00" & '0' & x"35";	-- STA @53 	# Carregando 4 na posição 53
tmp(20) := x"4" & "00" & '0' & x"05";	-- LDI $5 	# Carregando 5 no acumulador
tmp(21) := x"5" & "00" & '0' & x"37";	-- STA @55 	# Carregando 5 na posição 55
tmp(22) := x"4" & "00" & '0' & x"09";	-- LDI $9 	# Carregando 9 no acumulador
tmp(23) := x"5" & "00" & '0' & x"3B";	-- STA @59 	# Carregando 9 na posição 59
tmp(24) := x"4" & "00" & '0' & x"0A";	-- LDI $10 	# Carregando 10 no acumulador
tmp(25) := x"5" & "00" & '0' & x"3C";	-- STA @60 	# Carergando 10 na posição 60
tmp(26) := x"4" & "00" & '0' & x"01";	-- LDI $1 	# Carregando 1 no acumulador
tmp(27) := x"5" & "00" & '0' & x"33";	-- STA @51 	# Carregando 1 na posição 51
tmp(28) := x"4" & "00" & '0' & x"09";	-- LDI $9
tmp(29) := x"5" & "00" & '0' & x"0A";	-- STA @10 	# Limite das unidades
tmp(30) := x"5" & "00" & '0' & x"0C";	-- STA @12 	# Limite das centenas
tmp(31) := x"4" & "00" & '0' & x"06";	-- LDI $6 
tmp(32) := x"5" & "00" & '0' & x"0B";	-- STA @11 	# Limite das dezenas
tmp(33) := x"5" & "00" & '0' & x"0D";	-- STA @13 	# Limite dos milhares
tmp(34) := x"4" & "00" & '0' & x"04";	-- LDI $4 
tmp(35) := x"5" & "00" & '0' & x"0E";	-- STA @14 	# Limite das dezenas de milhares
tmp(36) := x"4" & "00" & '0' & x"02";	-- LDI $2
tmp(37) := x"5" & "00" & '0' & x"0F";	-- STA @15 	# Limite das centenas de milhares
tmp(38) := x"4" & "00" & '0' & x"63";	-- LDI $99 	# Carregando 99 no acumulador
tmp(39) := x"5" & "00" & '0' & x"1D";	-- STA @29 	# Carregando 100 na posição 29
tmp(40) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carregando 0 no acumulador
tmp(41) := x"5" & "00" & '1' & x"F4";	-- STA @500 	# Desligando o display 0
tmp(42) := x"5" & "00" & '0' & x"14";	-- STA @20 	#temporizador 1
tmp(43) := x"5" & "00" & '0' & x"15";	-- STA @21 	#temporizador 2
tmp(44) := x"5" & "00" & '0' & x"16";	-- STA @22 	#temporizador 3
tmp(45) := x"5" & "00" & '0' & x"17";	-- STA @23 	# PISCA OU NÃO PISCA
tmp(46) := x"6" & "00" & '1' & x"0A";	-- JMP %le_key 	# Vai para o label le_key
-- temporizador_1_segundo:
tmp(48) := x"1" & "00" & '0' & x"14";	-- LDA @20 	# Carrega o acumulador com o endereço de temporizador 1
tmp(49) := x"8" & "00" & '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(50) := x"7" & "00" & '0' & x"37";	-- JEQ %temporizador_2_segundo 	# Se for igual, vai para o label temporizador_2_segundo
tmp(51) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(52) := x"5" & "00" & '0' & x"14";	-- STA @20 	# Armazena o valor do acumulador no endereço de temporizador 1
tmp(53) := x"A" & "00" & '0' & x"00";	-- RET
-- temporizador_2_segundo:
tmp(55) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(56) := x"5" & "00" & '0' & x"14";	-- STA @20 	# Armazena o valor do acumulador no endereço de temporizador 1
tmp(57) := x"1" & "00" & '0' & x"15";	-- LDA @21 	# Carrega o acumulador com o endereço de temporizador 2
tmp(58) := x"8" & "00" & '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(59) := x"7" & "00" & '0' & x"40";	-- JEQ %temporizador_3_segundo 	# Se for igual, vai para o label temporizador_3_segundo
tmp(60) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(61) := x"5" & "00" & '0' & x"15";	-- STA @21 	# Armazena o valor do acumulador no endereço de temporizador 2
tmp(62) := x"A" & "00" & '0' & x"00";	-- RET
-- temporizador_3_segundo:
tmp(64) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(65) := x"5" & "00" & '0' & x"15";	-- STA @21 	# Armazena o valor do acumulador no endereço de temporizador 2
tmp(66) := x"1" & "00" & '0' & x"16";	-- LDA @22 	# Carrega o acumulador com o endereço de temporizador 3
tmp(67) := x"8" & "00" & '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(68) := x"7" & "00" & '0' & x"49";	-- JEQ %PISCA 	# Se for igual, vai para o label LIMPA
tmp(69) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(70) := x"5" & "00" & '0' & x"16";	-- STA @22 	# Armazena o valor do acumulador no endereço de temporizador 3
tmp(71) := x"A" & "00" & '0' & x"00";	-- RET
-- PISCA:
tmp(73) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(74) := x"5" & "00" & '0' & x"16";	-- STA @22 	# Limpando temporizador 3
tmp(75) := x"1" & "00" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(76) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(77) := x"7" & "00" & '0' & x"52";	-- JEQ %LIMPA 	# Se for igual, vai para o label LIMPA
tmp(78) := x"4" & "00" & '0' & x"01";	-- LDI $1 	# Carrega 1 no acumulador
tmp(79) := x"5" & "00" & '0' & x"17";	-- STA @23 	# Armazena o valor do acumulador no endereço de PISCA
tmp(80) := x"A" & "00" & '0' & x"00";	-- RET
-- LIMPA:
tmp(82) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(83) := x"5" & "00" & '0' & x"17";	-- STA @23 	# Armazena o valor do acumulador no endereço de PISCA
tmp(84) := x"A" & "00" & '0' & x"00";	-- RET
-- define_limites_unidades:
tmp(86) := x"5" & "00" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(87) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(88) := x"9" & "00" & '1' & x"B3";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_unidades:
tmp(90) := x"9" & "00" & '0' & x"30";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(91) := x"1" & "00" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(92) := x"5" & "00" & '1' & x"F4";	-- STA @500 	# Desliga o display unidade
tmp(93) := x"1" & "00" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(94) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(95) := x"7" & "00" & '0' & x"72";	-- JEQ %define_limites_dezenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(96) := x"1" & "00" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(97) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(98) := x"7" & "00" & '0' & x"5A";	-- JEQ %checa_limites_unidades 	# Se for igual, vai para o label checa_limites_unidades
tmp(99) := x"9" & "00" & '0' & x"66";	-- JSR %adiciona_unidade 	# Se não for igual, vai para o label adiciona_unidade
tmp(100) := x"6" & "00" & '0' & x"56";	-- JMP %define_limites_unidades 	# Se não for igual, volta para o label define_limites_unidades
-- adiciona_unidade:
tmp(102) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(103) := x"1" & "00" & '0' & x"0A";	-- LDA @10 	# Carrega o acumulador com o endereço de Limite de unidade
tmp(104) := x"8" & "00" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(105) := x"7" & "00" & '0' & x"6E";	-- JEQ %zera_unidade 	# Se for igual, vai para o label zera_unidade
tmp(106) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(107) := x"5" & "00" & '0' & x"0A";	-- STA @10 	# Armazena o valor do acumulador no endereço de Limite de unidade
tmp(108) := x"A" & "00" & '0' & x"00";	-- RET 
-- zera_unidade:
tmp(110) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(111) := x"5" & "00" & '0' & x"0A";	-- STA @10 	# Armazena o valor do acumulador no endereço de Limite de unidade
tmp(112) := x"A" & "00" & '0' & x"00";	-- RET
-- define_limites_dezenas:
tmp(114) := x"5" & "00" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(115) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(116) := x"9" & "00" & '1' & x"B3";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas:
tmp(118) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(119) := x"5" & "00" & '1' & x"F4";	-- STA @500 	# liga o display unidade
tmp(120) := x"9" & "00" & '0' & x"30";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(121) := x"1" & "00" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(122) := x"5" & "00" & '1' & x"F5";	-- STA @501 	# Desliga o display unidade
tmp(123) := x"1" & "00" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(124) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(125) := x"7" & "00" & '0' & x"8F";	-- JEQ %define_limites_centenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(126) := x"1" & "00" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(127) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(128) := x"7" & "00" & '0' & x"76";	-- JEQ %checa_limites_dezenas 	# Se for igual, vai para o label checa_limites_dezenas
tmp(129) := x"9" & "00" & '0' & x"85";	-- JSR %adiciona_dezena 	# Se não for igual, vai para o label adiciona_dezena
tmp(130) := x"5" & "00" & '0' & x"0B";	-- STA @11 	# Armazena o valor do acumulador no endereço de Limite de dezenas
tmp(131) := x"6" & "00" & '0' & x"72";	-- JMP %define_limites_dezenas 	# Se não for igual, volta para o label define_limites_dezenas
-- adiciona_dezena:
tmp(133) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(134) := x"1" & "00" & '0' & x"0B";	-- LDA @11 	# Carrega o acumulador com o endereço de Limite de dezena
tmp(135) := x"8" & "00" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(136) := x"7" & "00" & '0' & x"8C";	-- JEQ %zera_dezena 	# Se for igual, vai para o label zera_dezena
tmp(137) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(138) := x"A" & "00" & '0' & x"00";	-- RET 
-- zera_dezena:
tmp(140) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(141) := x"A" & "00" & '0' & x"00";	-- RET
-- define_limites_centenas:
tmp(143) := x"5" & "00" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(144) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(145) := x"9" & "00" & '1' & x"B3";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas:
tmp(147) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(148) := x"5" & "00" & '1' & x"F5";	-- STA @501 	# liga o display unidade
tmp(149) := x"9" & "00" & '0' & x"30";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(150) := x"1" & "00" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(151) := x"5" & "00" & '1' & x"F6";	-- STA @502 	# Desliga o display unidade
tmp(152) := x"1" & "00" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(153) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(154) := x"7" & "00" & '0' & x"AC";	-- JEQ %define_limites_milhares 	# Se for igual, vai para o label define_limites_centenas
tmp(155) := x"1" & "00" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(156) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(157) := x"7" & "00" & '0' & x"93";	-- JEQ %checa_limites_centenas 	# Se for igual, vai para o label checa_limites_centenas
tmp(158) := x"9" & "00" & '0' & x"A2";	-- JSR %adiciona_centena 	# Se não for igual, vai para o label adiciona_centena
tmp(159) := x"5" & "00" & '0' & x"0C";	-- STA @12 	# Armazena o valor do acumulador no endereço de Limite de centenas
tmp(160) := x"6" & "00" & '0' & x"8F";	-- JMP %define_limites_centenas 	# Se não for igual, volta para o label define_limites_centenas
-- adiciona_centena:
tmp(162) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(163) := x"1" & "00" & '0' & x"0C";	-- LDA @12 	# Carrega o acumulador com o endereço de Limite de centena
tmp(164) := x"8" & "00" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(165) := x"7" & "00" & '0' & x"A9";	-- JEQ %zera_centena 	# Se for igual, vai para o label zera_centena
tmp(166) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(167) := x"A" & "00" & '0' & x"00";	-- RET
-- zera_centena:
tmp(169) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(170) := x"A" & "00" & '0' & x"00";	-- RET
-- define_limites_milhares:
tmp(172) := x"5" & "00" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(173) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(174) := x"9" & "00" & '1' & x"B3";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_milhares:
tmp(176) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(177) := x"5" & "00" & '1' & x"F6";	-- STA @502 	# liga o display unidade
tmp(178) := x"9" & "00" & '0' & x"30";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(179) := x"1" & "00" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(180) := x"5" & "00" & '1' & x"F7";	-- STA @503 	# Desliga o display unidade
tmp(181) := x"1" & "00" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(182) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(183) := x"7" & "00" & '0' & x"C9";	-- JEQ %define_limites_dezenas_de_milhares 	# Se for igual, vai para o label define_limites_milhares
tmp(184) := x"1" & "00" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(185) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(186) := x"7" & "00" & '0' & x"B0";	-- JEQ %checa_limites_milhares 	# Se for igual, vai para o label checa_limites_milhares
tmp(187) := x"9" & "00" & '0' & x"BF";	-- JSR %adiciona_milhar 	# Se não for igual, vai para o label adiciona_milhar
tmp(188) := x"5" & "00" & '0' & x"0D";	-- STA @13 	# Armazena o valor do acumulador no endereço de Limite de milhares
tmp(189) := x"6" & "00" & '0' & x"AC";	-- JMP %define_limites_milhares 	# Se não for igual, volta para o label define_limites_milhares
-- adiciona_milhar:
tmp(191) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(192) := x"1" & "00" & '0' & x"0D";	-- LDA @13 	# Carrega o acumulador com o endereço de Limite de milhar
tmp(193) := x"8" & "00" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(194) := x"7" & "00" & '0' & x"C6";	-- JEQ %zera_milhar 	# Se for igual, vai para o label zera_milhar
tmp(195) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(196) := x"A" & "00" & '0' & x"00";	-- RET
-- zera_milhar:
tmp(198) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(199) := x"A" & "00" & '0' & x"00";	-- RET
-- define_limites_dezenas_de_milhares:
tmp(201) := x"5" & "00" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(202) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(203) := x"9" & "00" & '1' & x"B3";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas_de_milhares:
tmp(205) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(206) := x"5" & "00" & '1' & x"F7";	-- STA @503 	# liga o display unidade
tmp(207) := x"9" & "00" & '0' & x"30";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(208) := x"1" & "00" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(209) := x"5" & "00" & '1' & x"F8";	-- STA @504 	# Desliga o display unidade
tmp(210) := x"1" & "00" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(211) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(212) := x"7" & "00" & '0' & x"E6";	-- JEQ %define_limites_centenas_de_milhares 	# Se for igual, vai para o label define_limites_dezenas_de_milhares
tmp(213) := x"1" & "00" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(214) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(215) := x"7" & "00" & '0' & x"CD";	-- JEQ %checa_limites_dezenas_de_milhares 	# Se for igual, vai para o label checa_limites_dezenas_de_milhares
tmp(216) := x"9" & "00" & '0' & x"DC";	-- JSR %adiciona_dezena_de_milhar 	# Se não for igual, vai para o label adiciona_dezena_de_milhar
tmp(217) := x"5" & "00" & '0' & x"0E";	-- STA @14 	# Armazena o valor do acumulador no endereço de Limite de dezenas de milhares
tmp(218) := x"6" & "00" & '0' & x"C9";	-- JMP %define_limites_dezenas_de_milhares 	# Se não for igual, volta para o label define_limites_dezenas_de_milhares
-- adiciona_dezena_de_milhar:
tmp(220) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(221) := x"1" & "00" & '0' & x"0E";	-- LDA @14 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(222) := x"8" & "00" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(223) := x"7" & "00" & '0' & x"E3";	-- JEQ %zera_dezena_de_milhar 	# Se for igual, vai para o label zera_dezena_de_milhar
tmp(224) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(225) := x"A" & "00" & '0' & x"00";	-- RET
-- zera_dezena_de_milhar:
tmp(227) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(228) := x"A" & "00" & '0' & x"00";	-- RET
-- define_limites_centenas_de_milhares:
tmp(230) := x"5" & "00" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(231) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(232) := x"9" & "00" & '1' & x"B3";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas_de_milhares:
tmp(234) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(235) := x"5" & "00" & '1' & x"F8";	-- STA @504 	# liga o display unidade
tmp(236) := x"9" & "00" & '0' & x"30";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(237) := x"1" & "00" & '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(238) := x"5" & "00" & '1' & x"F9";	-- STA @505 	# Desliga o display unidade
tmp(239) := x"1" & "00" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(240) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(241) := x"7" & "00" & '1' & x"03";	-- JEQ %pre_le_key 	# Se for igual, vai para o label pre_le_key
tmp(242) := x"1" & "00" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(243) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(244) := x"7" & "00" & '0' & x"EA";	-- JEQ %checa_limites_centenas_de_milhares 	# Se for igual, vai para o label checa_limites_centenas_de_milhares
tmp(245) := x"9" & "00" & '0' & x"F9";	-- JSR %adiciona_centena_de_milhar 	# Se não for igual, vai para o label adiciona_centena_de_milhar
tmp(246) := x"5" & "00" & '0' & x"0F";	-- STA @15 	# Armazena o valor do acumulador no endereço de Limite de centenas de milhares
tmp(247) := x"6" & "00" & '0' & x"E6";	-- JMP %define_limites_centenas_de_milhares 	# Se não for igual, volta para o label define_limites_centenas_de_milhares
-- adiciona_centena_de_milhar:
tmp(249) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(250) := x"1" & "00" & '0' & x"0F";	-- LDA @15 	# Carrega o acumulador com o endereço de Limite de centena de milhar
tmp(251) := x"8" & "00" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(252) := x"7" & "00" & '1' & x"00";	-- JEQ %zera_centena_de_milhar 	# Se for igual, vai para o label zera_centena_de_milhar
tmp(253) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(254) := x"A" & "00" & '0' & x"00";	-- RET
-- zera_centena_de_milhar:
tmp(256) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(257) := x"A" & "00" & '0' & x"00";	-- RET
-- pre_le_key:
tmp(259) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(260) := x"5" & "00" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(261) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega 1 no acumulador
tmp(262) := x"5" & "00" & '1' & x"F9";	-- STA @505 	# Liga o display 0
tmp(263) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays
tmp(264) := x"6" & "00" & '1' & x"0A";	-- JMP %le_key 	# Vai para o label le_key
-- le_key:
tmp(266) := x"1" & "00" & '1' & x"65";	-- LDA @357 	# Carrega o acumulador com o segundos
tmp(267) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(268) := x"7" & "00" & '1' & x"21";	-- JEQ %incrementa_unidade 	# Se for igual, vai para o label incrementa
tmp(269) := x"1" & "00" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(270) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(271) := x"7" & "00" & '0' & x"56";	-- JEQ %define_limites_unidades 	# Se for igual, vai para o label incrementa
tmp(272) := x"9" & "00" & '1' & x"16";	-- JSR %checa_op 	# checa se é + ou -
tmp(273) := x"1" & "00" & '1' & x"64";	-- LDA @356		# Carrega o acumulador com o endereço de fpga_reset
tmp(274) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(275) := x"7" & "00" & '1' & x"DF";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(276) := x"6" & "00" & '1' & x"0A";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- checa_op:
tmp(278) := x"1" & "00" & '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(279) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(280) := x"7" & "00" & '1' & x"1D";	-- JEQ %mais 	# Se for igual, vai para o label le_key
tmp(281) := x"4" & "00" & '0' & x"01";	-- LDI $1 	# Carrega o acumulador com o valor 1
tmp(282) := x"5" & "00" & '1' & x"02";	-- STA @258 	# Liga led 9
tmp(283) := x"A" & "00" & '0' & x"00";	-- RET
-- mais:
tmp(285) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(286) := x"5" & "00" & '1' & x"02";	-- STA @258 	# Liga led 9
tmp(287) := x"A" & "00" & '0' & x"00";	-- RET
-- incrementa_unidade:
tmp(289) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando key 0
tmp(290) := x"1" & "00" & '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(291) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(292) := x"7" & "00" & '1' & x"2E";	-- JEQ %sub_unidade 	# Se for igual, vai para o label sub_unidade
tmp(293) := x"1" & "00" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(294) := x"8" & "00" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(295) := x"7" & "00" & '1' & x"35";	-- JEQ %incrementa_dezena 	# Se for igual, vai para o label incrementa_dezena
tmp(296) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(297) := x"5" & "00" & '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(298) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(299) := x"5" & "00" & '1' & x"02";	-- STA @258 	# Desliga led 9
tmp(300) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- sub_unidade:
tmp(302) := x"1" & "00" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(303) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(304) := x"7" & "00" & '1' & x"3F";	-- JEQ %decremeta_dezena 	# Se for igual, vai para o label decremeta_dezena
tmp(305) := x"3" & "00" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(306) := x"5" & "00" & '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(307) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- incrementa_dezena:
tmp(309) := x"4" & "00" & '0' & x"00";	-- LDI $0
tmp(310) := x"5" & "00" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(311) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(312) := x"1" & "00" & '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(313) := x"8" & "00" & '0' & x"37";	-- CEQ @55 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(314) := x"7" & "00" & '1' & x"49";	-- JEQ %incrementa_centena 	# Se for igual a 9, vai para o incrementa_centena
tmp(315) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(316) := x"5" & "00" & '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(317) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_dezena:
tmp(319) := x"4" & "00" & '0' & x"09";	-- LDI $9
tmp(320) := x"5" & "00" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(321) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(322) := x"1" & "00" & '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(323) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(324) := x"7" & "00" & '1' & x"53";	-- JEQ %decremeta_centena 	# Se for igual a 0, vai para o decremeta_centena
tmp(325) := x"3" & "00" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(326) := x"5" & "00" & '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(327) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena:
tmp(329) := x"4" & "00" & '0' & x"00";	-- LDI $0
tmp(330) := x"5" & "00" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(331) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(332) := x"1" & "00" & '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(333) := x"8" & "00" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (centena) com o valor 9
tmp(334) := x"7" & "00" & '1' & x"5D";	-- JEQ %incrementa_milhar 	# Se for igual a 9, vai para o incrementa_milhar
tmp(335) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(336) := x"5" & "00" & '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(337) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena:
tmp(339) := x"4" & "00" & '0' & x"05";	-- LDI $5
tmp(340) := x"5" & "00" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(341) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(342) := x"1" & "00" & '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(343) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (centena) com o valor 0
tmp(344) := x"7" & "00" & '1' & x"67";	-- JEQ %decremeta_milhar 	# Se for igual a 0, vai para o decremeta_milhar
tmp(345) := x"3" & "00" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(346) := x"5" & "00" & '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(347) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_milhar:
tmp(349) := x"4" & "00" & '0' & x"00";	-- LDI $0
tmp(350) := x"5" & "00" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(351) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(352) := x"1" & "00" & '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(353) := x"8" & "00" & '0' & x"37";	-- CEQ @55 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(354) := x"7" & "00" & '1' & x"71";	-- JEQ %incrementa_dezena_de_milhar 	# Se for igual a 9, vai para o incrementa_dezena_de_milhar
tmp(355) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(356) := x"5" & "00" & '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(357) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- decremeta_milhar:
tmp(359) := x"4" & "00" & '0' & x"09";	-- LDI $9
tmp(360) := x"5" & "00" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(361) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(362) := x"1" & "00" & '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(363) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(364) := x"7" & "00" & '1' & x"7B";	-- JEQ %decremeta_dezena_de_milhar 	# Se for igual a 0, vai para o decremeta_dezena_de_milhar
tmp(365) := x"3" & "00" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(366) := x"5" & "00" & '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(367) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- incrementa_dezena_de_milhar:
tmp(369) := x"4" & "00" & '0' & x"00";	-- LDI $0
tmp(370) := x"5" & "00" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(371) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(372) := x"1" & "00" & '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(373) := x"8" & "00" & '0' & x"35";	-- CEQ @53 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(374) := x"7" & "00" & '1' & x"85";	-- JEQ %incrementa_centena_milhar 	# Se for igual a 9, vai para o incrementa_centena_milhar
tmp(375) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(376) := x"5" & "00" & '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(377) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_dezena_de_milhar:
tmp(379) := x"4" & "00" & '0' & x"05";	-- LDI $5
tmp(380) := x"5" & "00" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(381) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(382) := x"1" & "00" & '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(383) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(384) := x"7" & "00" & '1' & x"8F";	-- JEQ %decremeta_centena_milhar 	# Se for igual a 0, vai para o decremeta_centena_milhar
tmp(385) := x"3" & "00" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(386) := x"5" & "00" & '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(387) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena_milhar:
tmp(389) := x"4" & "00" & '0' & x"00";	-- LDI $0
tmp(390) := x"5" & "00" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(391) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(392) := x"1" & "00" & '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(393) := x"8" & "00" & '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador (centena) com o valor 9
tmp(394) := x"7" & "00" & '1' & x"A4";	-- JEQ %atualiza_displays 	# Se for igual a 9, vai para o atualiza_displays
tmp(395) := x"2" & "00" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(396) := x"5" & "00" & '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(397) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena_milhar:
tmp(399) := x"4" & "00" & '0' & x"03";	-- LDI $3
tmp(400) := x"5" & "00" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(401) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(402) := x"1" & "00" & '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(403) := x"8" & "00" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (centena) com o valor 0
tmp(404) := x"7" & "00" & '1' & x"99";	-- JEQ %zerou 	# Se for igual a 0, vai para o atualiza_displays
tmp(405) := x"3" & "00" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(406) := x"5" & "00" & '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(407) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- zerou:
tmp(409) := x"4" & "00" & '0' & x"00";	-- LDI $0
tmp(410) := x"5" & "00" & '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(411) := x"5" & "00" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(412) := x"5" & "00" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(413) := x"5" & "00" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(414) := x"5" & "00" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(415) := x"5" & "00" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(416) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando Key 0
tmp(417) := x"5" & "00" & '1' & x"FE";	-- STA @510 	# Limpando Key 1
tmp(418) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- atualiza_displays:
tmp(420) := x"1" & "00" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(421) := x"5" & "00" & '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(422) := x"1" & "00" & '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(423) := x"5" & "00" & '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(424) := x"1" & "00" & '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(425) := x"5" & "00" & '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(426) := x"1" & "00" & '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(427) := x"5" & "00" & '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(428) := x"1" & "00" & '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(429) := x"5" & "00" & '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(430) := x"1" & "00" & '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(431) := x"5" & "00" & '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(432) := x"9" & "00" & '1' & x"C1";	-- JSR %verifica_centena_de_milhar 	# Vai para o label verifica_centena_de_milhar
tmp(433) := x"6" & "00" & '1' & x"0A";	-- JMP %le_key 	# Vai para o label le_key
-- atualiza_displays_limites:
tmp(435) := x"1" & "00" & '0' & x"0A";	-- LDA @10 	# Carrega o acumulador com o Limites das unidades
tmp(436) := x"5" & "00" & '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(437) := x"1" & "00" & '0' & x"0B";	-- LDA @11 	# Carrega o acumulador com o Limites das dezenas
tmp(438) := x"5" & "00" & '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(439) := x"1" & "00" & '0' & x"0C";	-- LDA @12 	# Carrega o acumulador com o Limites de centena
tmp(440) := x"5" & "00" & '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(441) := x"1" & "00" & '0' & x"0D";	-- LDA @13 	# Carrega o acumulador com o Limites de milhar
tmp(442) := x"5" & "00" & '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(443) := x"1" & "00" & '0' & x"0E";	-- LDA @14 	# Carrega o acumulador com o Limites de dezena de milhar
tmp(444) := x"5" & "00" & '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(445) := x"1" & "00" & '0' & x"0F";	-- LDA @15 	# Carrega o acumulador com o Limites de centena de milhar
tmp(446) := x"5" & "00" & '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(447) := x"A" & "00" & '0' & x"00";	-- RET
-- verifica_centena_de_milhar:
tmp(449) := x"1" & "00" & '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(450) := x"8" & "00" & '0' & x"0F";	-- CEQ @15 	# Compara o valor do acumulador com o valor maximo de centena de milhar
tmp(451) := x"7" & "00" & '1' & x"C6";	-- JEQ %verifica_dezena_de_milhar 	# Se for igual, vai para o label verifica_dezena_de_milhar
tmp(452) := x"A" & "00" & '0' & x"00";	-- RET
-- verifica_dezena_de_milhar:
tmp(454) := x"1" & "00" & '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(455) := x"8" & "00" & '0' & x"0E";	-- CEQ @14 	# Compara o valor do acumulador com o valor maximo de dezena de milhar
tmp(456) := x"7" & "00" & '1' & x"CB";	-- JEQ %verifica_milhar 	# Se for igual, vai para o label verifica_milhar
tmp(457) := x"A" & "00" & '0' & x"00";	-- RET
-- verifica_milhar:
tmp(459) := x"1" & "00" & '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(460) := x"8" & "00" & '0' & x"0D";	-- CEQ @13 	# Compara o valor do acumulador com o valor maximo de milhar
tmp(461) := x"7" & "00" & '1' & x"D0";	-- JEQ %verifica_centena 	# Se for igual, vai para o label verifica_centena
tmp(462) := x"A" & "00" & '0' & x"00";	-- RET
-- verifica_centena:
tmp(464) := x"1" & "00" & '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(465) := x"8" & "00" & '0' & x"0C";	-- CEQ @12 	# Compara o valor do acumulador com o valor maximo de centena
tmp(466) := x"7" & "00" & '1' & x"D5";	-- JEQ %verifica_dezena 	# Se for igual, vai para o label verifica_dezena
tmp(467) := x"A" & "00" & '0' & x"00";	-- RET
-- verifica_dezena:
tmp(469) := x"1" & "00" & '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(470) := x"8" & "00" & '0' & x"0B";	-- CEQ @11 	# Compara o valor do acumulador com o valor maximo de dezena
tmp(471) := x"7" & "00" & '1' & x"DA";	-- JEQ %verifica_unidade 	# Se for igual, vai para o label verifica_unidade
tmp(472) := x"A" & "00" & '0' & x"00";	-- RET
-- verifica_unidade:
tmp(474) := x"1" & "00" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(475) := x"8" & "00" & '0' & x"0A";	-- CEQ @10 	# Compara o valor do acumulador com o valor maximo de unidade
tmp(476) := x"7" & "00" & '1' & x"EE";	-- JEQ %final 	# Se for igual, vai para o label final
tmp(477) := x"A" & "00" & '0' & x"00";	-- RET
-- RESET_FPGA:
tmp(479) := x"5" & "00" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(480) := x"5" & "00" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(481) := x"5" & "00" & '1' & x"FD";	-- STA @509 	# Limpando reset_key
tmp(482) := x"4" & "00" & '0' & x"00";	-- LDI $0 	# Carregando 0 no acumulador
tmp(483) := x"5" & "00" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(484) := x"5" & "00" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(485) := x"5" & "00" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(486) := x"5" & "00" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(487) := x"5" & "00" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(488) := x"5" & "00" & '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(489) := x"5" & "00" & '1' & x"02";	-- STA @258 	# Desliga led 9
tmp(490) := x"5" & "00" & '1' & x"01";	-- STA @257 	# Desliga o led 8
tmp(491) := x"5" & "00" & '1' & x"00";	-- STA @256 	# Desliga o led 7 ao led 0
tmp(492) := x"6" & "00" & '1' & x"A4";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- final:
tmp(494) := x"1" & "00" & '0' & x"33";	-- LDA @51 	# Carrega 1 no acumulador
tmp(495) := x"5" & "00" & '1' & x"02";	-- STA @258 	# Liga led 9
tmp(496) := x"5" & "00" & '1' & x"01";	-- STA @257 	# Liga o led 8
tmp(497) := x"4" & "00" & '0' & x"FF";	-- LDI $255 	# Carrega 255 no acumulador
tmp(498) := x"5" & "00" & '1' & x"00";	-- STA @256 	# Liga o led 7 ao led 0
tmp(499) := x"1" & "00" & '1' & x"64";	-- LDA @356		# Carrega o acumulador com o endereço de fpga_reset
tmp(500) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(501) := x"7" & "00" & '1' & x"DF";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(502) := x"1" & "00" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(503) := x"8" & "00" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(504) := x"7" & "00" & '0' & x"56";	-- JEQ %define_limites_unidades 	# Se for igual, vai para o label incrementa
tmp(505) := x"6" & "00" & '1' & x"EE";	-- JMP %final




        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;