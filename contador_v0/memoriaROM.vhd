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
tmp(22) := x"0" & '0' & x"00";	-- NOP
tmp(23) := x"4" & '0' & x"09";	-- LDI $9
tmp(24) := x"5" & '0' & x"0A";	-- STA @10 	# Limite das unidades
tmp(25) := x"5" & '0' & x"0B";	-- STA @11 	# Limite das dezenas
tmp(26) := x"5" & '0' & x"0C";	-- STA @12 	# Limite das centenas
tmp(27) := x"5" & '0' & x"0D";	-- STA @13 	# Limite dos milhares
tmp(28) := x"5" & '0' & x"0E";	-- STA @14 	# Limite das dezenas de milhares
tmp(29) := x"5" & '0' & x"0F";	-- STA @15 	# Limite das centenas de milhares
tmp(30) := x"6" & '0' & x"C3";	-- JMP %le_key 	# Vai para o label le_key
-- define_limites_unidades:
tmp(32) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(33) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(34) := x"9" & '1' & x"7C";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_unidades:
tmp(36) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(37) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(38) := x"7" & '0' & x"3B";	-- JEQ %define_limites_dezenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(39) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(40) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(41) := x"7" & '0' & x"24";	-- JEQ %checa_limites_unidades 	# Se for igual, vai para o label checa_limites_unidades
tmp(42) := x"9" & '0' & x"2D";	-- JSR %adiciona_unidade 	# Se não for igual, vai para o label adiciona_unidade
tmp(43) := x"6" & '0' & x"20";	-- JMP %define_limites_unidades 	# Se não for igual, volta para o label define_limites_unidades
-- adiciona_unidade:
tmp(45) := x"0" & '0' & x"00";	-- NOP
tmp(46) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(47) := x"1" & '0' & x"0A";	-- LDA @10 	# Carrega o acumulador com o endereço de Limite de unidade
tmp(48) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(49) := x"7" & '0' & x"36";	-- JEQ %zera_unidade 	# Se for igual, vai para o label zera_unidade
tmp(50) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(51) := x"5" & '0' & x"0A";	-- STA @10 	# Armazena o valor do acumulador no endereço de Limite de unidade
tmp(52) := x"A" & '0' & x"00";	-- RET 
-- zera_unidade:
tmp(54) := x"0" & '0' & x"00";	-- NOP
tmp(55) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(56) := x"5" & '0' & x"0A";	-- STA @10 	# Armazena o valor do acumulador no endereço de Limite de unidade
tmp(57) := x"A" & '0' & x"00";	-- RET
-- define_limites_dezenas:
tmp(59) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(60) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(61) := x"9" & '1' & x"7C";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas:
tmp(63) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(64) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(65) := x"7" & '0' & x"55";	-- JEQ %define_limites_centenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(66) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(67) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(68) := x"7" & '0' & x"3F";	-- JEQ %checa_limites_dezenas 	# Se for igual, vai para o label checa_limites_dezenas
tmp(69) := x"9" & '0' & x"49";	-- JSR %adiciona_dezena 	# Se não for igual, vai para o label adiciona_dezena
tmp(70) := x"5" & '0' & x"0B";	-- STA @11 	# Armazena o valor do acumulador no endereço de Limite de dezenas
tmp(71) := x"6" & '0' & x"3B";	-- JMP %define_limites_dezenas 	# Se não for igual, volta para o label define_limites_dezenas
-- adiciona_dezena:
tmp(73) := x"0" & '0' & x"00";	-- NOP
tmp(74) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(75) := x"1" & '0' & x"0B";	-- LDA @11 	# Carrega o acumulador com o endereço de Limite de dezena
tmp(76) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(77) := x"7" & '0' & x"51";	-- JEQ %zera_dezena 	# Se for igual, vai para o label zera_dezena
tmp(78) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(79) := x"A" & '0' & x"00";	-- RET 
-- zera_dezena:
tmp(81) := x"0" & '0' & x"00";	-- NOP
tmp(82) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(83) := x"A" & '0' & x"00";	-- RET
-- define_limites_centenas:
tmp(85) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(86) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(87) := x"9" & '1' & x"7C";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas:
tmp(89) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(90) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(91) := x"7" & '0' & x"6F";	-- JEQ %define_limites_milhares 	# Se for igual, vai para o label define_limites_centenas
tmp(92) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(93) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(94) := x"7" & '0' & x"59";	-- JEQ %checa_limites_centenas 	# Se for igual, vai para o label checa_limites_centenas
tmp(95) := x"9" & '0' & x"63";	-- JSR %adiciona_centena 	# Se não for igual, vai para o label adiciona_centena
tmp(96) := x"5" & '0' & x"0C";	-- STA @12 	# Armazena o valor do acumulador no endereço de Limite de centenas
tmp(97) := x"6" & '0' & x"55";	-- JMP %define_limites_centenas 	# Se não for igual, volta para o label define_limites_centenas
-- adiciona_centena:
tmp(99) := x"0" & '0' & x"00";	-- NOP
tmp(100) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(101) := x"1" & '0' & x"0C";	-- LDA @12 	# Carrega o acumulador com o endereço de Limite de centena
tmp(102) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(103) := x"7" & '0' & x"6B";	-- JEQ %zera_centena 	# Se for igual, vai para o label zera_centena
tmp(104) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(105) := x"A" & '0' & x"00";	-- RET
-- zera_centena:
tmp(107) := x"0" & '0' & x"00";	-- NOP
tmp(108) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(109) := x"A" & '0' & x"00";	-- RET
-- define_limites_milhares:
tmp(111) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(112) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(113) := x"9" & '1' & x"7C";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_milhares:
tmp(115) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(116) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(117) := x"7" & '0' & x"89";	-- JEQ %define_limites_dezenas_de_milhares 	# Se for igual, vai para o label define_limites_milhares
tmp(118) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(119) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(120) := x"7" & '0' & x"73";	-- JEQ %checa_limites_milhares 	# Se for igual, vai para o label checa_limites_milhares
tmp(121) := x"9" & '0' & x"7D";	-- JSR %adiciona_milhar 	# Se não for igual, vai para o label adiciona_milhar
tmp(122) := x"5" & '0' & x"0D";	-- STA @13 	# Armazena o valor do acumulador no endereço de Limite de milhares
tmp(123) := x"6" & '0' & x"6F";	-- JMP %define_limites_milhares 	# Se não for igual, volta para o label define_limites_milhares
-- adiciona_milhar:
tmp(125) := x"0" & '0' & x"00";	-- NOP
tmp(126) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(127) := x"1" & '0' & x"0D";	-- LDA @13 	# Carrega o acumulador com o endereço de Limite de milhar
tmp(128) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(129) := x"7" & '0' & x"85";	-- JEQ %zera_milhar 	# Se for igual, vai para o label zera_milhar
tmp(130) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(131) := x"A" & '0' & x"00";	-- RET
-- zera_milhar:
tmp(133) := x"0" & '0' & x"00";	-- NOP
tmp(134) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(135) := x"A" & '0' & x"00";	-- RET
-- define_limites_dezenas_de_milhares:
tmp(137) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(138) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(139) := x"9" & '1' & x"7C";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas_de_milhares:
tmp(141) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(142) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(143) := x"7" & '0' & x"A3";	-- JEQ %define_limites_centenas_de_milhares 	# Se for igual, vai para o label define_limites_dezenas_de_milhares
tmp(144) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(145) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(146) := x"7" & '0' & x"8D";	-- JEQ %checa_limites_dezenas_de_milhares 	# Se for igual, vai para o label checa_limites_dezenas_de_milhares
tmp(147) := x"9" & '0' & x"97";	-- JSR %adiciona_dezena_de_milhar 	# Se não for igual, vai para o label adiciona_dezena_de_milhar
tmp(148) := x"5" & '0' & x"0E";	-- STA @14 	# Armazena o valor do acumulador no endereço de Limite de dezenas de milhares
tmp(149) := x"6" & '0' & x"89";	-- JMP %define_limites_dezenas_de_milhares 	# Se não for igual, volta para o label define_limites_dezenas_de_milhares
-- adiciona_dezena_de_milhar:
tmp(151) := x"0" & '0' & x"00";	-- NOP
tmp(152) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(153) := x"1" & '0' & x"0E";	-- LDA @14 	# Carrega o acumulador com o endereço de Limite de dezena de milhar
tmp(154) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(155) := x"7" & '0' & x"9F";	-- JEQ %zera_dezena_de_milhar 	# Se for igual, vai para o label zera_dezena_de_milhar
tmp(156) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(157) := x"A" & '0' & x"00";	-- RET
-- zera_dezena_de_milhar:
tmp(159) := x"0" & '0' & x"00";	-- NOP
tmp(160) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(161) := x"A" & '0' & x"00";	-- RET
-- define_limites_centenas_de_milhares:
tmp(163) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(164) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(165) := x"9" & '1' & x"7C";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas_de_milhares:
tmp(167) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(168) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(169) := x"7" & '0' & x"BD";	-- JEQ %pre_le_key 	# Se for igual, vai para o label pre_le_key
tmp(170) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(171) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(172) := x"7" & '0' & x"A7";	-- JEQ %checa_limites_centenas_de_milhares 	# Se for igual, vai para o label checa_limites_centenas_de_milhares
tmp(173) := x"9" & '0' & x"B1";	-- JSR %adiciona_centena_de_milhar 	# Se não for igual, vai para o label adiciona_centena_de_milhar
tmp(174) := x"5" & '0' & x"0F";	-- STA @15 	# Armazena o valor do acumulador no endereço de Limite de centenas de milhares
tmp(175) := x"6" & '0' & x"A3";	-- JMP %define_limites_centenas_de_milhares 	# Se não for igual, volta para o label define_limites_centenas_de_milhares
-- adiciona_centena_de_milhar:
tmp(177) := x"0" & '0' & x"00";	-- NOP
tmp(178) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(179) := x"1" & '0' & x"0F";	-- LDA @15 	# Carrega o acumulador com o endereço de Limite de centena de milhar
tmp(180) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(181) := x"7" & '0' & x"B9";	-- JEQ %zera_centena_de_milhar 	# Se for igual, vai para o label zera_centena_de_milhar
tmp(182) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(183) := x"A" & '0' & x"00";	-- RET
-- zera_centena_de_milhar:
tmp(185) := x"0" & '0' & x"00";	-- NOP
tmp(186) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega 0 no acumulador
tmp(187) := x"A" & '0' & x"00";	-- RET
-- pre_le_key:
tmp(189) := x"0" & '0' & x"00";	-- NOP
tmp(190) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(191) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(192) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays
tmp(193) := x"6" & '0' & x"C3";	-- JMP %le_key 	# Vai para o label le_key
-- le_key:
tmp(195) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(196) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(197) := x"7" & '0' & x"DC";	-- JEQ %incrementa_unidade 	# Se for igual, vai para o label incrementa
tmp(198) := x"0" & '0' & x"00";	-- NOP
tmp(199) := x"1" & '1' & x"61";	-- LDA @353 	# Carrega o acumulador com o key 1
tmp(200) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(201) := x"7" & '0' & x"20";	-- JEQ %define_limites_unidades 	# Se for igual, vai para o label incrementa
tmp(202) := x"9" & '0' & x"D0";	-- JSR %checa_op 	# checa se é + ou -
tmp(203) := x"1" & '1' & x"64";	-- LDA @356		# Carrega o acumulador com o endereço de fpga_reset
tmp(204) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(205) := x"7" & '1' & x"AA";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(206) := x"6" & '0' & x"C3";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- checa_op:
tmp(208) := x"0" & '0' & x"00";	-- NOP
tmp(209) := x"1" & '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(210) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(211) := x"7" & '0' & x"D8";	-- JEQ %mais 	# Se for igual, vai para o label le_key
tmp(212) := x"4" & '0' & x"01";	-- LDI $1 	# Carrega o acumulador com o valor 1
tmp(213) := x"5" & '1' & x"02";	-- STA @258 	# Liga led 9
tmp(214) := x"A" & '0' & x"00";	-- RET
-- mais:
tmp(216) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(217) := x"5" & '1' & x"02";	-- STA @258 	# Liga led 9
tmp(218) := x"A" & '0' & x"00";	-- RET
-- incrementa_unidade:
tmp(220) := x"0" & '0' & x"00";	-- NOP
tmp(221) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(222) := x"1" & '1' & x"42";	-- LDA @322 	# Carrega o acumulador com o endereço de SW9
tmp(223) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(224) := x"7" & '0' & x"EA";	-- JEQ %sub_unidade 	# Se for igual, vai para o label sub_unidade
tmp(225) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(226) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(227) := x"7" & '0' & x"F2";	-- JEQ %incrementa_dezena 	# Se for igual, vai para o label incrementa_dezena
tmp(228) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(229) := x"5" & '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(230) := x"4" & '0' & x"00";	-- LDI $0 	# Carrega o acumulador com o valor 1
tmp(231) := x"5" & '1' & x"02";	-- STA @258 	# Desliga led 9
tmp(232) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- sub_unidade:
tmp(234) := x"0" & '0' & x"00";	-- NOP
tmp(235) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(236) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador com o valor 0
tmp(237) := x"7" & '0' & x"FD";	-- JEQ %decremeta_dezena 	# Se for igual, vai para o label decremeta_dezena
tmp(238) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(239) := x"5" & '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(240) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- incrementa_dezena:
tmp(242) := x"0" & '0' & x"00";	-- NOP
tmp(243) := x"4" & '0' & x"00";	-- LDI $0
tmp(244) := x"5" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(245) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(246) := x"1" & '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(247) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(248) := x"7" & '1' & x"08";	-- JEQ %incrementa_centena 	# Se for igual a 9, vai para o incrementa_centena
tmp(249) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(250) := x"5" & '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(251) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_dezena:
tmp(253) := x"0" & '0' & x"00";	-- NOP
tmp(254) := x"4" & '0' & x"09";	-- LDI $9
tmp(255) := x"5" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(256) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(257) := x"1" & '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(258) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(259) := x"7" & '1' & x"13";	-- JEQ %decremeta_centena 	# Se for igual a 0, vai para o decremeta_centena
tmp(260) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(261) := x"5" & '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(262) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena:
tmp(264) := x"0" & '0' & x"00";	-- NOP
tmp(265) := x"4" & '0' & x"00";	-- LDI $0
tmp(266) := x"5" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(267) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(268) := x"1" & '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(269) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (centena) com o valor 9
tmp(270) := x"7" & '1' & x"1E";	-- JEQ %incrementa_milhar 	# Se for igual a 9, vai para o incrementa_milhar
tmp(271) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(272) := x"5" & '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(273) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena:
tmp(275) := x"0" & '0' & x"00";	-- NOP
tmp(276) := x"4" & '0' & x"09";	-- LDI $9
tmp(277) := x"5" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(278) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(279) := x"1" & '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(280) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (centena) com o valor 0
tmp(281) := x"7" & '1' & x"29";	-- JEQ %decremeta_milhar 	# Se for igual a 0, vai para o decremeta_milhar
tmp(282) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(283) := x"5" & '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(284) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_milhar:
tmp(286) := x"0" & '0' & x"00";	-- NOP
tmp(287) := x"4" & '0' & x"00";	-- LDI $0
tmp(288) := x"5" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(289) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(290) := x"1" & '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(291) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(292) := x"7" & '1' & x"34";	-- JEQ %incrementa_dezena_de_milhar 	# Se for igual a 9, vai para o incrementa_dezena_de_milhar
tmp(293) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(294) := x"5" & '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(295) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- decremeta_milhar:
tmp(297) := x"0" & '0' & x"00";	-- NOP
tmp(298) := x"4" & '0' & x"09";	-- LDI $9
tmp(299) := x"5" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(300) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(301) := x"1" & '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(302) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(303) := x"7" & '1' & x"3F";	-- JEQ %decremeta_dezena_de_milhar 	# Se for igual a 0, vai para o decremeta_dezena_de_milhar
tmp(304) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(305) := x"5" & '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(306) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- incrementa_dezena_de_milhar:
tmp(308) := x"0" & '0' & x"00";	-- NOP
tmp(309) := x"4" & '0' & x"00";	-- LDI $0
tmp(310) := x"5" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(311) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(312) := x"1" & '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(313) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(314) := x"7" & '1' & x"4A";	-- JEQ %incrementa_centena_milhar 	# Se for igual a 9, vai para o incrementa_centena_milhar
tmp(315) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(316) := x"5" & '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(317) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_dezena_de_milhar:
tmp(319) := x"0" & '0' & x"00";	-- NOP
tmp(320) := x"4" & '0' & x"09";	-- LDI $9
tmp(321) := x"5" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(322) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(323) := x"1" & '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(324) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (dezena) com o valor 0
tmp(325) := x"7" & '1' & x"55";	-- JEQ %decremeta_centena_milhar 	# Se for igual a 0, vai para o decremeta_centena_milhar
tmp(326) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(327) := x"5" & '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(328) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena_milhar:
tmp(330) := x"0" & '0' & x"00";	-- NOP
tmp(331) := x"4" & '0' & x"00";	-- LDI $0
tmp(332) := x"5" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(333) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(334) := x"1" & '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(335) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (centena) com o valor 9
tmp(336) := x"7" & '1' & x"6B";	-- JEQ %atualiza_displays 	# Se for igual a 9, vai para o atualiza_displays
tmp(337) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(338) := x"5" & '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(339) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena_milhar:
tmp(341) := x"0" & '0' & x"00";	-- NOP
tmp(342) := x"4" & '0' & x"09";	-- LDI $9
tmp(343) := x"5" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(344) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(345) := x"1" & '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(346) := x"8" & '0' & x"32";	-- CEQ @50 	# Compara o valor do acumulador (centena) com o valor 0
tmp(347) := x"7" & '1' & x"60";	-- JEQ %zerou 	# Se for igual a 0, vai para o atualiza_displays
tmp(348) := x"3" & '0' & x"33";	-- SUB @51 	# Subtrai 1 no acumulador
tmp(349) := x"5" & '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(350) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- zerou:
tmp(352) := x"0" & '0' & x"00";	-- NOP
tmp(353) := x"4" & '0' & x"00";	-- LDI $0
tmp(354) := x"5" & '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(355) := x"5" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(356) := x"5" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(357) := x"5" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(358) := x"5" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(359) := x"5" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(360) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(361) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- atualiza_displays:
tmp(363) := x"0" & '0' & x"00";	-- NOP
tmp(364) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(365) := x"5" & '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(366) := x"1" & '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(367) := x"5" & '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(368) := x"1" & '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(369) := x"5" & '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(370) := x"1" & '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(371) := x"5" & '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(372) := x"1" & '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(373) := x"5" & '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(374) := x"1" & '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(375) := x"5" & '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(376) := x"0" & '0' & x"00";	-- NOP
tmp(377) := x"9" & '1' & x"8C";	-- JSR %verifica_centena_de_milhar 	# Vai para o label verifica_centena_de_milhar
tmp(378) := x"6" & '0' & x"C3";	-- JMP %le_key 	# Vai para o label le_key
-- atualiza_displays_limites:
tmp(380) := x"0" & '0' & x"00";	-- NOP
tmp(381) := x"1" & '0' & x"0A";	-- LDA @10 	# Carrega o acumulador com o Limites das unidades
tmp(382) := x"5" & '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(383) := x"1" & '0' & x"0B";	-- LDA @11 	# Carrega o acumulador com o Limites das dezenas
tmp(384) := x"5" & '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(385) := x"1" & '0' & x"0C";	-- LDA @12 	# Carrega o acumulador com o Limites de centena
tmp(386) := x"5" & '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(387) := x"1" & '0' & x"0D";	-- LDA @13 	# Carrega o acumulador com o Limites de milhar
tmp(388) := x"5" & '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(389) := x"1" & '0' & x"0E";	-- LDA @14 	# Carrega o acumulador com o Limites de dezena de milhar
tmp(390) := x"5" & '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(391) := x"1" & '0' & x"0F";	-- LDA @15 	# Carrega o acumulador com o Limites de centena de milhar
tmp(392) := x"5" & '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(393) := x"0" & '0' & x"00";	-- NOP
tmp(394) := x"A" & '0' & x"00";	-- RET
-- verifica_centena_de_milhar:
tmp(396) := x"1" & '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(397) := x"8" & '0' & x"0F";	-- CEQ @15 	# Compara o valor do acumulador com o valor maximo de centena de milhar
tmp(398) := x"7" & '1' & x"91";	-- JEQ %verifica_dezena_de_milhar 	# Se for igual, vai para o label verifica_dezena_de_milhar
tmp(399) := x"A" & '0' & x"00";	-- RET
-- verifica_dezena_de_milhar:
tmp(401) := x"1" & '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(402) := x"8" & '0' & x"0E";	-- CEQ @14 	# Compara o valor do acumulador com o valor maximo de dezena de milhar
tmp(403) := x"7" & '1' & x"96";	-- JEQ %verifica_milhar 	# Se for igual, vai para o label verifica_milhar
tmp(404) := x"A" & '0' & x"00";	-- RET
-- verifica_milhar:
tmp(406) := x"1" & '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(407) := x"8" & '0' & x"0D";	-- CEQ @13 	# Compara o valor do acumulador com o valor maximo de milhar
tmp(408) := x"7" & '1' & x"9B";	-- JEQ %verifica_centena 	# Se for igual, vai para o label verifica_centena
tmp(409) := x"A" & '0' & x"00";	-- RET
-- verifica_centena:
tmp(411) := x"1" & '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(412) := x"8" & '0' & x"0C";	-- CEQ @12 	# Compara o valor do acumulador com o valor maximo de centena
tmp(413) := x"7" & '1' & x"A0";	-- JEQ %verifica_dezena 	# Se for igual, vai para o label verifica_dezena
tmp(414) := x"A" & '0' & x"00";	-- RET
-- verifica_dezena:
tmp(416) := x"1" & '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(417) := x"8" & '0' & x"0B";	-- CEQ @11 	# Compara o valor do acumulador com o valor maximo de dezena
tmp(418) := x"7" & '1' & x"A5";	-- JEQ %verifica_unidade 	# Se for igual, vai para o label verifica_unidade
tmp(419) := x"A" & '0' & x"00";	-- RET
-- verifica_unidade:
tmp(421) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(422) := x"8" & '0' & x"0A";	-- CEQ @10 	# Compara o valor do acumulador com o valor maximo de unidade
tmp(423) := x"7" & '1' & x"B9";	-- JEQ %final 	# Se for igual, vai para o label final
tmp(424) := x"A" & '0' & x"00";	-- RET
-- RESET_FPGA:
tmp(426) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(427) := x"5" & '1' & x"FE";	-- STA @510 	# Limpando key 1
tmp(428) := x"5" & '1' & x"FD";	-- STA @509 	# Limpando reset_key
tmp(429) := x"4" & '0' & x"00";	-- LDI $0 	# Carregando 0 no acumulador
tmp(430) := x"5" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(431) := x"5" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(432) := x"5" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(433) := x"5" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar
tmp(434) := x"5" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(435) := x"5" & '0' & x"05";	-- STA @5 	# Limpando endereço de centena de milhar
tmp(436) := x"5" & '1' & x"02";	-- STA @258 	# Desliga led 9
tmp(437) := x"5" & '1' & x"01";	-- STA @257 	# Desliga o led 8
tmp(438) := x"5" & '1' & x"00";	-- STA @256 	# Desliga o led 7 ao led 0
tmp(439) := x"6" & '1' & x"6B";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- final:
tmp(441) := x"0" & '0' & x"00";	-- NOP
tmp(442) := x"1" & '0' & x"33";	-- LDA @51 	# Carrega 1 no acumulador
tmp(443) := x"5" & '1' & x"02";	-- STA @258 	# Liga led 9
tmp(444) := x"5" & '1' & x"01";	-- STA @257 	# Liga o led 8
tmp(445) := x"4" & '0' & x"FF";	-- LDI $255 	# Carrega 255 no acumulador
tmp(446) := x"5" & '1' & x"00";	-- STA @256 	# Liga o led 7 ao led 0
tmp(447) := x"1" & '1' & x"64";	-- LDA @356		# Carrega o acumulador com o endereço de fpga_reset
tmp(448) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(449) := x"7" & '1' & x"AA";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(450) := x"6" & '1' & x"B9";	-- JMP %final

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;