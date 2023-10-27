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
tmp(16) := x"5" & "00" & '1' & '1' & x"FF";	-- STA @1023 	# Limpando endereço do BUZZER
tmp(17) := x"4" & "00" & '0'& '0' & x"02";	-- LDI $2 	# Carregando 2 no acumulador
tmp(18) := x"5" & "00" & '0'& '0' & x"34";	-- STA @52 	# Carregando 2 na posição 52
tmp(19) := x"4" & "00" & '0'& '0' & x"03";	-- LDI $3 	# Carregando 4 no acumulador
tmp(20) := x"5" & "00" & '0'& '0' & x"35";	-- STA @53 	# Carregando 4 na posição 53
tmp(21) := x"4" & "00" & '0'& '0' & x"04";	-- LDI $4 	# Carregando 4 no acumulador
tmp(22) := x"5" & "00" & '0'& '0' & x"36";	-- STA @54 	# Carregando 4 na posição 54
tmp(23) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5 	# Carregando 5 no acumulador
tmp(24) := x"5" & "00" & '0'& '0' & x"37";	-- STA @55 	# Carregando 5 na posição 55
tmp(25) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9 	# Carregando 9 no acumulador
tmp(26) := x"5" & "00" & '0'& '0' & x"3B";	-- STA @59 	# Carregando 9 na posição 59
tmp(27) := x"4" & "00" & '0'& '0' & x"0A";	-- LDI $10 	# Carregando 10 no acumulador
tmp(28) := x"5" & "00" & '0'& '0' & x"3C";	-- STA @60 	# Carergando 10 na posição 60
tmp(29) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1 	# Carregando 1 no acumulador
tmp(30) := x"5" & "00" & '0'& '0' & x"33";	-- STA @51 	# Carregando 1 na posição 51
tmp(31) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9
tmp(32) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40 	# Limpando endereço de temp 1
tmp(33) := x"5" & "00" & '0'& '0' & x"0A";	-- STA @10 	# Limite das unidades
tmp(34) := x"5" & "00" & '0'& '0' & x"0C";	-- STA @12 	# Limite das centenas
tmp(35) := x"5" & "00" & '0'& '0' & x"2A";	-- STA @42 	# Limpando endereço de temp 3
tmp(36) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5 
tmp(37) := x"5" & "00" & '0'& '0' & x"0B";	-- STA @11 	# Limite das dezenas
tmp(38) := x"5" & "00" & '0'& '0' & x"29";	-- STA @41 	# Limpando endereço de temp 2
tmp(39) := x"5" & "00" & '0'& '0' & x"0D";	-- STA @13 	# Limite dos milhares
tmp(40) := x"5" & "00" & '0'& '0' & x"2B";	-- STA @43 	# Limpando endereço de temp 4
tmp(41) := x"4" & "00" & '0'& '0' & x"03";	-- LDI $3 
tmp(42) := x"5" & "00" & '0'& '0' & x"0E";	-- STA @14 	# Limite das dezenas de milhares
tmp(43) := x"5" & "00" & '0'& '0' & x"2C";	-- STA @44 	# Limpando endereço de temp 5
tmp(44) := x"4" & "00" & '0'& '0' & x"02";	-- LDI $2
tmp(45) := x"5" & "00" & '0'& '0' & x"0F";	-- STA @15 	# Limite das centenas de milhares
tmp(46) := x"5" & "00" & '0'& '0' & x"2D";	-- STA @45 	# Limpando endereço de temp 6
tmp(47) := x"4" & "00" & '0'& '0' & x"63";	-- LDI $99 	# Carregando 99 no acumulador
tmp(48) := x"5" & "00" & '0'& '0' & x"1D";	-- STA @29 	# Carregando 100 na posição 29
tmp(49) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carregando 0 no acumulador
tmp(50) := x"5" & "00" & '0'& '1' & x"F4";	-- STA @500 	# Desligando o display 0
tmp(51) := x"5" & "00" & '0'& '0' & x"14";	-- STA @20 	#temporizador 1
tmp(52) := x"5" & "00" & '0'& '0' & x"15";	-- STA @21 	#temporizador 2
tmp(53) := x"5" & "00" & '0'& '0' & x"16";	-- STA @22 	#temporizador 3
tmp(54) := x"5" & "00" & '0'& '0' & x"17";	-- STA @23 	# PISCA OU NÃO PISCA
tmp(55) := x"6" & "00"& '0' & '1' & x"6E";	-- JMP %le_key 	# Vai para o label le_key
-- temporizador_1_segundo:
tmp(57) := x"1" & "00" & '0'& '0' & x"14";	-- LDA @20 	# Carrega o acumulador com o endereço de temporizador 1
tmp(58) := x"8" & "00" & '0'& '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(59) := x"7" & "00" & '0' & '0' & x"40";	-- JEQ %temporizador_2_segundo 	# Se for igual, vai para o label temporizador_2_segundo
tmp(60) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(61) := x"5" & "00" & '0'& '0' & x"14";	-- STA @20 	# Armazena o valor do acumulador no endereço de temporizador 1
tmp(62) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- temporizador_2_segundo:
tmp(64) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(65) := x"5" & "00" & '0'& '0' & x"14";	-- STA @20 	# Armazena o valor do acumulador no endereço de temporizador 1
tmp(66) := x"1" & "00" & '0'& '0' & x"15";	-- LDA @21 	# Carrega o acumulador com o endereço de temporizador 2
tmp(67) := x"8" & "00" & '0'& '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(68) := x"7" & "00" & '0' & '0' & x"49";	-- JEQ %temporizador_3_segundo 	# Se for igual, vai para o label temporizador_3_segundo
tmp(69) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(70) := x"5" & "00" & '0'& '0' & x"15";	-- STA @21 	# Armazena o valor do acumulador no endereço de temporizador 2
tmp(71) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- temporizador_3_segundo:
tmp(73) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(74) := x"5" & "00" & '0'& '0' & x"15";	-- STA @21 	# Armazena o valor do acumulador no endereço de temporizador 2
tmp(75) := x"1" & "00" & '0'& '0' & x"16";	-- LDA @22 	# Carrega o acumulador com o endereço de temporizador 3
tmp(76) := x"8" & "00" & '0'& '0' & x"1D";	-- CEQ @29 	# Compara o valor do acumulador com o valor 99
tmp(77) := x"7" & "00" & '0' & '0' & x"52";	-- JEQ %PISCA 	# Se for igual, vai para o label LIMPA
tmp(78) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(79) := x"5" & "00" & '0'& '0' & x"16";	-- STA @22 	# Armazena o valor do acumulador no endereço de temporizador 3
tmp(80) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- PISCA:
tmp(82) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(83) := x"5" & "00" & '0'& '0' & x"16";	-- STA @22 	# Limpando temporizador 3
tmp(84) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(85) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(86) := x"7" & "00" & '0' & '0' & x"5B";	-- JEQ %LIMPA 	# Se for igual, vai para o label LIMPA
tmp(87) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1 	# Carrega 1 no acumulador
tmp(88) := x"5" & "00" & '0'& '0' & x"17";	-- STA @23 	# Armazena o valor do acumulador no endereço de PISCA
tmp(89) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- LIMPA:
tmp(91) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(92) := x"5" & "00" & '0'& '0' & x"17";	-- STA @23 	# Armazena o valor do acumulador no endereço de PISCA
tmp(93) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_unidades:
tmp(95) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(96) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(97) := x"9" & "00" & '1' & '0' & x"37";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_unidades:
tmp(99) := x"9" & "00" & '0' & '0' & x"39";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(100) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(101) := x"5" & "00" & '0'& '1' & x"F4";	-- STA @500 	# Desliga o display unidade
tmp(102) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(103) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(104) := x"7" & "00" & '0' & '0' & x"7B";	-- JEQ %define_limites_dezenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(105) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(106) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(107) := x"7" & "00" & '0' & '0' & x"63";	-- JEQ %checa_limites_unidades 	# Se for igual, vai para o label checa_limites_unidades
tmp(108) := x"9" & "00" & '0' & '0' & x"6F";	-- JSR %adiciona_unidade 	# Se não for igual, vai para o label adiciona_unidade
tmp(109) := x"6" & "00" & '0' & '0' & x"5F";	-- JMP %define_limites_unidades 	# Se não for igual, volta para o label define_limites_unidades
-- adiciona_unidade:
tmp(111) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(112) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40 	# Carrega o acumulador com o endereço de Limite de unidade
tmp(113) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(114) := x"7" & "00" & '0' & '0' & x"77";	-- JEQ %zera_unidade 	# Se for igual, vai para o label zera_unidade
tmp(115) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(116) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40 	# Armazena o valor do acumulador no endereço de Limite de unidade
tmp(117) := x"A" & "00" & '0' & '0' & x"00";	-- RET 
-- zera_unidade:
tmp(119) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(120) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40 	# Armazena o valor do acumulador no endereço de Limite de unidade
tmp(121) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_dezenas:
tmp(123) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(124) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(125) := x"9" & "00" & '1' & '0' & x"37";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas:
tmp(127) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(128) := x"5" & "00" & '0'& '1' & x"F4";	-- STA @500 	# liga o display unidade
tmp(129) := x"9" & "00" & '0' & '0' & x"39";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(130) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(131) := x"5" & "00" & '0'& '1' & x"F5";	-- STA @501 	# Desliga o display unidade
tmp(132) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(133) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(134) := x"7" & "00" & '0' & '0' & x"98";	-- JEQ %define_limites_centenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(135) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(136) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(137) := x"7" & "00" & '0' & '0' & x"7F";	-- JEQ %checa_limites_dezenas 	# Se for igual, vai para o label checa_limites_dezenas
tmp(138) := x"9" & "00" & '0' & '0' & x"8E";	-- JSR %adiciona_dezena 	# Se não for igual, vai para o label adiciona_dezena
tmp(139) := x"5" & "00" & '0'& '0' & x"29";	-- STA @41 	# Armazena o valor do acumulador no endereço de Limite de dezenas
tmp(140) := x"6" & "00" & '0' & '0' & x"7B";	-- JMP %define_limites_dezenas 	# Se não for igual, volta para o label define_limites_dezenas
-- adiciona_dezena:
tmp(142) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(143) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41 	# Carrega o acumulador com o endereço de Limite de dezena
tmp(144) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55 	# Compara o valor do acumulador com o valor 5
tmp(145) := x"7" & "00" & '0' & '0' & x"95";	-- JEQ %zera_dezena 	# Se for igual, vai para o label zera_dezena
tmp(146) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(147) := x"A" & "00" & '0' & '0' & x"00";	-- RET 
-- zera_dezena:
tmp(149) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(150) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_centenas:
tmp(152) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(153) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(154) := x"9" & "00" & '1' & '0' & x"37";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas:
tmp(156) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(157) := x"5" & "00" & '0'& '1' & x"F5";	-- STA @501 	# liga o display DEZENA
tmp(158) := x"9" & "00" & '0' & '0' & x"39";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(159) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(160) := x"5" & "00" & '0'& '1' & x"F6";	-- STA @502 	# Desliga o display unidade
tmp(161) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(162) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(163) := x"7" & "00" & '0' & '0' & x"B5";	-- JEQ %define_limites_milhares 	# Se for igual, vai para o label define_limites_centenas
tmp(164) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(165) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(166) := x"7" & "00" & '0' & '0' & x"9C";	-- JEQ %checa_limites_centenas 	# Se for igual, vai para o label checa_limites_centenas
tmp(167) := x"9" & "00" & '0' & '0' & x"AB";	-- JSR %adiciona_centena 	# Se não for igual, vai para o label adiciona_centena
tmp(168) := x"5" & "00" & '0'& '0' & x"2A";	-- STA @42 	# Armazena o valor do acumulador no endereço de Limite de centenas
tmp(169) := x"6" & "00" & '0' & '0' & x"98";	-- JMP %define_limites_centenas 	# Se não for igual, volta para o label define_limites_centenas
-- adiciona_centena:
tmp(171) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(172) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42 	# Carrega o acumulador com o endereço de Limite de centena
tmp(173) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(174) := x"7" & "00" & '0' & '0' & x"B2";	-- JEQ %zera_centena 	# Se for igual, vai para o label zera_centena
tmp(175) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(176) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_centena:
tmp(178) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(179) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_milhares:
tmp(181) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(182) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(183) := x"9" & "00" & '1' & '0' & x"37";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_milhares:
tmp(185) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(186) := x"5" & "00" & '0'& '1' & x"F6";	-- STA @502 	# liga o display unidade
tmp(187) := x"9" & "00" & '0' & '0' & x"39";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(188) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(189) := x"5" & "00" & '0'& '1' & x"F7";	-- STA @503 	# Desliga o display unidade
tmp(190) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(191) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(192) := x"7" & "00" & '0' & '0' & x"D2";	-- JEQ %define_limites_dezenas_de_milhares 	# Se for igual, vai para o label define_limites_milhares
tmp(193) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(194) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(195) := x"7" & "00" & '0' & '0' & x"B9";	-- JEQ %checa_limites_milhares 	# Se for igual, vai para o label checa_limites_milhares
tmp(196) := x"9" & "00" & '0' & '0' & x"C8";	-- JSR %adiciona_milhar 	# Se não for igual, vai para o label adiciona_milhar
tmp(197) := x"5" & "00" & '0'& '0' & x"2B";	-- STA @43 	# Armazena o valor do acumulador no endereço de Limite de milhares
tmp(198) := x"6" & "00" & '0' & '0' & x"B5";	-- JMP %define_limites_milhares 	# Se não for igual, volta para o label define_limites_milhares
-- adiciona_milhar:
tmp(200) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(201) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43 	# Carrega o acumulador com o endereço de Limite de milhar
tmp(202) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55 	# Compara o valor do acumulador com o valor 9
tmp(203) := x"7" & "00" & '0' & '0' & x"CF";	-- JEQ %zera_milhar 	# Se for igual, vai para o label zera_milhar
tmp(204) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(205) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_milhar:
tmp(207) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(208) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_dezenas_de_milhares:
tmp(210) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(211) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(212) := x"9" & "00" & '1' & '0' & x"37";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas_de_milhares:
tmp(214) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(215) := x"5" & "00" & '0'& '1' & x"F7";	-- STA @503 	# liga o display unidade
tmp(216) := x"9" & "00" & '0' & '0' & x"39";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(217) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(218) := x"5" & "00" & '0'& '1' & x"F8";	-- STA @504 	# Desliga o display unidade
tmp(219) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(220) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(221) := x"7" & "00" & '0' & '0' & x"F8";	-- JEQ %define_limites_centenas_de_milhares 	# Se for igual, vai para o label define_limites_dezenas_de_milhares
tmp(222) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(223) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(224) := x"7" & "00" & '0' & '0' & x"D6";	-- JEQ %checa_limites_dezenas_de_milhares 	# Se for igual, vai para o label checa_limites_dezenas_de_milhares
tmp(225) := x"9" & "00" & '0' & '0' & x"E5";	-- JSR %adiciona_dezena_de_milhar 	# Se não for igual, vai para o label adiciona_dezena_de_milhar
tmp(226) := x"5" & "00" & '0'& '0' & x"2C";	-- STA @44 	# Armazena o valor do acumulador no endereço de Limite de dezenas de milhares
tmp(227) := x"6" & "00" & '0' & '0' & x"D2";	-- JMP %define_limites_dezenas_de_milhares 	# Se não for igual, volta para o label define_limites_dezenas_de_milhares
-- adiciona_dezena_de_milhar:
tmp(229) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(230) := x"1" & "00" & '0'& '0' & x"0F";	-- LDA @15 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(231) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador com o valor 9
tmp(232) := x"7" & "00" & '0' & '0' & x"F2";	-- JEQ %limite_caso_20
tmp(233) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(234) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(235) := x"7" & "00" & '0' & '0' & x"EF";	-- JEQ %zera_dezena_de_milhar 	# Se for igual, vai para o label zera_dezena_de_milhar
tmp(236) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(237) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_dezena_de_milhar:
tmp(239) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(240) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- limite_caso_20:
tmp(242) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(243) := x"8" & "00" & '0'& '0' & x"35";	-- CEQ @53 	# Compara o valor do acumulador com o valor 9
tmp(244) := x"7" & "00" & '0' & '0' & x"EF";	-- JEQ %zera_dezena_de_milhar 	# Se for igual, vai para o label zera_dezena_de_milhar
tmp(245) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(246) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_centenas_de_milhares:
tmp(248) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(249) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(250) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando key 0
tmp(251) := x"9" & "00" & '1' & '0' & x"37";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas_de_milhares:
tmp(253) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(254) := x"5" & "00" & '0'& '1' & x"F8";	-- STA @504 	# liga o display unidade
tmp(255) := x"9" & "00" & '0' & '0' & x"39";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(256) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23 	# Carrega o acumulador com o endereço de PISCA
tmp(257) := x"5" & "00" & '0'& '1' & x"F9";	-- STA @505 	# Desliga o display unidade
tmp(258) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(259) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(260) := x"7" & "00"& '0' & '1' & x"24";	-- JEQ %salva 	# Se for igual, vai para o label salva
tmp(261) := x"1" & "00" & '0'& '1' & x"62";	-- LDA @354 	# Carrega o acumulador com o key 2
tmp(262) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(263) := x"7" & "00"& '0' & '1' & x"32";	-- JEQ %salva_tempo 	# Se for igual, vai para o label salva
tmp(264) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(265) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(266) := x"7" & "00" & '0' & '0' & x"FD";	-- JEQ %checa_limites_centenas_de_milhares 	# Se for igual, vai para o label checa_limites_centenas_de_milhares
tmp(267) := x"9" & "00"& '0' & '1' & x"0F";	-- JSR %adiciona_centena_de_milhar 	# Se não for igual, vai para o label adiciona_centena_de_milhar
tmp(268) := x"5" & "00" & '0'& '0' & x"2D";	-- STA @45 	# Armazena o valor do acumulador no endereço de Limite de centenas de milhares
tmp(269) := x"6" & "00" & '0' & '0' & x"F8";	-- JMP %define_limites_centenas_de_milhares 	# Se não for igual, volta para o label define_limites_centenas_de_milhares
-- adiciona_centena_de_milhar:
tmp(271) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(272) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(273) := x"8" & "00" & '0'& '0' & x"36";	-- CEQ @54 	# Compara o valor do acumulador com o valor 4
tmp(274) := x"C" & "00"& '0' & '1' & x"15";	-- JLT %limite_caso_24 	# Se for menor que 4, vai para o label limite_caso_24
tmp(275) := x"6" & "00"& '0' & '1' & x"1E";	-- JMP %especial_caso_24 	# Se não for menor que 4, vai para o label especial_caso_24
-- limite_caso_24:
tmp(277) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45 	# Carrega o acumulador com o endereço de Limite de centena de milhar
tmp(278) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador com o valor 2
tmp(279) := x"7" & "00"& '0' & '1' & x"1B";	-- JEQ %zera_centena_de_milhar 	# Se for igual, vai para o label zera_centena_de_milhar
tmp(280) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(281) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_centena_de_milhar:
tmp(283) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(284) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- especial_caso_24:
tmp(286) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45 	# Carrega o acumulador com o endereço de Limite de centena de milhar
tmp(287) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(288) := x"7" & "00"& '0' & '1' & x"1B";	-- JEQ %zera_centena_de_milhar 	# Se for igual, vai para o label zera_centena_de_milhar
tmp(289) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(290) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- salva:
tmp(292) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45 	# Carrega o acumulador com o endereço de Limite de centena de milhar
tmp(293) := x"5" & "00" & '0'& '0' & x"0F";	-- STA @15 	# Armazena o valor do acumulador no endereço de Limite de dezena de milhar
tmp(294) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(295) := x"5" & "00" & '0'& '0' & x"0E";	-- STA @14 	# Armazena o valor do acumulador no endereço de Limite de milhares
tmp(296) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43 	# Carrega o acumulador com o endereço de Limite de milhares
tmp(297) := x"5" & "00" & '0'& '0' & x"0D";	-- STA @13 	# Armazena o valor do acumulador no endereço de Limite de centenas
tmp(298) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42 	# Carrega o acumulador com o endereço de Limite de centenas
tmp(299) := x"5" & "00" & '0'& '0' & x"0C";	-- STA @12 	# Armazena o valor do acumulador no endereço de Limite de dezenas
tmp(300) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41 	# Carrega o acumulador com o endereço de Limite de dezenas
tmp(301) := x"5" & "00" & '0'& '0' & x"0B";	-- STA @11 	# Armazena o valor do acumulador no endereço de Limite de unidades
tmp(302) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40 	# Carrega o acumulador com o endereço de Limite de unidades
tmp(303) := x"5" & "00" & '0'& '0' & x"0A";	-- STA @10 	# Armazena o valor do acumulador no endereço de Limite de unidades
tmp(304) := x"6" & "00"& '0' & '1' & x"57";	-- JMP %reset_temp 	# Se não for igual, volta para o label define_limites_unidades
-- salva_tempo:
tmp(306) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45 	# Carrega o acumulador com o endereço de Limite de centena de milhar
tmp(307) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço de Limite de dezena de milhar
tmp(308) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(309) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço de Limite de milhares
tmp(310) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43 	# Carrega o acumulador com o endereço de Limite de milhares
tmp(311) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço de Limite de centenas
tmp(312) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42 	# Carrega o acumulador com o endereço de Limite de centenas
tmp(313) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço de Limite de dezenas
tmp(314) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41 	# Carrega o acumulador com o endereço de Limite de dezenas
tmp(315) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço de Limite de unidades
tmp(316) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40 	# Carrega o acumulador com o endereço de Limite de unidades
tmp(317) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de Limite de unidades
tmp(318) := x"4" & "00" & '0'& '0' & x"55";	-- LDI $85 	# Carrega 85 no acumulador
tmp(319) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Armazena o valor do acumulador nos LED 7 - 8
tmp(320) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357 	# Carrega o acumulador com o segundos
tmp(321) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(322) := x"7" & "00"& '0' & '1' & x"45";	-- JEQ %pre_salva_tempo_pt2
tmp(323) := x"6" & "00"& '0' & '1' & x"32";	-- JMP %salva_tempo
-- pre_salva_tempo_pt2:
tmp(325) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando key 0
-- salva_tempo_pt2:
tmp(327) := x"4" & "00" & '0'& '0' & x"55";	-- LDI $85 	# Carrega 85 no acumulador
tmp(328) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Armazena o valor do acumulador nos LED 7 - 8
tmp(329) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357 	# Carrega o acumulador com o segundos
tmp(330) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(331) := x"7" & "00"& '0' & '1' & x"4E";	-- JEQ %pre_salva_tempo_pt3 	# Se não for igual, volta para o label define_limites_unidades
tmp(332) := x"6" & "00"& '0' & '1' & x"47";	-- JMP %salva_tempo_pt2
-- pre_salva_tempo_pt3:
tmp(334) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando key 0
-- salva_tempo_pt3:
tmp(336) := x"4" & "00" & '0'& '0' & x"AA";	-- LDI $170 	# Carrega 85 no acumulador
tmp(337) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Armazena o valor do acumulador nos LED 7 - 8
tmp(338) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357 	# Carrega o acumulador com o segundos
tmp(339) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(340) := x"7" & "00"& '0' & '1' & x"57";	-- JEQ %reset_temp 	# Se não for igual, volta para o label define_limites_unidades
tmp(341) := x"6" & "00"& '0' & '1' & x"50";	-- JMP %salva_tempo_pt3
-- reset_temp:
tmp(343) := x"1" & "00" & '0'& '0' & x"0A";	-- LDA @10 	# Carrega o acumulador com o endereço de Limite de unidades
tmp(344) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40 	# Limpando endereço de temp 1
tmp(345) := x"1" & "00" & '0'& '0' & x"0C";	-- LDA @12 	# Carrega o acumulador com o endereço de Limite de CENTENAS
tmp(346) := x"5" & "00" & '0'& '0' & x"2A";	-- STA @42 	# Limpando endereço de temp 3
tmp(347) := x"1" & "00" & '0'& '0' & x"0B";	-- LDA @11 	# Carrega o acumulador com o endereço de Limite de CENTENAS
tmp(348) := x"5" & "00" & '0'& '0' & x"29";	-- STA @41 	# Limpando endereço de temp 2
tmp(349) := x"1" & "00" & '0'& '0' & x"0D";	-- LDA @13 	# Carrega o acumulador com o endereço de Limite de CENTENAS
tmp(350) := x"5" & "00" & '0'& '0' & x"2B";	-- STA @43 	# Limpando endereço de temp 4
tmp(351) := x"1" & "00" & '0'& '0' & x"0E";	-- LDA @14 	# Carrega o acumulador com o endereço de Limite de CENTENAS
tmp(352) := x"5" & "00" & '0'& '0' & x"2C";	-- STA @44 	# Limpando endereço de temp 5
tmp(353) := x"1" & "00" & '0'& '0' & x"0F";	-- LDA @15 	# Carrega o acumulador com o endereço de Limite de CENTENAS
tmp(354) := x"5" & "00" & '0'& '0' & x"2D";	-- STA @45 	# Limpando endereço de temp 6
tmp(355) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 85 no acumulador
tmp(356) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Armazena o valor do acumulador nos LED 7 - 8
tmp(357) := x"6" & "00"& '0' & '1' & x"67";	-- JMP %pre_le_key
-- pre_le_key:
tmp(359) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(360) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(361) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega 1 no acumulador
tmp(362) := x"5" & "00" & '0'& '1' & x"F9";	-- STA @505 	# Liga o display 0
tmp(363) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays
tmp(364) := x"6" & "00"& '0' & '1' & x"6E";	-- JMP %le_key 	# Vai para o label le_key
-- le_key:
tmp(366) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357 	# Carrega o acumulador com o segundos
tmp(367) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(368) := x"7" & "00"& '0' & '1' & x"91";	-- JEQ %incrementa_unidade 	# Se for igual, vai para o label incrementa
tmp(369) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(370) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(371) := x"7" & "00" & '0' & '0' & x"5F";	-- JEQ %define_limites_unidades 	# Se for igual, vai para o label incrementa
tmp(372) := x"9" & "00"& '0' & '1' & x"7B";	-- JSR %checa_op 	# checa se é + ou -
tmp(373) := x"9" & "00"& '0' & '1' & x"86";	-- JSR %checa_timer 	# checa se ta ligado ou nao
tmp(374) := x"1" & "00" & '0'& '1' & x"64";	-- LDA @356		# Carrega o acumulador com o endereço de fpga_reset
tmp(375) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(376) := x"7" & "00" & '1' & '0' & x"68";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(377) := x"6" & "00"& '0' & '1' & x"6E";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- checa_op:
tmp(379) := x"1" & "00" & '0'& '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(380) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(381) := x"7" & "00"& '0' & '1' & x"82";	-- JEQ %mais 	# Se for igual, vai para o label le_key
tmp(382) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1 	# Carrega o acumulador com o valor 1
tmp(383) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258 	# Liga led 9
tmp(384) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- mais:
tmp(386) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(387) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258 	# Liga led 9
tmp(388) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- checa_timer:
tmp(390) := x"1" & "00" & '0'& '1' & x"41";	-- LDA @321 	# Carrega o acumulador com o endereço de SW8
tmp(391) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(392) := x"7" & "00"& '0' & '1' & x"8D";	-- JEQ %desativado 	# Se for igual, vai para o label desativado
tmp(393) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1 	# Carrega o acumulador com o valor 1
tmp(394) := x"5" & "00" & '0'& '1' & x"01";	-- STA @257 	# Liga led 8
tmp(395) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- desativado:
tmp(397) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(398) := x"5" & "00" & '0'& '1' & x"01";	-- STA @257 	# Liga led 8
tmp(399) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- incrementa_unidade:
tmp(401) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando key 0
tmp(402) := x"1" & "00" & '0'& '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(403) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(404) := x"7" & "00"& '0' & '1' & x"9E";	-- JEQ %sub_unidade 	# Se for igual, vai para o label sub_unidade
tmp(405) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(406) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(407) := x"7" & "00"& '0' & '1' & x"A5";	-- JEQ %incrementa_dezena 	# Se for igual, vai para o label incrementa_dezena
tmp(408) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(409) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(410) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(411) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258 	# Desliga led 9
tmp(412) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- sub_unidade:
tmp(414) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(415) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(416) := x"7" & "00"& '0' & '1' & x"AF";	-- JEQ %decremeta_dezena 	# Se for igual, vai para o label decremeta_dezena
tmp(417) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(418) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(419) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- incrementa_dezena:
tmp(421) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(422) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(423) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(424) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(425) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(426) := x"7" & "00"& '0' & '1' & x"B9";	-- JEQ %incrementa_centena 	# Se for igual a 9, vai para o incrementa_centena
tmp(427) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(428) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(429) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_dezena:
tmp(431) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9
tmp(432) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(433) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(434) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(435) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(436) := x"7" & "00"& '0' & '1' & x"C3";	-- JEQ %decremeta_centena 	# Se for igual a 0, vai para o decremeta_centena
tmp(437) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(438) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(439) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena:
tmp(441) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(442) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(443) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(444) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(445) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (centena) com o valor 9
tmp(446) := x"7" & "00"& '0' & '1' & x"CD";	-- JEQ %incrementa_milhar 	# Se for igual a 9, vai para o incrementa_milhar
tmp(447) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(448) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(449) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena:
tmp(451) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5
tmp(452) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(453) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(454) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(455) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (centena) com o valor 0
tmp(456) := x"7" & "00"& '0' & '1' & x"D7";	-- JEQ %decremeta_milhar 	# Se for igual a 0, vai para o decremeta_milhar
tmp(457) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(458) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(459) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_milhar:
tmp(461) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(462) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(463) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(464) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(465) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(466) := x"7" & "00"& '0' & '1' & x"E1";	-- JEQ %incrementa_dezena_de_milhar 	# Se for igual a 9, vai para o incrementa_dezena_de_milhar
tmp(467) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(468) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(469) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- decremeta_milhar:
tmp(471) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9
tmp(472) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(473) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(474) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(475) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(476) := x"7" & "00"& '0' & '1' & x"F4";	-- JEQ %decremeta_dezena_de_milhar 	# Se for igual a 0, vai para o decremeta_dezena_de_milhar
tmp(477) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(478) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(479) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- incrementa_dezena_de_milhar:
tmp(481) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(482) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(483) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(484) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena de milhar
tmp(485) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador (dezena) com o valor 2
tmp(486) := x"7" & "00"& '0' & '1' & x"EF";	-- JEQ %outro_incremente_dezena_de_milhar 	# Se for igual a 2, vai para o incremenoutro_incremente_dezena_de_milharta_centena_milhar
tmp(487) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(488) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(489) := x"7" & "00"& '0' & '1' & x"FE";	-- JEQ %incrementa_centena_milhar 	# Se for igual a 9, vai para o incrementa_centena_milhar
-- volta:
tmp(491) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(492) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(493) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- outro_incremente_dezena_de_milhar:
tmp(495) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(496) := x"8" & "00" & '0'& '0' & x"35";	-- CEQ @53 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(497) := x"7" & "00"& '0' & '1' & x"FE";	-- JEQ %incrementa_centena_milhar 	# Se for igual a 9, vai para o incrementa_centena_milhar
tmp(498) := x"6" & "00"& '0' & '1' & x"EB";	-- JMP %volta 	# Se não for igual, volta para o label volta
-- decremeta_dezena_de_milhar:
tmp(500) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5
tmp(501) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(502) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(503) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(504) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(505) := x"7" & "00" & '1' & '0' & x"08";	-- JEQ %decremeta_centena_milhar 	# Se for igual a 0, vai para o decremeta_centena_milhar
tmp(506) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(507) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(508) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena_milhar:
tmp(510) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(511) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(512) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(513) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(514) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador (centena) com o valor 9
tmp(515) := x"7" & "00" & '1' & '0' & x"1A";	-- JEQ %zerou 	# Se for igual a 9, vai para o atualiza_displays
tmp(516) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(517) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(518) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena_milhar:
tmp(520) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(521) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52 	# Compara o valor do acumulador com o valor 2 (limite de centena de milhar)
tmp(522) := x"7" & "00" & '1' & '0' & x"16";	-- JEQ %caso20 	# Se for igual, vai para o label caso20
tmp(523) := x"4" & "00" & '0'& '0' & x"03";	-- LDI $3
tmp(524) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
-- volta_caso20:
tmp(526) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(527) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(528) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (centena) com o valor 0
tmp(529) := x"7" & "00" & '1' & '0' & x"1A";	-- JEQ %zerou 	# Se for igual a 0, vai para o atualiza_displays
tmp(530) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(531) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(532) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- caso20:
tmp(534) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9  
tmp(535) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(536) := x"6" & "00" & '1' & '0' & x"0E";	-- JMP %volta_caso20 	# Se não for igual, volta para o label volta_caso20
-- zerou:
tmp(538) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0
tmp(539) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(540) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(541) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(542) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(543) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(544) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(545) := x"1" & "00" & '0'& '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(546) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(547) := x"7" & "00" & '1' & '0' & x"72";	-- JEQ %final 	# Se for igual, vai para o label final
tmp(548) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando Key 0
tmp(549) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando Key 1
tmp(550) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- atualiza_displays:
tmp(552) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(553) := x"5" & "00" & '0'& '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(554) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(555) := x"5" & "00" & '0'& '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(556) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(557) := x"5" & "00" & '0'& '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(558) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(559) := x"5" & "00" & '0'& '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(560) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(561) := x"5" & "00" & '0'& '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(562) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(563) := x"5" & "00" & '0'& '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(564) := x"9" & "00" & '1' & '0' & x"45";	-- JSR %verifica_centena_de_milhar 	# Vai para o label verifica_centena_de_milhar
tmp(565) := x"6" & "00"& '0' & '1' & x"6E";	-- JMP %le_key 	# Vai para o label le_key
-- atualiza_displays_limites:
tmp(567) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40 	# Carrega o acumulador com o Limites das unidades
tmp(568) := x"5" & "00" & '0'& '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(569) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41 	# Carrega o acumulador com o Limites das dezenas
tmp(570) := x"5" & "00" & '0'& '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(571) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42 	# Carrega o acumulador com o Limites de centena
tmp(572) := x"5" & "00" & '0'& '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(573) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43 	# Carrega o acumulador com o Limites de milhar
tmp(574) := x"5" & "00" & '0'& '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(575) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44 	# Carrega o acumulador com o Limites de dezena de milhar
tmp(576) := x"5" & "00" & '0'& '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(577) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45 	# Carrega o acumulador com o Limites de centena de milhar
tmp(578) := x"5" & "00" & '0'& '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(579) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_centena_de_milhar:
tmp(581) := x"1" & "00" & '0'& '1' & x"41";	-- LDA @321 	# Carrega o acumulador com o endereço de SW8
tmp(582) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 0
tmp(583) := x"7" & "00" & '1' & '0' & x"4A";	-- JEQ %continua_verifica_centena_de_milhar 	# Se for igual, vai para o label continua_verifica_centena_de_milhar
tmp(584) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- continua_verifica_centena_de_milhar: 
tmp(586) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(587) := x"8" & "00" & '0'& '0' & x"0F";	-- CEQ @15 	# Compara o valor do acumulador com o valor maximo de centena de milhar
tmp(588) := x"7" & "00" & '1' & '0' & x"4F";	-- JEQ %verifica_dezena_de_milhar 	# Se for igual, vai para o label verifica_dezena_de_milhar
tmp(589) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_dezena_de_milhar:
tmp(591) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(592) := x"8" & "00" & '0'& '0' & x"0E";	-- CEQ @14 	# Compara o valor do acumulador com o valor maximo de dezena de milhar
tmp(593) := x"7" & "00" & '1' & '0' & x"54";	-- JEQ %verifica_milhar 	# Se for igual, vai para o label verifica_milhar
tmp(594) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_milhar:
tmp(596) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(597) := x"8" & "00" & '0'& '0' & x"0D";	-- CEQ @13 	# Compara o valor do acumulador com o valor maximo de milhar
tmp(598) := x"7" & "00" & '1' & '0' & x"59";	-- JEQ %verifica_centena 	# Se for igual, vai para o label verifica_centena
tmp(599) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_centena:
tmp(601) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(602) := x"8" & "00" & '0'& '0' & x"0C";	-- CEQ @12 	# Compara o valor do acumulador com o valor maximo de centena
tmp(603) := x"7" & "00" & '1' & '0' & x"5E";	-- JEQ %verifica_dezena 	# Se for igual, vai para o label verifica_dezena
tmp(604) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_dezena:
tmp(606) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(607) := x"8" & "00" & '0'& '0' & x"0B";	-- CEQ @11 	# Compara o valor do acumulador com o valor maximo de dezena
tmp(608) := x"7" & "00" & '1' & '0' & x"63";	-- JEQ %verifica_unidade 	# Se for igual, vai para o label verifica_unidade
tmp(609) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_unidade:
tmp(611) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(612) := x"8" & "00" & '0'& '0' & x"0A";	-- CEQ @10 	# Compara o valor do acumulador com o valor maximo de unidade
tmp(613) := x"7" & "00" & '1' & '0' & x"72";	-- JEQ %final 	# Se for igual, vai para o label final
tmp(614) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- RESET_FPGA:
tmp(616) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(617) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(618) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508 	# Limpando reset_key
tmp(619) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0 	# Carregando 0 no acumulador
tmp(620) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258 	# Desliga led 9
tmp(621) := x"5" & "00" & '0'& '1' & x"01";	-- STA @257 	# Desliga o led 8
tmp(622) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Desliga o led 7 ao led 0
tmp(623) := x"5" & "00" & '1' & '1' & x"FF";	-- STA @1023 	# Desliga o BUZZER
tmp(624) := x"6" & "00" & '1' & '0' & x"28";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- final:
tmp(626) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1 	# Carrega 1 no acumulador
tmp(627) := x"5" & "00" & '1' & '1' & x"FF";	-- STA @1023 	# Liga o BUZZER
tmp(628) := x"1" & "00" & '0'& '0' & x"33";	-- LDA @51 	# Carrega 1 no acumulador
tmp(629) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258 	# Liga led 9
tmp(630) := x"5" & "00" & '0'& '1' & x"01";	-- STA @257 	# Liga o led 8
tmp(631) := x"4" & "00" & '0'& '0' & x"FF";	-- LDI $255 	# Carrega 255 no acumulador
tmp(632) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256 	# Liga o led 7 ao led 0
tmp(633) := x"1" & "00" & '0'& '1' & x"64";	-- LDA @356		# Carrega o acumulador com o endereço de fpga_reset
tmp(634) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(635) := x"7" & "00" & '1' & '0' & x"68";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(636) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(637) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(638) := x"7" & "00" & '0' & '0' & x"5F";	-- JEQ %define_limites_unidades 	# Se for igual, vai para o label incrementa
tmp(639) := x"6" & "00"& '0' & '1' & x"6E";	-- JMP %le_key 	# Se não for igual, volta para o label le_key



        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;