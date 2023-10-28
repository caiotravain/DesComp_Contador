LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calcMemAddr IS

	port(
									--clock 50 MHz
		 --calcPosLin : IN std_logic_vector(8 DOWNTO 0);
		 posLin, posCol :  IN std_logic_vector(8 DOWNTO 0);
		 MemAddrVALUE :  OUT std_logic_vector(8 DOWNTO 0) 
	); 
end entity;

architecture arc OF calcMemAddr IS
	--signal pixel_clk, VideoRAMWREnable	: std_logic;
	--signal videoMemData : std_logic_vector(7 DOWNTO 0);
	--signal VideoMemAddress : std_logic_vector(charRAMAddrWidth-1 DOWNTO 0);
	signal calcPosLin : std_logic_vector(8 DOWNTO 0);
	--signal posLin, posCol : std_logic_vector(8 DOWNTO 0); 
	--signal calcPosCol : std_logic_vector(7 DOWNTO 0);

signal contador : integer range 0 to 299 := 0;


begin
	-- Usar para pixelCLK = 25 MHz
--	clkDiv:process(CLOCK_50)
--	begin
--		if(rising_edge(CLOCK_50))then
--			pixel_clk <= not pixel_clk;
--		end if;
--	end process;
	
	

		
		--posLIN <= std_logic_vector(to_unsigned(14, posLIN'length));
		--posCOL <= std_logic_vector(to_unsigned(19, posCOL'length));
			
		CalcPosVIDEO_A :  entity work.somadorGenerico  generic map (larguraDados => 9)
        port map( entradaA =>  posLIN(4 downto 0) & "0000", entradaB =>  posLIN(6 downto 0) & "00", saida => calcPosLin);
		  
		  CalcPosVIDEO_B :  entity work.somadorGenerico  generic map (larguraDados => 9)
        port map( entradaA => calcPosLin, entradaB =>  posCol, saida => MemAddrVALUE);
		


end architecture;
