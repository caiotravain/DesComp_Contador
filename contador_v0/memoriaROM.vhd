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
-- define_limites:
tmp(24) := x"4" & '0' & x"09";	-- LDI $9
tmp(25) := x"5" & '0' & x"0A";	-- STA @10 	# Limite das unidades
tmp(26) := x"5" & '0' & x"0B";	-- STA @11 	# Limite das dezenas
tmp(27) := x"5" & '0' & x"0C";	-- STA @12 	# Limite das centenas
tmp(28) := x"5" & '0' & x"0D";	-- STA @13 	# Limite dos milhares
tmp(29) := x"5" & '0' & x"0E";	-- STA @14 	# Limite das dezenas de milhares
tmp(30) := x"5" & '0' & x"0F";	-- STA @15 	# Limite das centenas de milhares
-- le_key:
tmp(32) := x"1" & '1' & x"60";	-- LDA @352 	# Carrega o acumulador com o key 0
tmp(33) := x"8" & '0' & x"33";	-- CEQ @51 	# Compara o valor do acumulador com o valor 1
tmp(34) := x"7" & '0' & x"26";	-- JEQ %incrementa_unidade 	# Se for igual, vai para o label incrementa
tmp(35) := x"0" & '0' & x"00";	-- NOP
tmp(36) := x"6" & '0' & x"20";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- incrementa_unidade:
tmp(38) := x"0" & '0' & x"00";	-- NOP
tmp(39) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando key 0
tmp(40) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(41) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador com o valor 9
tmp(42) := x"7" & '0' & x"2F";	-- JEQ %incrementa_dezena 	# Se for igual, vai para o label incrementa_dezena
tmp(43) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(44) := x"5" & '0' & x"00";	-- STA @0 	# Armazena o valor do acumulador no endereço de unidade
tmp(45) := x"6" & '0' & x"66";	-- JMP %atualiza_displays 	# Se não for igual, vai para o label atualiza_unidade
-- incrementa_dezena:
tmp(47) := x"0" & '0' & x"00";	-- NOP
tmp(48) := x"4" & '0' & x"00";	-- LDI $0
tmp(49) := x"5" & '0' & x"00";	-- STA @0 	# Limpando endereço de unidade
tmp(50) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(51) := x"1" & '0' & x"01";	-- LDA @1 	# Carregar o acumulador com o endereço da dezena
tmp(52) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(53) := x"7" & '0' & x"3A";	-- JEQ %incrementa_centena 	# Se for igual a 9, vai para o incrementa_centena
tmp(54) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(55) := x"5" & '0' & x"01";	-- STA @1 	# Armazena o valor do acumulador no endereço das dezenas
tmp(56) := x"6" & '0' & x"66";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena:
tmp(58) := x"0" & '0' & x"00";	-- NOP
tmp(59) := x"4" & '0' & x"00";	-- LDI $0
tmp(60) := x"5" & '0' & x"01";	-- STA @1 	# Limpando endereço de dezena
tmp(61) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(62) := x"1" & '0' & x"02";	-- LDA @2 	# Carregar o acumulador com o endereço da centena
tmp(63) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (centena) com o valor 9
tmp(64) := x"7" & '0' & x"45";	-- JEQ %incrementa_milhar 	# Se for igual a 9, vai para o incrementa_milhar
tmp(65) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(66) := x"5" & '0' & x"02";	-- STA @2 	# Armazena o valor do acumulador no endereço das centenas
tmp(67) := x"6" & '0' & x"66";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_milhar:
tmp(69) := x"0" & '0' & x"00";	-- NOP
tmp(70) := x"4" & '0' & x"00";	-- LDI $0
tmp(71) := x"5" & '0' & x"02";	-- STA @2 	# Limpando endereço de centena
tmp(72) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(73) := x"1" & '0' & x"03";	-- LDA @3 	# Carregar o acumulador com o endereço da milhares
tmp(74) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(75) := x"7" & '0' & x"50";	-- JEQ %incrementa_dezena_de_milhar 	# Se for igual a 9, vai para o incrementa_dezena_de_milhar
tmp(76) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(77) := x"5" & '0' & x"03";	-- STA @3 	# Armazena o valor do acumulador no endereço das milhares
tmp(78) := x"6" & '0' & x"66";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_unidade
-- incrementa_dezena_de_milhar:
tmp(80) := x"0" & '0' & x"00";	-- NOP
tmp(81) := x"4" & '0' & x"00";	-- LDI $0
tmp(82) := x"5" & '0' & x"03";	-- STA @3 	# Limpando endereço de milhar (RAM 3)
tmp(83) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(84) := x"1" & '0' & x"04";	-- LDA @4 	# Carregar o acumulador com o endereço da dezena de milhar
tmp(85) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (dezena) com o valor 9
tmp(86) := x"7" & '0' & x"5B";	-- JEQ %incrementa_centena_milhar 	# Se for igual a 9, vai para o incrementa_centena_milhar
tmp(87) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(88) := x"5" & '0' & x"04";	-- STA @4 	# Armazena o valor do acumulador no endereço das milhares
tmp(89) := x"6" & '0' & x"66";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- incrementa_centena_milhar:
tmp(91) := x"0" & '0' & x"00";	-- NOP
tmp(92) := x"4" & '0' & x"00";	-- LDI $0
tmp(93) := x"5" & '0' & x"04";	-- STA @4 	# Limpando endereço de dezena de milhar
tmp(94) := x"5" & '1' & x"FF";	-- STA @511 	# Limpando Key 0
tmp(95) := x"1" & '0' & x"05";	-- LDA @5 	# Carregar o acumulador com o endereço da centena
tmp(96) := x"8" & '0' & x"3B";	-- CEQ @59 	# Compara o valor do acumulador (centena) com o valor 9
tmp(97) := x"7" & '0' & x"66";	-- JEQ %atualiza_displays 	# Se for igual a 9, vai para o atualiza_displays
tmp(98) := x"2" & '0' & x"33";	-- SOMA @51 	# Soma 1 no acumulador
tmp(99) := x"5" & '0' & x"05";	-- STA @5 	# Armazena o valor do acumulador no endereço das centenas
tmp(100) := x"6" & '0' & x"66";	-- JMP %atualiza_displays 	# Se não for igual, volta para o label atualiza_displays
-- atualiza_displays:
tmp(102) := x"0" & '0' & x"00";	-- NOP
tmp(103) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(104) := x"5" & '1' & x"20";	-- STA @288 	# Armazena o valor do acumulador no endereço do HEX0
tmp(105) := x"1" & '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(106) := x"5" & '1' & x"21";	-- STA @289 	# Armazena o valor do acumulador no endereço do HEX1
tmp(107) := x"1" & '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(108) := x"5" & '1' & x"22";	-- STA @290 	# Armazena o valor do acumulador no endereço do HEX2
tmp(109) := x"1" & '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(110) := x"5" & '1' & x"23";	-- STA @291 	# Armazena o valor do acumulador no endereço do HEX3
tmp(111) := x"1" & '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(112) := x"5" & '1' & x"24";	-- STA @292 	# Armazena o valor do acumulador no endereço do HEX4
tmp(113) := x"1" & '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(114) := x"5" & '1' & x"25";	-- STA @293 	# Armazena o valor do acumulador no endereço do HEX5
tmp(115) := x"0" & '0' & x"00";	-- NOP
-- verifica_centena_de_milhar:
tmp(117) := x"1" & '0' & x"05";	-- LDA @5 	# Carrega o acumulador com o endereço de centena de milhar
tmp(118) := x"8" & '0' & x"0F";	-- CEQ @15 	# Compara o valor do acumulador com o valor maximo de centena de milhar
tmp(119) := x"7" & '0' & x"7A";	-- JEQ %verifica_dezena_de_milhar 	# Se for igual, vai para o label verifica_dezena_de_milhar
tmp(120) := x"6" & '0' & x"20";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- verifica_dezena_de_milhar:
tmp(122) := x"1" & '0' & x"04";	-- LDA @4 	# Carrega o acumulador com o endereço de dezena de milhar
tmp(123) := x"8" & '0' & x"0E";	-- CEQ @14 	# Compara o valor do acumulador com o valor maximo de dezena de milhar
tmp(124) := x"7" & '0' & x"7F";	-- JEQ %verifica_milhar 	# Se for igual, vai para o label verifica_milhar
tmp(125) := x"6" & '0' & x"20";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- verifica_milhar:
tmp(127) := x"1" & '0' & x"03";	-- LDA @3 	# Carrega o acumulador com o endereço de milhar
tmp(128) := x"8" & '0' & x"0D";	-- CEQ @13 	# Compara o valor do acumulador com o valor maximo de milhar
tmp(129) := x"7" & '0' & x"84";	-- JEQ %verifica_centena 	# Se for igual, vai para o label verifica_centena
tmp(130) := x"6" & '0' & x"20";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- verifica_centena:
tmp(132) := x"1" & '0' & x"02";	-- LDA @2 	# Carrega o acumulador com o endereço de centena
tmp(133) := x"8" & '0' & x"0C";	-- CEQ @12 	# Compara o valor do acumulador com o valor maximo de centena
tmp(134) := x"7" & '0' & x"89";	-- JEQ %verifica_dezena 	# Se for igual, vai para o label verifica_dezena
tmp(135) := x"6" & '0' & x"20";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- verifica_dezena:
tmp(137) := x"1" & '0' & x"01";	-- LDA @1 	# Carrega o acumulador com o endereço de dezena
tmp(138) := x"8" & '0' & x"0B";	-- CEQ @11 	# Compara o valor do acumulador com o valor maximo de dezena
tmp(139) := x"7" & '0' & x"8E";	-- JEQ %verifica_unidade 	# Se for igual, vai para o label verifica_unidade
tmp(140) := x"6" & '0' & x"20";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- verifica_unidade:
tmp(142) := x"1" & '0' & x"00";	-- LDA @0 	# Carrega o acumulador com o endereço de unidade
tmp(143) := x"8" & '0' & x"0A";	-- CEQ @10 	# Compara o valor do acumulador com o valor maximo de unidade
tmp(144) := x"7" & '0' & x"93";	-- JEQ %final 	# Se for igual, vai para o label final
tmp(145) := x"6" & '0' & x"20";	-- JMP %le_key 	# Se não for igual, volta para o label le_key
-- final:
tmp(147) := x"0" & '0' & x"00";	-- NOP
tmp(148) := x"1" & '0' & x"33";	-- LDA @51 	# Carrega 1 no acumulador
tmp(149) := x"5" & '1' & x"02";	-- STA @258 	# Liga led 9
tmp(150) := x"5" & '1' & x"01";	-- STA @257 	# Liga o led 8
tmp(151) := x"4" & '0' & x"FF";	-- LDI $255
tmp(152) := x"5" & '1' & x"00";	-- STA @256
tmp(153) := x"6" & '0' & x"93";	-- JMP %final



        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;