library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
        larguraEnderecos : natural := 9;
		  larguraInstrucao : natural := 15
  );
  port   (
    CLOCK_50 : in std_logic;
    Instruction_IN: in std_logic_vector (larguraInstrucao-1 downto 0);
    Data_IN: in std_logic_vector (larguraDados-1 downto 0);    
    Data_OUT: out std_logic_vector (larguraDados-1 downto 0);	
    ROM_Address: out std_logic_vector(larguraEnderecos-1 downto 0);
    Data_Address: out std_logic_vector (larguraEnderecos-1 downto 0);
    RD: out std_logic;
    WR: out std_logic
  );
end entity;


architecture arquitetura of CPU is

  signal MUX_REG1 : std_logic_vector (larguraDados-1 downto 0);
  signal REG1_ULA_A : std_logic_vector (larguraDados-1 downto 0);
  signal Saida_ULA : std_logic_vector (larguraDados-1 downto 0);
  signal Sinais_Controle : std_logic_vector (11 downto 0);
  signal EnderecoROM : std_logic_vector (8 downto 0);
  signal proxPC : std_logic_vector (8 downto 0);
  signal Imediato : std_logic_vector (7 downto 0);
  signal CLK : std_logic;
  signal SelMUX : std_logic;
  signal SelMUXJMP : std_logic_vector (1 downto 0);
  signal Habilita_A : std_logic;
  signal DIN_Signal : std_logic_vector (8 downto 0);
  signal DOut_Signal : std_logic_vector (8 downto 0);
  signal ROMAddr : std_logic_vector (8 downto 0);
  signal Operacao_ULA : std_logic_vector (1 downto 0);
  signal saida_dec : std_logic_vector (2 downto 0);
  signal Opcode : std_logic_vector (3 downto 0);
  signal Out_ROM : std_logic_vector (14 downto 0);
  signal Out_RAM : std_logic_vector (7 downto 0);
  signal Saida_Flag_Zero : std_logic;
  signal Out_flip_flop : std_logic;
  signal Habilita_flip_flop : std_logic;
  signal Habilita_Reg_Retorno : std_logic;
  signal Habilita_Escrita_RAM : std_logic;
  signal Habilita_Leitura_RAM : std_logic;
  signal Out_Reg_Retorno : std_logic_vector (8 downto 0);
  signal Out_Mux_PC : std_logic_vector (8 downto 0);
  signal Endereco_registrador: std_logic_vector (1 downto 0);
begin

-- Instanciando os componentes:

CLK <= CLOCK_50;


-- O port map completo do MUX.
MUX1 :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => Data_IN,
                 entradaB_MUX =>  Imediato,
                 seletor_MUX => SelMUX,
                 saida_MUX => MUX_REG1);
					  
-- Mux do PC
MUX_PC :  entity work.muxGenerico4x1  generic map (larguraDados => larguraEnderecos)
        port map( entrada0_MUX => proxPC,
                 entrada1_MUX =>  Out_ROM(8 downto 0),
                 entrada2_MUX => Out_Reg_Retorno,
                 entrada3_MUX => "000000000",
                 seletor_MUX => SelMUXJMP,
                 saida_MUX => Out_Mux_PC);

-- O port map completo do Acumulador.

REGS : entity work.bancoRegistradoresArqRegMem   generic map (larguraDados => larguraDados, larguraEndBancoRegs => 2)
          port map ( clk => CLK,
              endereco => Endereco_registrador,
              dadoEscrita => Saida_ULA,
              habilitaEscrita => Habilita_A,
              saida  => REG1_ULA_A);

-- O port map completo do Program Counter.
PC : entity work.programCounter   generic map (larguraDados => larguraEnderecos)
          port map (DIN => Out_Mux_PC, DOUT => ROMAddr, ENABLE => '1', CLK => CLK, RST => '0');

incrementaPC :  entity work.somaConstante  generic map (larguraDados => larguraEnderecos, constante => 1)
        port map( entrada => ROMAddr, saida => proxPC);


-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => larguraDados)
          port map (entradaA => REG1_ULA_A, entradaB => MUX_REG1, saida => Saida_ULA, seletor => Operacao_ULA, saida_flag => Saida_Flag_Zero);

			 
-- O port map completo do decodificador
DEC_Instru : entity work.decoderInstru port map (opcode => Opcode, saida => Sinais_Controle);

-- Port map do Flip Flop
FlagZero : entity work.FlipFlop port map (DIN => Saida_Flag_Zero, DOUT => Out_flip_flop, ENABLE => Habilita_flip_flop, CLK => CLK, RST => '0');
			 		 

-- Port map do Logica Desvio
LogicaDesvio1 : entity work.logicaDesvio port map (Flag => Out_flip_flop,
																	 JEQ => Sinais_Controle(7),
                                                    JMP => Sinais_Controle(10),
                                                    JSR => Sinais_Controle(8),
                                                    RET => Sinais_Controle(9),
                                                    saida => SelMuxJMP);

-- Registrador do retorno
REG_RETORNO : entity work.registradorGenerico   generic map (larguraDados => 9)
          port map (DIN => proxPC, DOUT => Out_Reg_Retorno, ENABLE => Habilita_Reg_Retorno, CLK => CLK, RST => '0');


-- Sinais organizados NOVO
Opcode <= Instruction_IN(14 downto 11);
Out_ROM <= Instruction_IN;
Imediato <= Instruction_IN(7 downto 0);
Habilita_Escrita_RAM <= Sinais_Controle(0);
Habilita_Leitura_RAM <= Sinais_Controle(1);

selMUX <= Sinais_Controle(6);
Habilita_A <= Sinais_Controle(5);

Habilita_flip_flop <= Sinais_Controle(2);
Operacao_ULA <= Sinais_Controle(4 downto 3);

Habilita_Reg_Retorno <= Sinais_Controle(11);

-- PC_OUT <= DOut_Signal;


ROM_Address <= ROMAddr;

-- I/O
RD <= Habilita_Leitura_RAM;
WR <= Habilita_Escrita_RAM;
Data_OUT <= REG1_ULA_A;
Data_Address <= Instruction_IN(8 downto 0);
Endereco_registrador<=Instruction_IN(10 downto 9);

end architecture;