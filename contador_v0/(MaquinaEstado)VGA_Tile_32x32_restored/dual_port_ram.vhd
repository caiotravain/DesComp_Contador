-- Quartus Prime VHDL Template
-- Simple Dual-Port RAM with different read/write addresses but
-- single read/write clock

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_port_ram is
	generic ( DATA_WIDTH : natural := 8;
		       ADDR_WIDTH : natural := 6	);
	port (
		wr_clk      : in std_logic;
--		rd_clk      : in std_logic;
		rd_addr     : in std_logic_vector(ADDR_WIDTH-1 downto 0); --natural range 0 to 2**ADDR_WIDTH - 1;
		wr_addr     : in std_logic_vector(ADDR_WIDTH-1 downto 0); --natural range 0 to 2**ADDR_WIDTH - 1;
		data_wr_in	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		wr_enabe	   : in std_logic;
		data_rd_out : out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end dual_port_ram;

architecture rtl of dual_port_ram is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

function initMemory
        return memory_t is variable tmp : memory_t := (others => x"20");  --(others => '0'));
  begin
        -- Inicializa os endereços:
--        tmp(0) := x"07";
--        tmp(1) := x"06";
--        tmp(2) := x"05";
--        tmp(3) := x"04";
--        tmp(4) := x"03";
--        tmp(5) := x"02";
--        tmp(6) := x"01";
--        tmp(7) := x"00";
        return tmp;
    end initMemory;	
	
	-- Declare the RAM signal.	
	signal ram : memory_t := initMemory;

begin

	process(wr_clk)
	begin
	if(rising_edge(wr_clk)) then 
		if(wr_enabe = '1') then
			ram(to_integer(unsigned(wr_addr))) <= data_wr_in;
		end if;
	end if;
	end process;
	data_rd_out <= ram(to_integer(unsigned(rd_addr)));
end rtl;