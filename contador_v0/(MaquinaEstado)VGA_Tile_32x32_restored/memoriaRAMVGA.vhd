library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaRAMVGA is
   generic (
         dataWidth: natural := 8;
         addrWidth: natural := 8
    );
    port
    (
        addr     : in std_logic_vector(addrWidth-1 downto 0);
        we       : in std_logic;
        clk      : in std_logic;
        dado_in  : in std_logic_vector(dataWidth-1 downto 0);
        dado_out : out std_logic_vector(dataWidth-1 downto 0)
    );
end entity;

architecture rtl of memoriaRAMVGA is


	signal paletaRGBB : std_logic_vector(11 downto 0);
	
	
    -- Build a 2-D array type for the RAM
    subtype word_t is std_logic_vector(dataWidth-1 downto 0);
    type memory_t is array((2**addrWidth-1) downto 0) of word_t;

  function initMemory
        return memory_t is variable tmp : memory_t := (others => x"000");
  begin
        -- Inicializa os endereços:
			tmp(0) := x"F00"; --VERMELHO
			tmp(1) := x"0F0"; --VERDE
			tmp(2) := x"00F"; --AZUL
			tmp(3) := x"FFF"; --BRANCO
--			tmp(4) := x"F00"; --Vermelho
--			tmp(5) := x"282"; --VERDE ESCURO
--			tmp(6) := x"448"; --ROXO
--			tmp(7) := x"CCC"; --Cinza
--			tmp(8) := x"F0F"; --Rosa
--			tmp(9) := x"0FF"; --Ciano
--			tmp(10) := x"00F"; --Azul
--			tmp(11) := x"0F0"; --Verde
--			tmp(12) := x"F00"; --Vermelho
--			tmp(13) := x"282"; --VERDE ESCURO
--			tmp(14) := x"448"; --ROXO
--			tmp(15) := x"CCC"; --Cinza
--			tmp(16) := x"F0F"; --Rosa
--			tmp(17) := x"0FF"; --Ciano
--			tmp(18) := x"00F"; --Azul
--			tmp(19) := x"0F0"; --Verde
--			tmp(20) := x"F00"; --Vermelho
--			tmp(21) := x"282"; --VERDE ESCURO
--			tmp(22) := x"448"; --ROXO
--			tmp(23) := x"CCC"; --Cinza
--			tmp(24) := x"F0F"; --Rosa
--			tmp(25) := x"0FF"; --Ciano
--			tmp(26) := x"00F"; --Azul
--			tmp(27) := x"0F0"; --Verde
--			tmp(28) := x"F00"; --Vermelho
--			tmp(29) := x"282"; --VERDE ESCURO
--			tmp(30) := x"448"; --ROXO
--			tmp(31) := x"CCC"; --Cinza
        return tmp;
    end initMemory;
	 
    -- Declare the RAM signal.
    signal ram : memory_t := initMemory;
	 
--		signal ram : memory_t;
--		attribute ram_init_file : string;
--		attribute ram_init_file of ram:
--		signal is "charRAM.mif";
	 
	 
begin

--	paletaRGBB <= x"F00" when dado_in(1 downto 0) = "00" else
	--				  x"0F0" when dado_in(1 downto 0) = "01" else
	--				  x"00F" when dado_in(1 downto 0) = "10" else
--				     x"FFF" when dado_in(1 downto 0) = "11" else
	--				  x"000";

    process(clk)
    begin
        if(rising_edge(clk)) then
            if(we = '1') then
                ram(to_integer(unsigned(addr))) <= dado_in;
            end if;
        end if;
    end process;

    -- A leitura é sempre assincrona e quando houver habilitacao:
    dado_out <= ram(to_integer(unsigned(addr)));
end architecture;