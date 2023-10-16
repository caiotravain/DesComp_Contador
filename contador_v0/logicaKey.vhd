library ieee;
use ieee.std_logic_1164.all;

entity logicaKey is
  port ( CLK : in std_logic;
        KEY : in std_logic_vector (3 downto 0);
        FPGA_reset : in std_logic;
        RD, WR : in std_logic;
			  bloco : in std_logic;
			  addr : in std_logic_vector (4 downto 0);
			  reset_addr : in std_logic_vector (8 downto 0);
			  sw_ou_key : in std_logic;
        saida : out std_logic_vector (7 downto 0)
  );
end entity;

architecture comportamento of logicaKey is
  signal saidaDiscriminador : std_logic;
  signal saidaFlipFlop : std_logic;
  signal resetFlipFlop : std_logic;

    signal saidaDiscriminador_key1 : std_logic;
  signal saidaFlipFlop_key1 : std_logic;
    signal resetFlipFlop_key1 : std_logic;

  signal habilitaKey0 : std_logic;
  signal habilitaKey1 : std_logic;
  signal habilitaKey2 : std_logic;
  signal habilitaKey3 : std_logic;
  signal habilitaKeyFPGAReset : std_logic;
  
  signal saidaKey0: std_logic;
  signal saidaKey0Restante: std_logic_vector(6 downto 0);
  signal saidaKey1: std_logic;
  signal saidaKey1Restante: std_logic_vector(6 downto 0);
  signal saidaKey2: std_logic;
  signal saidaKey3: std_logic;
  signal saidaFPGAReset: std_logic;
  
begin
habilitaKey0 <= (RD and bloco and addr(0) and sw_ou_key);
habilitaKey1 <= (RD and bloco and addr(1) and sw_ou_key);
habilitaKey2 <= (RD and bloco and addr(2) and sw_ou_key);
habilitaKey3 <= (RD and bloco and addr(3) and sw_ou_key);
habilitaKeyFPGAReset <= (RD and bloco and addr(4) and sw_ou_key);

resetFlipFlop <= (reset_addr(8) and reset_addr(7) and reset_addr(6) and reset_addr(5) and
                  reset_addr(4) and reset_addr(3) and reset_addr(2) and reset_addr(1) and
						reset_addr(0) and WR);
resetFlipFlop_key1 <= (reset_addr(8) and reset_addr(7) and reset_addr(6) and reset_addr(5) and
                  reset_addr(4) and reset_addr(3) and reset_addr(2) and reset_addr(1) and
						not(reset_addr(0)) and WR);

DETECTORBORDA : entity work.edgeDetector(bordaSubida)
          port map(clk => CLK,
			         entrada => not(KEY(0)),
						saida => saidaDiscriminador);
						
FF : entity work.flipFlop
		    port map (DIN => '1', DOUT => saidaFlipFlop, ENABLE => '1', CLK => saidaDiscriminador, RST => resetFlipFlop);


DETECTORBORDA_key1 : entity work.edgeDetector(bordaSubida)
          port map(clk => CLK,
			         entrada => not(KEY(1)),
						saida => saidaDiscriminador_key1);
						
FF_key1 : entity work.flipFlop
		    port map (DIN => '1', DOUT => saidaFlipFlop_key1, ENABLE => '1', CLK => saidaDiscriminador_key1, RST => resetFlipFlop_key1);


--
BUFFER3STATEKEY0 : entity work.buffer_3_state
          port map (entrada => saidaFlipFlop, 
						habilita => habilitaKey0, 
						saida => saidaKey0); 	
			
BUFFER3STATEKEY0RESTANTE : entity work.buffer_3_state_7portas
          port map (entrada => "0000000", 
						habilita => habilitaKey0, 
						saida => saidaKey0Restante); 	
--
			
BUFFER3STATEKEY1 : entity work.buffer_3_state
          port map (entrada => saidaFlipFlop_key1, 
						habilita => habilitaKey1, 
						saida => saidaKey1);
						
BUFFER3STATEKEY1RESTANTE : entity work.buffer_3_state_7portas
          port map (entrada => "0000000", 
						habilita => habilitaKey1, 
						saida => saidaKey1Restante); 	
--
						
BUFFER3STATEKEY2 : entity work.buffer_3_state
          port map (entrada => KEY(2), 
						habilita => habilitaKey2, 
						saida => saidaKey2);
						
BUFFER3STATEKEY3 : entity work.buffer_3_state
          port map (entrada => not(KEY(3)), 
						habilita => habilitaKey3, 
						saida => saidaKey3);
						
BUFFER3STATEFPGARESET : entity work.buffer_3_state
          port map (entrada => not(FPGA_reset), 
						habilita => habilitaKeyFPGAReset, 
						saida => saidaFPGAReset);						

saida(0) <= saidaKey0;
saida(0) <= saidaKey1;
saida(0) <= saidaKey2;
saida(0) <= saidaKey3;
saida(0) <= saidaFPGAReset;
saida(7 downto 1) <= saidaKey0Restante;
saida(7 downto 1) <= saidaKey1Restante;

			 
end architecture;