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
tmp(1) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(2) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510, REG0 	# Limpando key 1
tmp(3) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando segundos
tmp(4) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0, REG0 	# Limpando endereço de unidade
tmp(5) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1, REG0 	# Limpando endereço de dezena
tmp(6) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2, REG0 	# Limpando endereço de centena
tmp(7) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3, REG0 	# Limpando endereço de milhar
tmp(8) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4, REG0 	# Limpando endereço de dezena de milhar
tmp(9) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5, REG0 	# Limpando endereço de centena de milhar
tmp(10) := x"5" & "00" & '0'& '1' & x"20";	-- STA @288, REG0 	# Limpando endereço do HEX0
tmp(11) := x"5" & "00" & '0'& '1' & x"21";	-- STA @289, REG0 	# Limpando endereço do HEX1
tmp(12) := x"5" & "00" & '0'& '1' & x"22";	-- STA @290, REG0 	# Limpando endereço do HEX2
tmp(13) := x"5" & "00" & '0'& '1' & x"23";	-- STA @291, REG0 	# Limpando endereço do HEX3
tmp(14) := x"5" & "00" & '0'& '1' & x"24";	-- STA @292, REG0 	# Limpando endereço do HEX4
tmp(15) := x"5" & "00" & '0'& '1' & x"25";	-- STA @293, REG0 	# Limpando endereço do HEX5
tmp(16) := x"5" & "00" & '1' & '1' & x"FF";	-- STA @1023, REG0 	# Limpando endereço do BUZZER
tmp(17) := x"4" & "00" & '0'& '0' & x"07";	-- LDI $7, REG0 	# Carregando 7 no REG0
tmp(18) := x"5" & "00" & '0'& '0' & x"84";	-- STA @132, REG0 	# Liga cor
tmp(19) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5, REG0 	# Carregando 3 no REG0
tmp(20) := x"5" & "00" & '0'& '0' & x"80";	-- STA @128, REG0 	# Carregando 3 na LINHA
tmp(21) := x"4" & "00" & '0'& '0' & x"0B";	-- LDI $11, REG0 	# Carregando 9 no REG0
tmp(22) := x"5" & "00" & '0'& '0' & x"81";	-- STA @129, REG0 	# Carregando 9 na COLUNA
tmp(23) := x"4" & "00" & '0'& '0' & x"1A";	-- LDI $26, REG0 	# Carregando : no REG0
tmp(24) := x"5" & "00" & '0'& '0' & x"82";	-- STA @130, REG0 	# Carregando : na posição 130
tmp(25) := x"5" & "00" & '0'& '0' & x"83";	-- STA @131, REG0 	# Liga VGA
tmp(26) := x"4" & "00" & '0'& '0' & x"08";	-- LDI $8, REG0 	# Carregando 9 no REG0
tmp(27) := x"5" & "00" & '0'& '0' & x"81";	-- STA @129, REG0 	# Carregando 9 na COLUNA
tmp(28) := x"4" & "00" & '0'& '0' & x"1A";	-- LDI $26, REG0 	# Carregando : no REG0
tmp(29) := x"5" & "00" & '0'& '0' & x"82";	-- STA @130, REG0 	# Carregando : na posição 130
tmp(30) := x"5" & "00" & '0'& '0' & x"83";	-- STA @131, REG0 	# Liga VGA
tmp(31) := x"4" & "00" & '0'& '0' & x"02";	-- LDI $2, REG0 	# Carregando 2 no REG0
tmp(32) := x"5" & "00" & '0'& '0' & x"34";	-- STA @52, REG0 	# Carregando 2 na posição 52
tmp(33) := x"4" & "00" & '0'& '0' & x"03";	-- LDI $3, REG0 	# Carregando 4 no REG0
tmp(34) := x"5" & "00" & '0'& '0' & x"35";	-- STA @53, REG0 	# Carregando 4 na posição 53
tmp(35) := x"4" & "00" & '0'& '0' & x"04";	-- LDI $4, REG0 	# Carregando 4 no REG0
tmp(36) := x"5" & "00" & '0'& '0' & x"36";	-- STA @54, REG0 	# Carregando 4 na posição 54
tmp(37) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5, REG0 	# Carregando 5 no REG0
tmp(38) := x"5" & "00" & '0'& '0' & x"37";	-- STA @55, REG0 	# Carregando 5 na posição 55
tmp(39) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9, REG0 	# Carregando 9 no REG0
tmp(40) := x"5" & "00" & '0'& '0' & x"3B";	-- STA @59, REG0 	# Carregando 9 na posição 59
tmp(41) := x"4" & "00" & '0'& '0' & x"0A";	-- LDI $10, REG0 	# Carregando 10 no REG0
tmp(42) := x"5" & "00" & '0'& '0' & x"3C";	-- STA @60, REG0 	# Carergando 10 na posição 60
tmp(43) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1, REG0 	# Carregando 1 no REG0
tmp(44) := x"5" & "00" & '0'& '0' & x"33";	-- STA @51, REG0 	# Carregando 1 na posição 51
tmp(45) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9, REG0
tmp(46) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40, REG0 	# Limpando endereço de temp 1
tmp(47) := x"5" & "00" & '0'& '0' & x"0A";	-- STA @10, REG0 	# Limite das unidades
tmp(48) := x"5" & "00" & '0'& '0' & x"0C";	-- STA @12, REG0 	# Limite das centenas
tmp(49) := x"5" & "00" & '0'& '0' & x"2A";	-- STA @42, REG0 	# Limpando endereço de temp 3
tmp(50) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5 , REG0
tmp(51) := x"5" & "00" & '0'& '0' & x"0B";	-- STA @11, REG0 	# Limite das dezenas
tmp(52) := x"5" & "00" & '0'& '0' & x"29";	-- STA @41, REG0 	# Limpando endereço de temp 2
tmp(53) := x"5" & "00" & '0'& '0' & x"0D";	-- STA @13, REG0 	# Limite dos milhares
tmp(54) := x"5" & "00" & '0'& '0' & x"2B";	-- STA @43, REG0 	# Limpando endereço de temp 4
tmp(55) := x"4" & "00" & '0'& '0' & x"03";	-- LDI $3 , REG0
tmp(56) := x"5" & "00" & '0'& '0' & x"0E";	-- STA @14, REG0 	# Limite das dezenas de milhares
tmp(57) := x"5" & "00" & '0'& '0' & x"2C";	-- STA @44 , REG0	# Limpando endereço de temp 5
tmp(58) := x"4" & "00" & '0'& '0' & x"02";	-- LDI $2, REG0
tmp(59) := x"5" & "00" & '0'& '0' & x"0F";	-- STA @15, REG0 	# Limite das centenas de milhares
tmp(60) := x"5" & "00" & '0'& '0' & x"2D";	-- STA @45, REG0 	# Limpando endereço de temp 6
tmp(61) := x"4" & "00" & '0'& '0' & x"63";	-- LDI $99, REG0 	# Carregando 99 no REG0
tmp(62) := x"5" & "00" & '0'& '0' & x"1D";	-- STA @29, REG0 	# Carregando 100 na posição 29
tmp(63) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carregando 0 no REG0
tmp(64) := x"5" & "00" & '0'& '1' & x"F4";	-- STA @500, REG0 	# Desligando o display 0
tmp(65) := x"5" & "00" & '0'& '0' & x"14";	-- STA @20, REG0 	#temporizador 1
tmp(66) := x"5" & "00" & '0'& '0' & x"15";	-- STA @21, REG0 	#temporizador 2
tmp(67) := x"5" & "00" & '0'& '0' & x"16";	-- STA @22, REG0 	#temporizador 3
tmp(68) := x"5" & "00" & '0'& '0' & x"17";	-- STA @23, REG0 	# PISCA OU NÃO PISCA
tmp(69) := x"6" & "00"& '0' & '1' & x"7D";	-- JMP %le_key 	# Vai para o label le_key
-- temporizador_1_segundo:
tmp(71) := x"1" & "00" & '0'& '0' & x"14";	-- LDA @20, REG0 	# Carrega o REG0 com o endereço de temporizador 1
tmp(72) := x"8" & "00" & '0'& '0' & x"1D";	-- CEQ @29, REG0 	# Compara o valor do REG0 com o valor 99
tmp(73) := x"7" & "00" & '0' & '0' & x"4E";	-- JEQ %temporizador_2_segundo 	# Se for igual, vai para o label temporizador_2_segundo
tmp(74) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(75) := x"5" & "00" & '0'& '0' & x"14";	-- STA @20, REG0 	# Armazena o valor do REG0 no endereço de temporizador 1
tmp(76) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- temporizador_2_segundo:
tmp(78) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(79) := x"5" & "00" & '0'& '0' & x"14";	-- STA @20, REG0 	# Armazena o valor do REG0 no endereço de temporizador 1
tmp(80) := x"1" & "00" & '0'& '0' & x"15";	-- LDA @21, REG0 	# Carrega o REG0 com o endereço de temporizador 2
tmp(81) := x"8" & "00" & '0'& '0' & x"1D";	-- CEQ @29, REG0 	# Compara o valor do REG0 com o valor 99
tmp(82) := x"7" & "00" & '0' & '0' & x"57";	-- JEQ %temporizador_3_segundo 	# Se for igual, vai para o label temporizador_3_segundo
tmp(83) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(84) := x"5" & "00" & '0'& '0' & x"15";	-- STA @21, REG0 	# Armazena o valor do REG0 no endereço de temporizador 2
tmp(85) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- temporizador_3_segundo:
tmp(87) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(88) := x"5" & "00" & '0'& '0' & x"15";	-- STA @21, REG0 	# Armazena o valor do REG0 no endereço de temporizador 2
tmp(89) := x"1" & "00" & '0'& '0' & x"16";	-- LDA @22, REG0 	# Carrega o REG0 com o endereço de temporizador 3
tmp(90) := x"8" & "00" & '0'& '0' & x"1D";	-- CEQ @29, REG0 	# Compara o valor do REG0 com o valor 99
tmp(91) := x"7" & "00" & '0' & '0' & x"60";	-- JEQ %PISCA 	# Se for igual, vai para o label LIMPA
tmp(92) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(93) := x"5" & "00" & '0'& '0' & x"16";	-- STA @22, REG0 	# Armazena o valor do REG0 no endereço de temporizador 3
tmp(94) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- PISCA:
tmp(96) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(97) := x"5" & "00" & '0'& '0' & x"16";	-- STA @22, REG0 	# Limpando temporizador 3
tmp(98) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23, REG0 	# Carrega o REG0 com o endereço de PISCA
tmp(99) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(100) := x"7" & "00" & '0' & '0' & x"69";	-- JEQ %LIMPA 	# Se for igual, vai para o label LIMPA
tmp(101) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1, REG0 	# Carrega 1 no REG0
tmp(102) := x"5" & "00" & '0'& '0' & x"17";	-- STA @23, REG0 	# Armazena o valor do REG0 no endereço de PISCA
tmp(103) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- LIMPA:
tmp(105) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(106) := x"5" & "00" & '0'& '0' & x"17";	-- STA @23, REG0 	# Armazena o valor do REG0 no endereço de PISCA
tmp(107) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_unidades:
tmp(109) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510, REG0 	# Limpando key 1
tmp(110) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(111) := x"9" & "00" & '1' & '0' & x"78";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_unidades:
tmp(113) := x"9" & "00" & '0' & '0' & x"47";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(114) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23, REG0 	# Carrega o REG0 com o endereço de PISCA
tmp(115) := x"5" & "00" & '0'& '1' & x"F4";	-- STA @500, REG0 	# Desliga o display unidade
tmp(116) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353, REG0 	# Carrega o REG0 com o key 1
tmp(117) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(118) := x"7" & "00" & '0' & '0' & x"89";	-- JEQ %define_limites_dezenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(119) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352, REG0 	# Carrega o REG0 com o key 0
tmp(120) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 com o valor 0
tmp(121) := x"7" & "00" & '0' & '0' & x"71";	-- JEQ %checa_limites_unidades 	# Se for igual, vai para o label checa_limites_unidades
tmp(122) := x"9" & "00" & '0' & '0' & x"7D";	-- JSR %adiciona_unidade 	# Se não for igual, vai para o label adiciona_unidade
tmp(123) := x"6" & "00" & '0' & '0' & x"6D";	-- JMP %define_limites_unidades 	# Se não for igual, volta para o label define_limites_unidades
-- adiciona_unidade:
tmp(125) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(126) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40, REG0 	# Carrega o REG0 com o endereço de Limite de unidade
tmp(127) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59, REG0 	# Compara o valor do REG0 com o valor 9
tmp(128) := x"7" & "00" & '0' & '0' & x"85";	-- JEQ %zera_unidade 	# Se for igual, vai para o label zera_unidade
tmp(129) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(130) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40, REG0 	# Armazena o valor do REG0 no endereço de Limite de unidade
tmp(131) := x"A" & "00" & '0' & '0' & x"00";	-- RET 
-- zera_unidade:
tmp(133) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(134) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40, REG0 	# Armazena o valor do REG0 no endereço de Limite de unidade
tmp(135) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_dezenas:
tmp(137) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510, REG0 	# Limpando key 1
tmp(138) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(139) := x"9" & "00" & '1' & '0' & x"78";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas:
tmp(141) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(142) := x"5" & "00" & '0'& '1' & x"F4";	-- STA @500, REG0 	# liga o display unidade
tmp(143) := x"9" & "00" & '0' & '0' & x"47";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(144) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23, REG0 	# Carrega o REG0 com o endereço de PISCA
tmp(145) := x"5" & "00" & '0'& '1' & x"F5";	-- STA @501, REG0 	# Desliga o display unidade
tmp(146) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353, REG0 	# Carrega o REG0 com o key 1
tmp(147) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(148) := x"7" & "00" & '0' & '0' & x"A6";	-- JEQ %define_limites_centenas 	# Se for igual, vai para o label define_limites_dezenas
tmp(149) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352, REG0 	# Carrega o REG0 com o key 0
tmp(150) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 com o valor 0
tmp(151) := x"7" & "00" & '0' & '0' & x"8D";	-- JEQ %checa_limites_dezenas 	# Se for igual, vai para o label checa_limites_dezenas
tmp(152) := x"9" & "00" & '0' & '0' & x"9C";	-- JSR %adiciona_dezena 	# Se não for igual, vai para o label adiciona_dezena
tmp(153) := x"5" & "00" & '0'& '0' & x"29";	-- STA @41, REG0 	# Armazena o valor do REG0 no endereço de Limite de dezenas
tmp(154) := x"6" & "00" & '0' & '0' & x"89";	-- JMP %define_limites_dezenas 	# Se não for igual, volta para o label define_limites_dezenas
-- adiciona_dezena:
tmp(156) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(157) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41, REG0 	# Carrega o REG0 com o endereço de Limite de dezena
tmp(158) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55, REG0 	# Compara o valor do REG0 com o valor 5
tmp(159) := x"7" & "00" & '0' & '0' & x"A3";	-- JEQ %zera_dezena 	# Se for igual, vai para o label zera_dezena
tmp(160) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(161) := x"A" & "00" & '0' & '0' & x"00";	-- RET 
-- zera_dezena:
tmp(163) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(164) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_centenas:
tmp(166) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510, REG0 	# Limpando key 1
tmp(167) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(168) := x"9" & "00" & '1' & '0' & x"78";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas:
tmp(170) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(171) := x"5" & "00" & '0'& '1' & x"F5";	-- STA @501, REG0 	# liga o display DEZENA
tmp(172) := x"9" & "00" & '0' & '0' & x"47";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(173) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23, REG0 	# Carrega o REG0 com o endereço de PISCA
tmp(174) := x"5" & "00" & '0'& '1' & x"F6";	-- STA @502, REG0 	# Desliga o display unidade
tmp(175) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353, REG0 	# Carrega o REG0 com o key 1
tmp(176) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(177) := x"7" & "00" & '0' & '0' & x"C3";	-- JEQ %define_limites_milhares 	# Se for igual, vai para o label define_limites_centenas
tmp(178) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352, REG0 	# Carrega o REG0 com o key 0
tmp(179) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 com o valor 0
tmp(180) := x"7" & "00" & '0' & '0' & x"AA";	-- JEQ %checa_limites_centenas 	# Se for igual, vai para o label checa_limites_centenas
tmp(181) := x"9" & "00" & '0' & '0' & x"B9";	-- JSR %adiciona_centena 	# Se não for igual, vai para o label adiciona_centena
tmp(182) := x"5" & "00" & '0'& '0' & x"2A";	-- STA @42, REG0 	# Armazena o valor do REG0 no endereço de Limite de centenas
tmp(183) := x"6" & "00" & '0' & '0' & x"A6";	-- JMP %define_limites_centenas 	# Se não for igual, volta para o label define_limites_centenas
-- adiciona_centena:
tmp(185) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(186) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42, REG0 	# Carrega o REG0 com o endereço de Limite de centena
tmp(187) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59, REG0 	# Compara o valor do REG0 com o valor 9
tmp(188) := x"7" & "00" & '0' & '0' & x"C0";	-- JEQ %zera_centena 	# Se for igual, vai para o label zera_centena
tmp(189) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(190) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_centena:
tmp(192) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(193) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_milhares:
tmp(195) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510, REG0 	# Limpando key 1
tmp(196) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(197) := x"9" & "00" & '1' & '0' & x"78";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_milhares:
tmp(199) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(200) := x"5" & "00" & '0'& '1' & x"F6";	-- STA @502, REG0 	# liga o display unidade
tmp(201) := x"9" & "00" & '0' & '0' & x"47";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(202) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23, REG0 	# Carrega o REG0 com o endereço de PISCA
tmp(203) := x"5" & "00" & '0'& '1' & x"F7";	-- STA @503, REG0 	# Desliga o display unidade
tmp(204) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353, REG0 	# Carrega o REG0 com o key 1
tmp(205) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(206) := x"7" & "00" & '0' & '0' & x"E0";	-- JEQ %define_limites_dezenas_de_milhares 	# Se for igual, vai para o label define_limites_milhares
tmp(207) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352, REG0 	# Carrega o REG0 com o key 0
tmp(208) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 com o valor 0
tmp(209) := x"7" & "00" & '0' & '0' & x"C7";	-- JEQ %checa_limites_milhares 	# Se for igual, vai para o label checa_limites_milhares
tmp(210) := x"9" & "00" & '0' & '0' & x"D6";	-- JSR %adiciona_milhar 	# Se não for igual, vai para o label adiciona_milhar
tmp(211) := x"5" & "00" & '0'& '0' & x"2B";	-- STA @43, REG0 	# Armazena o valor do REG0 no endereço de Limite de milhares
tmp(212) := x"6" & "00" & '0' & '0' & x"C3";	-- JMP %define_limites_milhares 	# Se não for igual, volta para o label define_limites_milhares
-- adiciona_milhar:
tmp(214) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(215) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43, REG0 	# Carrega o REG0 com o endereço de Limite de milhar
tmp(216) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55, REG0 	# Compara o valor do REG0 com o valor 9
tmp(217) := x"7" & "00" & '0' & '0' & x"DD";	-- JEQ %zera_milhar 	# Se for igual, vai para o label zera_milhar
tmp(218) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(219) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_milhar:
tmp(221) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(222) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_dezenas_de_milhares:
tmp(224) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510, REG0 	# Limpando key 1
tmp(225) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(226) := x"9" & "00" & '1' & '0' & x"78";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_dezenas_de_milhares:
tmp(228) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(229) := x"5" & "00" & '0'& '1' & x"F7";	-- STA @503, REG0 	# liga o display unidade
tmp(230) := x"9" & "00" & '0' & '0' & x"47";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(231) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23, REG0 	# Carrega o REG0 com o endereço de PISCA
tmp(232) := x"5" & "00" & '0'& '1' & x"F8";	-- STA @504, REG0 	# Desliga o display unidade
tmp(233) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353, REG0 	# Carrega o REG0 com o key 1
tmp(234) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(235) := x"7" & "00"& '0' & '1' & x"06";	-- JEQ %define_limites_centenas_de_milhares 	# Se for igual, vai para o label define_limites_dezenas_de_milhares
tmp(236) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352, REG0 	# Carrega o REG0 com o key 0
tmp(237) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 com o valor 0
tmp(238) := x"7" & "00" & '0' & '0' & x"E4";	-- JEQ %checa_limites_dezenas_de_milhares 	# Se for igual, vai para o label checa_limites_dezenas_de_milhares
tmp(239) := x"9" & "00" & '0' & '0' & x"F3";	-- JSR %adiciona_dezena_de_milhar 	# Se não for igual, vai para o label adiciona_dezena_de_milhar
tmp(240) := x"5" & "00" & '0'& '0' & x"2C";	-- STA @44, REG0 	# Armazena o valor do REG0 no endereço de Limite de dezenas de milhares
tmp(241) := x"6" & "00" & '0' & '0' & x"E0";	-- JMP %define_limites_dezenas_de_milhares 	# Se não for igual, volta para o label define_limites_dezenas_de_milhares
-- adiciona_dezena_de_milhar:
tmp(243) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(244) := x"1" & "00" & '0'& '0' & x"0F";	-- LDA @15, REG0 	# Carrega o REG0 com o endereço de Limite de dezena de milhar
tmp(245) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52, REG0 	# Compara o valor do REG0 com o valor 9
tmp(246) := x"7" & "00"& '0' & '1' & x"00";	-- JEQ %limite_caso_20
tmp(247) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44, REG0 	# Carrega o REG0 com o endereço de Limite de dezena de milhar
tmp(248) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59, REG0 	# Compara o valor do REG0 com o valor 9
tmp(249) := x"7" & "00" & '0' & '0' & x"FD";	-- JEQ %zera_dezena_de_milhar 	# Se for igual, vai para o label zera_dezena_de_milhar
tmp(250) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(251) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_dezena_de_milhar:
tmp(253) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(254) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- limite_caso_20:
tmp(256) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44, REG0 	# Carrega o REG0 com o endereço de Limite de dezena de milhar
tmp(257) := x"8" & "00" & '0'& '0' & x"35";	-- CEQ @53, REG0 	# Compara o valor do REG0 com o valor 9
tmp(258) := x"7" & "00" & '0' & '0' & x"FD";	-- JEQ %zera_dezena_de_milhar 	# Se for igual, vai para o label zera_dezena_de_milhar
tmp(259) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(260) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- define_limites_centenas_de_milhares:
tmp(262) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510, REG0 	# Limpando key 1
tmp(263) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(264) := x"5" & "00" & '0'& '1' & x"FD";	-- STA @509, REG0 	# Limpando key2
tmp(265) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando segundos
tmp(266) := x"9" & "00" & '1' & '0' & x"78";	-- JSR %atualiza_displays_limites 	# Vai para o label atualiza_displays_limites
-- checa_limites_centenas_de_milhares:
tmp(268) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(269) := x"5" & "00" & '0'& '1' & x"F8";	-- STA @504, REG0 	# liga o display unidade
tmp(270) := x"9" & "00" & '0' & '0' & x"47";	-- JSR %temporizador_1_segundo 	# Vai para o label temporizador_1_segundo
tmp(271) := x"1" & "00" & '0'& '0' & x"17";	-- LDA @23, REG0 	# Carrega o REG0 com o endereço de PISCA
tmp(272) := x"5" & "00" & '0'& '1' & x"F9";	-- STA @505, REG0 	# Desliga o display unidade
tmp(273) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353, REG0 	# Carrega o REG0 com o key 1
tmp(274) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(275) := x"7" & "00"& '0' & '1' & x"33";	-- JEQ %salva 	# Se for igual, vai para o label salva
tmp(276) := x"1" & "00" & '0'& '1' & x"62";	-- LDA @354, REG0 	# Carrega o REG0 com o key 2
tmp(277) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(278) := x"7" & "00"& '0' & '1' & x"41";	-- JEQ %salva_tempo 	# Se for igual, vai para o label salva
tmp(279) := x"1" & "00" & '0'& '1' & x"60";	-- LDA @352, REG0 	# Carrega o REG0 com o key 0
tmp(280) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 com o valor 0
tmp(281) := x"7" & "00"& '0' & '1' & x"0C";	-- JEQ %checa_limites_centenas_de_milhares 	# Se for igual, vai para o label checa_limites_centenas_de_milhares
tmp(282) := x"9" & "00"& '0' & '1' & x"1E";	-- JSR %adiciona_centena_de_milhar 	# Se não for igual, vai para o label adiciona_centena_de_milhar
tmp(283) := x"5" & "00" & '0'& '0' & x"2D";	-- STA @45, REG0 	# Armazena o valor do REG0 no endereço de Limite de centenas de milhares
tmp(284) := x"6" & "00"& '0' & '1' & x"06";	-- JMP %define_limites_centenas_de_milhares 	# Se não for igual, volta para o label define_limites_centenas_de_milhares
-- adiciona_centena_de_milhar:
tmp(286) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(287) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44, REG0 	# Carrega o REG0 com o endereço de Limite de dezena de milhar
tmp(288) := x"8" & "00" & '0'& '0' & x"36";	-- CEQ @54, REG0 	# Compara o valor do REG0 com o valor 4
tmp(289) := x"C" & "00"& '0' & '1' & x"24";	-- JLT %limite_caso_24 	# Se for menor que 4, vai para o label limite_caso_24
tmp(290) := x"6" & "00"& '0' & '1' & x"2D";	-- JMP %especial_caso_24 	# Se não for menor que 4, vai para o label especial_caso_24
-- limite_caso_24:
tmp(292) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45, REG0 	# Carrega o REG0 com o endereço de Limite de centena de milhar
tmp(293) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52, REG0 	# Compara o valor do REG0 com o valor 2
tmp(294) := x"7" & "00"& '0' & '1' & x"2A";	-- JEQ %zera_centena_de_milhar 	# Se for igual, vai para o label zera_centena_de_milhar
tmp(295) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(296) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- zera_centena_de_milhar:
tmp(298) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 0 no REG0
tmp(299) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- especial_caso_24:
tmp(301) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45, REG0 	# Carrega o REG0 com o endereço de Limite de centena de milhar
tmp(302) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(303) := x"7" & "00"& '0' & '1' & x"2A";	-- JEQ %zera_centena_de_milhar 	# Se for igual, vai para o label zera_centena_de_milhar
tmp(304) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(305) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- salva:
tmp(307) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45, REG0 	# Carrega o REG0 com o endereço de Limite de centena de milhar
tmp(308) := x"5" & "00" & '0'& '0' & x"0F";	-- STA @15, REG0 	# Armazena o valor do REG0 no endereço de Limite de dezena de milhar
tmp(309) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44, REG0 	# Carrega o REG0 com o endereço de Limite de dezena de milhar
tmp(310) := x"5" & "00" & '0'& '0' & x"0E";	-- STA @14, REG0 	# Armazena o valor do REG0 no endereço de Limite de milhares
tmp(311) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43, REG0 	# Carrega o REG0 com o endereço de Limite de milhares
tmp(312) := x"5" & "00" & '0'& '0' & x"0D";	-- STA @13, REG0 	# Armazena o valor do REG0 no endereço de Limite de centenas
tmp(313) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42, REG0 	# Carrega o REG0 com o endereço de Limite de centenas
tmp(314) := x"5" & "00" & '0'& '0' & x"0C";	-- STA @12, REG0 	# Armazena o valor do REG0 no endereço de Limite de dezenas
tmp(315) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41, REG0 	# Carrega o REG0 com o endereço de Limite de dezenas
tmp(316) := x"5" & "00" & '0'& '0' & x"0B";	-- STA @11, REG0 	# Armazena o valor do REG0 no endereço de Limite de unidades
tmp(317) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40, REG0 	# Carrega o REG0 com o endereço de Limite de unidades
tmp(318) := x"5" & "00" & '0'& '0' & x"0A";	-- STA @10, REG0 	# Armazena o valor do REG0 no endereço de Limite de unidades
tmp(319) := x"6" & "00"& '0' & '1' & x"66";	-- JMP %reset_temp 	# Se não for igual, volta para o label define_limites_unidades
-- salva_tempo:
tmp(321) := x"1" & "00" & '0'& '0' & x"2D";	-- LDA @45, REG0 	# Carrega o REG0 com o endereço de Limite de centena de milhar
tmp(322) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5, REG0 	# Armazena o valor do REG0 no endereço de Limite de dezena de milhar
tmp(323) := x"1" & "00" & '0'& '0' & x"2C";	-- LDA @44, REG0 	# Carrega o REG0 com o endereço de Limite de dezena de milhar
tmp(324) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4, REG0 	# Armazena o valor do REG0 no endereço de Limite de milhares
tmp(325) := x"1" & "00" & '0'& '0' & x"2B";	-- LDA @43, REG0 	# Carrega o REG0 com o endereço de Limite de milhares
tmp(326) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3, REG0 	# Armazena o valor do REG0 no endereço de Limite de centenas
tmp(327) := x"1" & "00" & '0'& '0' & x"2A";	-- LDA @42, REG0 	# Carrega o REG0 com o endereço de Limite de centenas
tmp(328) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2, REG0 	# Armazena o valor do REG0 no endereço de Limite de dezenas
tmp(329) := x"1" & "00" & '0'& '0' & x"29";	-- LDA @41, REG0 	# Carrega o REG0 com o endereço de Limite de dezenas
tmp(330) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1, REG0 	# Armazena o valor do REG0 no endereço de Limite de unidades
tmp(331) := x"1" & "00" & '0'& '0' & x"28";	-- LDA @40, REG0 	# Carrega o REG0 com o endereço de Limite de unidades
tmp(332) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0, REG0 	# Armazena o valor do REG0 no endereço de Limite de unidades
tmp(333) := x"4" & "00" & '0'& '0' & x"55";	-- LDI $85, REG0 	# Carrega 85 no REG0
tmp(334) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256, REG0 	# Armazena o valor do REG0 nos LED 7 - 8
tmp(335) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357, REG0 	# Carrega o REG0 com o segundos
tmp(336) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(337) := x"7" & "00"& '0' & '1' & x"54";	-- JEQ %pre_salva_tempo_pt2
tmp(338) := x"6" & "00"& '0' & '1' & x"41";	-- JMP %salva_tempo
-- pre_salva_tempo_pt2:
tmp(340) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando key 0
-- salva_tempo_pt2:
tmp(342) := x"4" & "00" & '0'& '0' & x"55";	-- LDI $85, REG0 	# Carrega 85 no REG0
tmp(343) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256, REG0 	# Armazena o valor do REG0 nos LED 7 - 8
tmp(344) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357, REG0 	# Carrega o REG0 com o segundos
tmp(345) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(346) := x"7" & "00"& '0' & '1' & x"5D";	-- JEQ %pre_salva_tempo_pt3 	# Se não for igual, volta para o label define_limites_unidades
tmp(347) := x"6" & "00"& '0' & '1' & x"56";	-- JMP %salva_tempo_pt2
-- pre_salva_tempo_pt3:
tmp(349) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando key 0
-- salva_tempo_pt3:
tmp(351) := x"4" & "00" & '0'& '0' & x"AA";	-- LDI $170, REG0 	# Carrega 85 no REG0
tmp(352) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256, REG0 	# Armazena o valor do REG0 nos LED 7 - 8
tmp(353) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357, REG0 	# Carrega o REG0 com o segundos
tmp(354) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(355) := x"7" & "00"& '0' & '1' & x"66";	-- JEQ %reset_temp 	# Se não for igual, volta para o label define_limites_unidades
tmp(356) := x"6" & "00"& '0' & '1' & x"5F";	-- JMP %salva_tempo_pt3
-- reset_temp:
tmp(358) := x"1" & "00" & '0'& '0' & x"0A";	-- LDA @10, REG0 	# Carrega o REG0 com o endereço de Limite de unidades
tmp(359) := x"5" & "00" & '0'& '0' & x"28";	-- STA @40, REG0 	# Limpando endereço de temp 1
tmp(360) := x"1" & "00" & '0'& '0' & x"0C";	-- LDA @12, REG0 	# Carrega o REG0 com o endereço de Limite de CENTENAS
tmp(361) := x"5" & "00" & '0'& '0' & x"2A";	-- STA @42, REG0 	# Limpando endereço de temp 3
tmp(362) := x"1" & "00" & '0'& '0' & x"0B";	-- LDA @11, REG0 	# Carrega o REG0 com o endereço de Limite de CENTENAS
tmp(363) := x"5" & "00" & '0'& '0' & x"29";	-- STA @41, REG0 	# Limpando endereço de temp 2
tmp(364) := x"1" & "00" & '0'& '0' & x"0D";	-- LDA @13, REG0 	# Carrega o REG0 com o endereço de Limite de CENTENAS
tmp(365) := x"5" & "00" & '0'& '0' & x"2B";	-- STA @43, REG0 	# Limpando endereço de temp 4
tmp(366) := x"1" & "00" & '0'& '0' & x"0E";	-- LDA @14, REG0 	# Carrega o REG0 com o endereço de Limite de CENTENAS
tmp(367) := x"5" & "00" & '0'& '0' & x"2C";	-- STA @44, REG0 	# Limpando endereço de temp 5
tmp(368) := x"1" & "00" & '0'& '0' & x"0F";	-- LDA @15, REG0 	# Carrega o REG0 com o endereço de Limite de CENTENAS
tmp(369) := x"5" & "00" & '0'& '0' & x"2D";	-- STA @45, REG0 	# Limpando endereço de temp 6
tmp(370) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 85 no REG0
tmp(371) := x"5" & "00" & '0'& '1' & x"00";	-- STA @256, REG0 	# Armazena o valor do REG0 nos LED 7 - 8
tmp(372) := x"6" & "00"& '0' & '1' & x"76";	-- JMP %pre_le_key
-- pre_le_key:
tmp(374) := x"5" & "00" & '0'& '1' & x"FF";	-- STA @511, REG0 	# Limpando key 0
tmp(375) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510, REG0 	# Limpando key 1
tmp(376) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega 1 no REG0
tmp(377) := x"5" & "00" & '0'& '1' & x"F9";	-- STA @505, REG0 	# Liga o display 0
tmp(378) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays
tmp(379) := x"6" & "00"& '0' & '1' & x"7D";	-- JMP %le_key 	# Vai para o label le_key
-- le_key:
tmp(381) := x"1" & "00" & '0'& '1' & x"65";	-- LDA @357, REG0 	# Carrega o REG0 com o segundos
tmp(382) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(383) := x"7" & "00"& '0' & '1' & x"AA";	-- JEQ %incrementa_unidade 	# Se for igual, vai para o label incrementa
tmp(384) := x"1" & "00" & '0'& '1' & x"61";	-- LDA @353, REG0 	# Carrega o REG0 com o key 1
tmp(385) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(386) := x"7" & "00" & '0' & '0' & x"6D";	-- JEQ %define_limites_unidades 	# Se for igual, vai para o label incrementa
tmp(387) := x"9" & "00"& '0' & '1' & x"8A";	-- JSR %checa_op 	# checa se é + ou -
tmp(388) := x"9" & "00"& '0' & '1' & x"95";	-- JSR %checa_timer 	# checa se ta ligado ou nao
tmp(389) := x"1" & "00" & '0'& '1' & x"64";	-- LDA @356, REG0		# Carrega o REG0 com o endereço de fpga_reset
tmp(390) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(391) := x"7" & "00" & '1' & '0' & x"A9";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(392) := x"6" & "00"& '0' & '1' & x"7D";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- checa_op:
tmp(394) := x"1" & "00" & '0'& '1' & x"42";	-- LDA @322, REG0 	# Carrega o REG0 com o endereço de SW9
tmp(395) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 com o valor 0
tmp(396) := x"7" & "00"& '0' & '1' & x"91";	-- JEQ %mais 	# Se for igual, vai para o label le_key
tmp(397) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1, REG0 	# Carrega o REG0 com o valor 1
tmp(398) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258, REG0 	# Liga led 9
tmp(399) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- mais:
tmp(401) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega o REG0 com o valor 1
tmp(402) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258, REG0 	# Liga led 9
tmp(403) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- checa_timer:
tmp(405) := x"1" & "00" & '0'& '1' & x"41";	-- LDA @321, REG0 	# Carrega o REG0 com o endereço de SW8
tmp(406) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 com o valor 0
tmp(407) := x"7" & "00"& '0' & '1' & x"A1";	-- JEQ %desativado 	# Se for igual, vai para o label desativado
tmp(408) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1, REG0 	# Carrega o REG0 com o valor 1
tmp(409) := x"5" & "00" & '0'& '1' & x"01";	-- STA @257, REG0 	# Liga led 8
tmp(410) := x"4" & "10" & '0'& '0' & x"3D";	-- LDI $61, REG2 	# Carrega o REG2 com o valor 61
tmp(411) := x"5" & "10" & '0'& '0' & x"82";	-- STA @130, REG2 	# Armazena o valor do REG2 no endereço do alarme
tmp(412) := x"4" & "10" & '0'& '0' & x"0F";	-- LDI $15, REG2 	# Carrega o REG2 com o valor 10
tmp(413) := x"5" & "10" & '0'& '0' & x"81";	-- STA @129, REG2 	# Armazena o valor do REG2 no endereço do alarme
tmp(414) := x"5" & "10" & '0'& '0' & x"83";	-- STA @131, REG2 	# Habilita VGA
tmp(415) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- desativado:
tmp(417) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega o REG0 com o valor 1
tmp(418) := x"5" & "00" & '0'& '1' & x"01";	-- STA @257, REG0 	# Liga led 8
tmp(419) := x"4" & "10" & '0'& '0' & x"40";	-- LDI $64, REG2 	# Carrega o REG2 com o valor 64 vazio
tmp(420) := x"5" & "10" & '0'& '0' & x"82";	-- STA @130, REG2 	# Armazena o valor do REG2 no endereço do alarme
tmp(421) := x"4" & "10" & '0'& '0' & x"0F";	-- LDI $15, REG2 	# Carrega o REG2 com o valor 10
tmp(422) := x"5" & "10" & '0'& '0' & x"81";	-- STA @129, REG2 	# Armazena o valor do REG2 no endereço do alarme
tmp(423) := x"5" & "10" & '0'& '0' & x"83";	-- STA @131, REG2 	# Habilita VGA
tmp(424) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- incrementa_unidade:
tmp(426) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando key 0
tmp(427) := x"1" & "00" & '0'& '1' & x"42";	-- LDA @322, REG0 	# Carrega o REG0 com o endereço de SW9
tmp(428) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(429) := x"7" & "00"& '0' & '1' & x"B7";	-- JEQ %sub_unidade 	# Se for igual, vai para o label sub_unidade
tmp(430) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0, REG0 	# Carrega o REG0 com o endereço de unidade
tmp(431) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59, REG0 	# Compara o valor do REG0 com o valor 9
tmp(432) := x"7" & "00"& '0' & '1' & x"BE";	-- JEQ %incrementa_dezena 	# Se for igual, vai para o label incrementa_dezena
tmp(433) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(434) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0, REG0 	# Armazena o valor do REG0 no endereço de unidade
tmp(435) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0 	# Carrega o REG0 com o valor 1
tmp(436) := x"5" & "00" & '0'& '1' & x"02";	-- STA @258, REG0 	# Desliga led 9
tmp(437) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- sub_unidade:
tmp(439) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0, REG0 	# Carrega o REG0 com o endereço de unidade
tmp(440) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 com o valor 0
tmp(441) := x"7" & "00"& '0' & '1' & x"C8";	-- JEQ %decremeta_dezena 	# Se for igual, vai para o label decremeta_dezena
tmp(442) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51, REG0 	# Subtrai 1 no REG0
tmp(443) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0, REG0 	# Armazena o valor do REG0 no endereço de unidade
tmp(444) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- incrementa_dezena:
tmp(446) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0
tmp(447) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0, REG0 	# Limpando endereço de unidade
tmp(448) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(449) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1, REG0 	# Carregar o REG0 com o endereço da dezena
tmp(450) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55, REG0 	# Compara o valor do REG0 (dezena) com o valor 9
tmp(451) := x"7" & "00"& '0' & '1' & x"D2";	-- JEQ %incrementa_centena 	# Se for igual a 9, vai para o incrementa_centena
tmp(452) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(453) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1, REG0 	# Armazena o valor do REG0 no endereço das dezenas
tmp(454) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_dezena:
tmp(456) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9, REG0
tmp(457) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0, REG0 	# Limpando endereço de unidade
tmp(458) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(459) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1, REG0 	# Carregar o REG0 com o endereço da dezena
tmp(460) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 (dezena) com o valor 0
tmp(461) := x"7" & "00"& '0' & '1' & x"DC";	-- JEQ %decremeta_centena 	# Se for igual a 0, vai para o decremeta_centena
tmp(462) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51, REG0 	# Subtrai 1 no REG0
tmp(463) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1, REG0 	# Armazena o valor do REG0 no endereço das dezenas
tmp(464) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena:
tmp(466) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0
tmp(467) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1, REG0 	# Limpando endereço de dezena
tmp(468) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(469) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2, REG0 	# Carregar o REG0 com o endereço da centena
tmp(470) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59, REG0 	# Compara o valor do REG0 (centena) com o valor 9
tmp(471) := x"7" & "00"& '0' & '1' & x"E6";	-- JEQ %incrementa_milhar 	# Se for igual a 9, vai para o incrementa_milhar
tmp(472) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(473) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2, REG0 	# Armazena o valor do REG0 no endereço das centenas
tmp(474) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena:
tmp(476) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5, REG0
tmp(477) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1, REG0 	# Limpando endereço de dezena
tmp(478) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(479) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2, REG0 	# Carregar o REG0 com o endereço da centena
tmp(480) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 (centena) com o valor 0
tmp(481) := x"7" & "00"& '0' & '1' & x"F0";	-- JEQ %decremeta_milhar 	# Se for igual a 0, vai para o decremeta_milhar
tmp(482) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51, REG0 	# Subtrai 1 no REG0
tmp(483) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2, REG0 	# Armazena o valor do REG0 no endereço das centenas
tmp(484) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_milhar:
tmp(486) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0
tmp(487) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2, REG0 	# Limpando endereço de centena
tmp(488) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(489) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3, REG0 	# Carregar o REG0 com o endereço da milhares
tmp(490) := x"8" & "00" & '0'& '0' & x"37";	-- CEQ @55, REG0 	# Compara o valor do REG0 (dezena) com o valor 9
tmp(491) := x"7" & "00"& '0' & '1' & x"FA";	-- JEQ %incrementa_dezena_de_milhar 	# Se for igual a 9, vai para o incrementa_dezena_de_milhar
tmp(492) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(493) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3, REG0 	# Armazena o valor do REG0 no endereço das milhares
tmp(494) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- decremeta_milhar:
tmp(496) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9, REG0
tmp(497) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2, REG0 	# Limpando endereço de centena
tmp(498) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(499) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3, REG0 	# Carregar o REG0 com o endereço da milhares
tmp(500) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 (dezena) com o valor 0
tmp(501) := x"7" & "00" & '1' & '0' & x"0D";	-- JEQ %decremeta_dezena_de_milhar 	# Se for igual a 0, vai para o decremeta_dezena_de_milhar
tmp(502) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51, REG0 	# Subtrai 1 no REG0
tmp(503) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3, REG0 	# Armazena o valor do REG0 no endereço das milhares
tmp(504) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- incrementa_dezena_de_milhar:
tmp(506) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0
tmp(507) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3, REG0 	# Limpando endereço de milhar (RAM 3)
tmp(508) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(509) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5, REG0 	# Carregar o REG0 com o endereço da centena de milhar
tmp(510) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52, REG0 	# Compara o valor do REG0 (dezena) com o valor 2
tmp(511) := x"7" & "00" & '1' & '0' & x"08";	-- JEQ %outro_incremente_dezena_de_milhar 	# Se for igual a 2, vai para o incremenoutro_incremente_dezena_de_milharta_centena_milhar
tmp(512) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4, REG0 	# Carregar o REG0 com o endereço da dezena de milhar
tmp(513) := x"8" & "00" & '0'& '0' & x"3B";	-- CEQ @59, REG0 	# Compara o valor do REG0 (dezena) com o valor 9
tmp(514) := x"7" & "00" & '1' & '0' & x"17";	-- JEQ %incrementa_centena_milhar 	# Se for igual a 9, vai para o incrementa_centena_milhar
-- volta:
tmp(516) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(517) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4, REG0 	# Armazena o valor do REG0 no endereço das milhares
tmp(518) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- outro_incremente_dezena_de_milhar:
tmp(520) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4, REG0 	# Carregar o REG0 com o endereço da dezena de milhar
tmp(521) := x"8" & "00" & '0'& '0' & x"35";	-- CEQ @53, REG0 	# Compara o valor do REG0 (dezena) com o valor 9
tmp(522) := x"7" & "00" & '1' & '0' & x"17";	-- JEQ %incrementa_centena_milhar 	# Se for igual a 9, vai para o incrementa_centena_milhar
tmp(523) := x"6" & "00" & '1' & '0' & x"04";	-- JMP %volta 	# Se não for igual, volta para o label volta
-- decremeta_dezena_de_milhar:
tmp(525) := x"4" & "00" & '0'& '0' & x"05";	-- LDI $5, REG0
tmp(526) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3, REG0 	# Limpando endereço de milhar (RAM 3)
tmp(527) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(528) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4, REG0 	# Carregar o REG0 com o endereço da dezena de milhar
tmp(529) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 (dezena) com o valor 0
tmp(530) := x"7" & "00" & '1' & '0' & x"21";	-- JEQ %decremeta_centena_milhar 	# Se for igual a 0, vai para o decremeta_centena_milhar
tmp(531) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51, REG0 	# Subtrai 1 no REG0
tmp(532) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4, REG0 	# Armazena o valor do REG0 no endereço das milhares
tmp(533) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena_milhar:
tmp(535) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0
tmp(536) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4, REG0 	# Limpando endereço de dezena de milhar
tmp(537) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(538) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5, REG0 	# Carregar o REG0 com o endereço da centena
tmp(539) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52, REG0 	# Compara o valor do REG0 (centena) com o valor 9
tmp(540) := x"7" & "00" & '1' & '0' & x"33";	-- JEQ %zerou 	# Se for igual a 9, vai para o atualiza_displays
tmp(541) := x"2" & "00" & '0'& '0' & x"33";	-- SOMA @51, REG0 	# Soma 1 no REG0
tmp(542) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5, REG0 	# Armazena o valor do REG0 no endereço das centenas
tmp(543) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- decremeta_centena_milhar:
tmp(545) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5, REG0 	# Carrega o REG0 com o endereço de centena de milhar
tmp(546) := x"8" & "00" & '0'& '0' & x"34";	-- CEQ @52, REG0 	# Compara o valor do REG0 com o valor 2 (limite de centena de milhar)
tmp(547) := x"7" & "00" & '1' & '0' & x"2F";	-- JEQ %caso20 	# Se for igual, vai para o label caso20
tmp(548) := x"4" & "00" & '0'& '0' & x"03";	-- LDI $3, REG0
tmp(549) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4, REG0 	# Limpando endereço de dezena de milhar
-- volta_caso20:
tmp(551) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(552) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5, REG0 	# Carregar o REG0 com o endereço da centena
tmp(553) := x"8" & "00" & '0'& '0' & x"32";	-- CEQ @50, REG0 	# Compara o valor do REG0 (centena) com o valor 0
tmp(554) := x"7" & "00" & '1' & '0' & x"33";	-- JEQ %zerou 	# Se for igual a 0, vai para o atualiza_displays
tmp(555) := x"3" & "00" & '0'& '0' & x"33";	-- SUB @51, REG0 	# Subtrai 1 no REG0
tmp(556) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5, REG0 	# Armazena o valor do REG0 no endereço das centenas
tmp(557) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- caso20:
tmp(559) := x"4" & "00" & '0'& '0' & x"09";	-- LDI $9, REG0  
tmp(560) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4, REG0 	# Limpando endereço de dezena de milhar
tmp(561) := x"6" & "00" & '1' & '0' & x"27";	-- JMP %volta_caso20 	# Se não for igual, volta para o label volta_caso20
-- zerou:
tmp(563) := x"4" & "00" & '0'& '0' & x"00";	-- LDI $0, REG0
tmp(564) := x"5" & "00" & '0'& '0' & x"05";	-- STA @5, REG0 	# Limpando endereço de centena de milhar
tmp(565) := x"5" & "00" & '0'& '0' & x"04";	-- STA @4, REG0 	# Limpando endereço de dezena de milhar
tmp(566) := x"5" & "00" & '0'& '0' & x"03";	-- STA @3, REG0 	# Limpando endereço de milhar
tmp(567) := x"5" & "00" & '0'& '0' & x"02";	-- STA @2, REG0 	# Limpando endereço de centena
tmp(568) := x"5" & "00" & '0'& '0' & x"01";	-- STA @1, REG0 	# Limpando endereço de dezena
tmp(569) := x"5" & "00" & '0'& '0' & x"00";	-- STA @0, REG0 	# Limpando endereço de unidade
tmp(570) := x"1" & "00" & '0'& '1' & x"42";	-- LDA @322, REG0 	# Carrega o REG0 com o endereço de SW9
tmp(571) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 1
tmp(572) := x"7" & "00" & '1' & '0' & x"B5";	-- JEQ %final 	# Se for igual, vai para o label final
tmp(573) := x"5" & "00" & '0'& '1' & x"FC";	-- STA @508, REG0 	# Limpando Key 0
tmp(574) := x"5" & "00" & '0'& '1' & x"FE";	-- STA @510, REG0 	# Limpando Key 1
tmp(575) := x"4" & "00" & '0'& '0' & x"01";	-- LDI $1, REG0 	# Carrega 2 no REG0
tmp(576) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- atualiza_displays:
tmp(578) := x"1" & "01" & '0'& '0' & x"00";	-- LDA @0, REG1 	# Carrega o REG1 com o endereço de unidade
tmp(579) := x"5" & "01" & '0'& '1' & x"20";	-- STA @288, REG1 	# Armazena o valor do REG1 no endereço do HEX0
tmp(580) := x"1" & "01" & '0'& '0' & x"01";	-- LDA @1, REG1 	# Carrega o REG1 com o endereço de dezena
tmp(581) := x"5" & "01" & '0'& '1' & x"21";	-- STA @289, REG1 	# Armazena o valor do REG1 no endereço do HEX1
tmp(582) := x"1" & "01" & '0'& '0' & x"02";	-- LDA @2, REG1 	# Carrega o REG1 com o endereço de centena
tmp(583) := x"5" & "01" & '0'& '1' & x"22";	-- STA @290, REG1 	# Armazena o valor do REG1 no endereço do HEX2
tmp(584) := x"1" & "01" & '0'& '0' & x"03";	-- LDA @3, REG1 	# Carrega o REG1 com o endereço de milhar
tmp(585) := x"5" & "01" & '0'& '1' & x"23";	-- STA @291, REG1 	# Armazena o valor do REG1 no endereço do HEX3
tmp(586) := x"1" & "01" & '0'& '0' & x"04";	-- LDA @4, REG1 	# Carrega o REG1 com o endereço de dezena de milhar
tmp(587) := x"5" & "01" & '0'& '1' & x"24";	-- STA @292, REG1 	# Armazena o valor do REG1 no endereço do HEX4
tmp(588) := x"1" & "01" & '0'& '0' & x"05";	-- LDA @5, REG1 	# Carrega o REG1 com o endereço de centena de milhar
tmp(589) := x"5" & "01" & '0'& '1' & x"25";	-- STA @293, REG1 	# Armazena o valor do REG1 no endereço do HEX5
tmp(590) := x"9" & "00" & '1' & '0' & x"52";	-- JSR %atualiza_vga 	# Vai para o label atualiza_vga
tmp(591) := x"9" & "00" & '1' & '0' & x"86";	-- JSR %verifica_centena_de_milhar 	# Vai para o label verifica_centena_de_milhar
tmp(592) := x"6" & "00"& '0' & '1' & x"7D";	-- JMP %le_key 	# Vai para o label le_key
-- atualiza_vga:
tmp(594) := x"4" & "10" & '0'& '0' & x"10";	-- LDI $16, REG2 	# Carrega o REG2 com o valor 16
tmp(595) := x"2" & "10" & '0'& '0' & x"00";	-- SOMA @0, REG2 	# Soma 16 no REG2
tmp(596) := x"5" & "10" & '0'& '0' & x"82";	-- STA @ 130, REG2 	# Armazena o valor do REG2 no endereço dos caracteres
tmp(597) := x"4" & "10" & '0'& '0' & x"0D";	-- LDI $13, REG2 	# Carrega o REG2 com o valor 13
tmp(598) := x"5" & "10" & '0'& '0' & x"81";	-- STA @129, REG2 	# Armazena o valor do REG2 na COLUNA
tmp(599) := x"5" & "10" & '0'& '0' & x"83";	-- STA @131, REG2 	# HABILITA VGA
tmp(600) := x"4" & "10" & '0'& '0' & x"10";	-- LDI $16, REG2 	# Carrega o REG2 com o valor 16
tmp(601) := x"2" & "10" & '0'& '0' & x"01";	-- SOMA @1, REG2 	# Soma 16 no REG2
tmp(602) := x"5" & "10" & '0'& '0' & x"82";	-- STA @ 130, REG2 	# Armazena o valor do REG2 no endereço dos caracteres
tmp(603) := x"4" & "10" & '0'& '0' & x"0C";	-- LDI $12, REG2 	# Carrega o REG2 com o valor 12
tmp(604) := x"5" & "10" & '0'& '0' & x"81";	-- STA @129, REG2 	# Armazena o valor do REG2 na COLUNA
tmp(605) := x"5" & "10" & '0'& '0' & x"83";	-- STA @131, REG2 	# HABILITA VGA
tmp(606) := x"4" & "10" & '0'& '0' & x"10";	-- LDI $16, REG2 	# Carrega o REG2 com o valor 16
tmp(607) := x"2" & "10" & '0'& '0' & x"02";	-- SOMA @2, REG2 	# Soma 16 no REG2
tmp(608) := x"5" & "10" & '0'& '0' & x"82";	-- STA @ 130, REG2 	# Armazena o valor do REG2 no endereço dos caracteres
tmp(609) := x"4" & "10" & '0'& '0' & x"0A";	-- LDI $10, REG2 	# Carrega o REG2 com o valor 12
tmp(610) := x"5" & "10" & '0'& '0' & x"81";	-- STA @129, REG2 	# Armazena o valor do REG2 na COLUNA
tmp(611) := x"5" & "10" & '0'& '0' & x"83";	-- STA @131, REG2 	# HABILITA VGA
tmp(612) := x"4" & "10" & '0'& '0' & x"10";	-- LDI $16, REG2 	# Carrega o REG2 com o valor 16
tmp(613) := x"2" & "10" & '0'& '0' & x"03";	-- SOMA @3, REG2 	# Soma 16 no REG2
tmp(614) := x"5" & "10" & '0'& '0' & x"82";	-- STA @ 130, REG2 	# Armazena o valor do REG2 no endereço dos caracteres
tmp(615) := x"4" & "10" & '0'& '0' & x"09";	-- LDI $9, REG2 	# Carrega o REG2 com o valor 12
tmp(616) := x"5" & "10" & '0'& '0' & x"81";	-- STA @129, REG2 	# Armazena o valor do REG2 na COLUNA
tmp(617) := x"5" & "10" & '0'& '0' & x"83";	-- STA @131, REG2 	# HABILITA VGA
tmp(618) := x"4" & "10" & '0'& '0' & x"10";	-- LDI $16, REG2 	# Carrega o REG2 com o valor 16
tmp(619) := x"2" & "10" & '0'& '0' & x"04";	-- SOMA @4, REG2 	# Soma 16 no REG2
tmp(620) := x"5" & "10" & '0'& '0' & x"82";	-- STA @ 130, REG2 	# Armazena o valor do REG2 no endereço dos caracteres
tmp(621) := x"4" & "10" & '0'& '0' & x"07";	-- LDI $7, REG2 	# Carrega o REG2 com o valor 12
tmp(622) := x"5" & "10" & '0'& '0' & x"81";	-- STA @129, REG2 	# Armazena o valor do REG2 na COLUNA
tmp(623) := x"5" & "10" & '0'& '0' & x"83";	-- STA @131, REG2 	# HABILITA VGA
tmp(624) := x"4" & "10" & '0'& '0' & x"10";	-- LDI $16, REG2 	# Carrega o REG2 com o valor 16
tmp(625) := x"2" & "10" & '0'& '0' & x"05";	-- SOMA @5, REG2 	# Soma 16 no REG2
tmp(626) := x"5" & "10" & '0'& '0' & x"82";	-- STA @ 130, REG2 	# Armazena o valor do REG2 no endereço dos caracteres
tmp(627) := x"4" & "10" & '0'& '0' & x"06";	-- LDI $6, REG2 	# Carrega o REG2 com o valor 12
tmp(628) := x"5" & "10" & '0'& '0' & x"81";	-- STA @129, REG2 	# Armazena o valor do REG2 na COLUNA
tmp(629) := x"5" & "10" & '0'& '0' & x"83";	-- STA @131, REG2 	# HABILITA VGA
tmp(630) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- atualiza_displays_limites:
tmp(632) := x"1" & "01" & '0'& '0' & x"28";	-- LDA @40, REG1 	# Carrega o REG1 com o Limites das unidades
tmp(633) := x"5" & "01" & '0'& '1' & x"20";	-- STA @288, REG1 	# Armazena o valor do REG1 no endereço do HEX0
tmp(634) := x"1" & "01" & '0'& '0' & x"29";	-- LDA @41, REG1 	# Carrega o REG1 com o Limites das dezenas
tmp(635) := x"5" & "01" & '0'& '1' & x"21";	-- STA @289, REG1 	# Armazena o valor do REG1 no endereço do HEX1
tmp(636) := x"1" & "01" & '0'& '0' & x"2A";	-- LDA @42, REG1 	# Carrega o REG1 com o Limites de centena
tmp(637) := x"5" & "01" & '0'& '1' & x"22";	-- STA @290, REG1 	# Armazena o valor do REG1 no endereço do HEX2
tmp(638) := x"1" & "01" & '0'& '0' & x"2B";	-- LDA @43, REG1 	# Carrega o REG1 com o Limites de milhar
tmp(639) := x"5" & "01" & '0'& '1' & x"23";	-- STA @291, REG1 	# Armazena o valor do REG1 no endereço do HEX3
tmp(640) := x"1" & "01" & '0'& '0' & x"2C";	-- LDA @44, REG1 	# Carrega o REG1 com o Limites de dezena de milhar
tmp(641) := x"5" & "01" & '0'& '1' & x"24";	-- STA @292, REG1 	# Armazena o valor do REG1 no endereço do HEX4
tmp(642) := x"1" & "01" & '0'& '0' & x"2D";	-- LDA @45, REG1 	# Carrega o REG1 com o Limites de centena de milhar
tmp(643) := x"5" & "01" & '0'& '1' & x"25";	-- STA @293, REG1 	# Armazena o valor do REG1 no endereço do HEX5
tmp(644) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_centena_de_milhar:
tmp(646) := x"1" & "00" & '0'& '1' & x"41";	-- LDA @321, REG0 	# Carrega o REG0 com o endereço de SW8
tmp(647) := x"8" & "00" & '0'& '0' & x"33";	-- CEQ @51, REG0 	# Compara o valor do REG0 com o valor 0
tmp(648) := x"7" & "00" & '1' & '0' & x"8B";	-- JEQ %continua_verifica_centena_de_milhar 	# Se for igual, vai para o label continua_verifica_centena_de_milhar
tmp(649) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- continua_verifica_centena_de_milhar: 
tmp(651) := x"1" & "00" & '0'& '0' & x"05";	-- LDA @5, REG0 	# Carrega o REG0 com o endereço de centena de milhar
tmp(652) := x"8" & "00" & '0'& '0' & x"0F";	-- CEQ @15, REG0 	# Compara o valor do REG0 com o valor maximo de centena de milhar
tmp(653) := x"7" & "00" & '1' & '0' & x"90";	-- JEQ %verifica_dezena_de_milhar 	# Se for igual, vai para o label verifica_dezena_de_milhar
tmp(654) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_dezena_de_milhar:
tmp(656) := x"1" & "00" & '0'& '0' & x"04";	-- LDA @4, REG0 	# Carrega o REG0 com o endereço de dezena de milhar
tmp(657) := x"8" & "00" & '0'& '0' & x"0E";	-- CEQ @14, REG0 	# Compara o valor do REG0 com o valor maximo de dezena de milhar
tmp(658) := x"7" & "00" & '1' & '0' & x"95";	-- JEQ %verifica_milhar 	# Se for igual, vai para o label verifica_milhar
tmp(659) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_milhar:
tmp(661) := x"1" & "00" & '0'& '0' & x"03";	-- LDA @3, REG0 	# Carrega o REG0 com o endereço de milhar
tmp(662) := x"8" & "00" & '0'& '0' & x"0D";	-- CEQ @13, REG0 	# Compara o valor do REG0 com o valor maximo de milhar
tmp(663) := x"7" & "00" & '1' & '0' & x"9A";	-- JEQ %verifica_centena 	# Se for igual, vai para o label verifica_centena
tmp(664) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_centena:
tmp(666) := x"1" & "00" & '0'& '0' & x"02";	-- LDA @2, REG0 	# Carrega o REG0 com o endereço de centena
tmp(667) := x"8" & "00" & '0'& '0' & x"0C";	-- CEQ @12, REG0 	# Compara o valor do REG0 com o valor maximo de centena
tmp(668) := x"7" & "00" & '1' & '0' & x"9F";	-- JEQ %verifica_dezena 	# Se for igual, vai para o label verifica_dezena
tmp(669) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_dezena:
tmp(671) := x"1" & "00" & '0'& '0' & x"01";	-- LDA @1, REG0 	# Carrega o REG0 com o endereço de dezena
tmp(672) := x"8" & "00" & '0'& '0' & x"0B";	-- CEQ @11, REG0 	# Compara o valor do REG0 com o valor maximo de dezena
tmp(673) := x"7" & "00" & '1' & '0' & x"A4";	-- JEQ %verifica_unidade 	# Se for igual, vai para o label verifica_unidade
tmp(674) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- verifica_unidade:
tmp(676) := x"1" & "00" & '0'& '0' & x"00";	-- LDA @0, REG0 	# Carrega o REG0 com o endereço de unidade
tmp(677) := x"8" & "00" & '0'& '0' & x"0A";	-- CEQ @10, REG0 	# Compara o valor do REG0 com o valor maximo de unidade
tmp(678) := x"7" & "00" & '1' & '0' & x"B5";	-- JEQ %final 	# Se for igual, vai para o label final
tmp(679) := x"A" & "00" & '0' & '0' & x"00";	-- RET
-- RESET_FPGA:
tmp(681) := x"5" & "01" & '0'& '1' & x"FF";	-- STA @511, REG1 	# Limpando key 0
tmp(682) := x"5" & "01" & '0'& '1' & x"FE";	-- STA @510, REG1 	# Limpando key 1
tmp(683) := x"5" & "01" & '0'& '1' & x"FC";	-- STA @508, REG1 	# Limpando reset_key
tmp(684) := x"4" & "01" & '0'& '0' & x"00";	-- LDI $0, REG1 	# Carregando 0 no REG1
tmp(685) := x"5" & "01" & '0'& '1' & x"02";	-- STA @258, REG1 	# Desliga led 9
tmp(686) := x"5" & "01" & '0'& '1' & x"01";	-- STA @257, REG1 	# Desliga o led 8
tmp(687) := x"5" & "01" & '0'& '1' & x"00";	-- STA @256, REG1 	# Desliga o led 7 ao led 0
tmp(688) := x"5" & "01" & '1' & '1' & x"FF";	-- STA @1023, REG1 	# Desliga o BUZZER
tmp(689) := x"4" & "01" & '0'& '0' & x"07";	-- LDI $7, REG1 	# Carregando 7 no REG1
tmp(690) := x"5" & "01" & '0'& '0' & x"84";	-- STA @132, REG1 	# Carregando 7 na COR
tmp(691) := x"6" & "00" & '1' & '0' & x"42";	-- JMP %atualiza_displays 	# Vai para o label atualiza_displays
-- final:
tmp(693) := x"4" & "11" & '0'& '0' & x"01";	-- LDI $1, REG3 	# Carrega 2 no REG3
tmp(694) := x"5" & "11" & '0'& '0' & x"84";	-- STA @132, REG3 	# Carrega 2 na COR
tmp(695) := x"9" & "00" & '1' & '0' & x"52";	-- JSR %atualiza_vga 	# Vai para o label atualiza_vga
tmp(696) := x"4" & "11" & '0'& '0' & x"01";	-- LDI $1, REG3 	# Carrega 1 no REG3
tmp(697) := x"5" & "11" & '1' & '1' & x"FF";	-- STA @1023, REG3 	# Liga o BUZZER
tmp(698) := x"1" & "11" & '0'& '0' & x"33";	-- LDA @51, REG3 	# Carrega 1 no REG3
tmp(699) := x"5" & "11" & '0'& '1' & x"02";	-- STA @258, REG3 	# Liga led 9
tmp(700) := x"5" & "11" & '0'& '1' & x"01";	-- STA @257, REG3 	# Liga o led 8
tmp(701) := x"4" & "11" & '0'& '0' & x"FF";	-- LDI $255, REG3 	# Carrega 255 no REG3
tmp(702) := x"5" & "11" & '0'& '1' & x"00";	-- STA @256, REG3 	# Liga o led 7 ao led 0
tmp(703) := x"1" & "11" & '0'& '1' & x"64";	-- LDA @356, REG3		# Carrega o REG3 com o endereço de fpga_reset
tmp(704) := x"8" & "11" & '0'& '0' & x"33";	-- CEQ @51, REG3 	# Compara o valor do REG3 com o valor 1
tmp(705) := x"7" & "00" & '1' & '0' & x"A9";	-- JEQ %RESET_FPGA 	# Se for igual, vai para o label RESET_FPGA
tmp(706) := x"1" & "11" & '0'& '1' & x"61";	-- LDA @353, REG3 	# Carrega o REG3 com o key 1
tmp(707) := x"8" & "11" & '0'& '0' & x"33";	-- CEQ @51, REG3 	# Compara o valor do REG3 com o valor 1
tmp(708) := x"7" & "00" & '0' & '0' & x"6D";	-- JEQ %define_limites_unidades 	# Se for igual, vai para o label incrementa
tmp(709) := x"6" & "00"& '0' & '1' & x"7D";	-- JMP %le_key 	# Se não for igual, volta para o label le_key

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;