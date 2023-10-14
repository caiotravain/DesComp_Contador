library ieee;
use ieee.std_logic_1164.all;

entity logicaSW is
  port (  SW_7_0 : in std_logic_vector(7 downto 0);
			 SW_8 : in std_logic;
			 SW_9 : in std_logic;
          RD : in std_logic;
          bloco : in std_logic;
          endereco : in std_logic_vector (2 downto 0);
          sw_ou_key : in std_logic;
          saida : out std_logic_vector(7 downto 0)
  );
end entity;

architecture comportamento of logicaSW is
  signal habilitaBuffer3State8Portas : std_logic;
  signal habilitaSW8 : std_logic;
  signal habilitaSW9 : std_logic;
  
  signal entradaBuffer3State8Portas: std_logic_vector(7 downto 0);
  signal saidaBuffer3State8Portas: std_logic_vector(7 downto 0);
  signal saidaSW8: std_logic;
  signal saidaSW9: std_logic;
  
begin
entradaBuffer3State8Portas <= SW_7_0;
habilitaBuffer3State8Portas <= (RD and bloco and endereco(0) and (not sw_ou_key));
habilitaSW8 <= (RD and bloco and endereco(1) and (not sw_ou_key));
habilitaSW9 <= (RD and bloco and endereco(2) and (not sw_ou_key));

BUFFER3STATE8PORTAS : entity work.buffer_3_state_8portas
          port map (entrada => entradaBuffer3State8Portas, 
						habilita => habilitaBuffer3State8Portas, 
						saida => saidaBuffer3State8Portas);

BUFFER3STATESW8 : entity work.buffer_3_state
          port map (entrada => SW_8, 
						habilita => habilitaSW8, 
						saida => saidaSW8); 	

BUFFER3STATESW9 : entity work.buffer_3_state
          port map (entrada => SW_9, 
						habilita => habilitaSW9, 
						saida => saidaSW9); 	
						
saida <= saidaBuffer3State8Portas;
saida(0) <=  saidaSW8;
saida(0) <=  saidaSW9;
			 
end architecture;