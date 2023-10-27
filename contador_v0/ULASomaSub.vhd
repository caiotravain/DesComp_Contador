library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is
    generic ( larguraDados : natural := 8 );
    port (
      entradaA, entradaB:  in STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      seletor:  in STD_LOGIC_VECTOR(1 downto 0);
      saida:    out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
		saida_flag: out STD_LOGIC;
		saida_menor : out STD_LOGIC
    );
end entity;

architecture comportamento of ULASomaSub is
   signal soma :      STD_LOGIC_VECTOR((larguraDados-1) downto 0);
   signal subtracao : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal op_end    : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal passa     : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
    begin
      soma      <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
      subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
		op_end    <= STD_LOGIC_VECTOR(unsigned(entradaA) AND unsigned(entradaB));
		passa     <= STD_LOGIC_VECTOR(unsigned(entradaB));
      saida <= soma when (seletor = "01") else 
					subtracao when (seletor = "11") else
					op_end when (seletor = "10") else
					passa;
      saida_flag <= not (subtracao(7) or subtracao(6) or subtracao(5) or subtracao(4) or subtracao(3) or subtracao(2) or subtracao(1) or subtracao(0));
		saida_menor <= '1' when entradaB > entradaA else '0';
end architecture;