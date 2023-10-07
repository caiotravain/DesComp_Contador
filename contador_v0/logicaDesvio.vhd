library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logicaDesvio is
		port (
			Flag:	in std_logic;
			JEQ : in std_logic;
			JMP : in std_logic;
			JSR : in std_logic;
			RET : in std_logic;
			saida: out std_logic_vector (1 downto 0)
		);
end entity;

architecture comportamento of logicaDesvio is
		begin
			saida(1) <= RET;
			saida(0) <= JMP or (JEQ and Flag) or JSR;
		
end architecture;