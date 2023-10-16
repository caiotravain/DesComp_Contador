library ieee;
use ieee.std_logic_1164.all;

entity ContadorV0 is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
           larguraEnderecos : natural := 9;
				larguraDadosMuxJump : natural := 9;
				larguraInstrucao : natural := 13;
				simulacao : boolean := FALSE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
    SW : in std_logic_VECTOR(9 DOWNTO 0);
	  KEY : in std_logic_vector(3 downto 0);
    FPGA_RESET_N : in std_logic;
	  LEDR : out std_logic_vector(9 downto 0);
    HEX0 : out std_logic_vector(6 downto 0);
    HEX1 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX3 : out std_logic_vector(6 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX5 : out std_logic_vector(6 downto 0)
  );
end entity;


architecture arquitetura of ContadorV0 is
  signal CLK : std_logic;

  -- Data reader bus
  signal busDataReader : std_logic_vector(larguraDados-1 downto 0);

  -- Sinais da CPU
  signal OutROM : std_logic_vector(larguraInstrucao-1 downto 0);
  signal outRAM : std_logic_vector(larguraDados-1 downto 0);
  signal outCPUData : std_logic_vector(larguraDados-1 downto 0);
  signal outCPUAddr : std_logic_vector(larguraEnderecos-1 downto 0);
  signal InROM : std_logic_vector(larguraEnderecos-1 downto 0);
  signal RD : std_logic;
  signal WR : std_logic;

  -- RAM 
  signal RAMAddr : std_logic_vector(5 downto 0);

  signal InDecoderBlocks : std_logic_vector(2 downto 0);
  signal OutDecoderBlocks : std_logic_vector(7 downto 0);
  signal InDecoderAddr : std_logic_vector(2 downto 0);
  signal OutDecoderAddr : std_logic_vector(7 downto 0);

  -- LEDS
  signal OutLEDR : std_logic_vector(9 downto 0);

  -- A5
  signal dividerA5 : std_logic;

  -- 7 seg
  signal OutHex0 : std_logic_vector(6 downto 0);
  signal OutHex1 : std_logic_vector(6 downto 0);
  signal OutHex2 : std_logic_vector(6 downto 0);
  signal OutHex3 : std_logic_vector(6 downto 0);
  signal OutHex4 : std_logic_vector(6 downto 0);
  signal OutHex5 : std_logic_vector(6 downto 0);
  
  --Switches
  signal outSW: std_logic_vector(larguraDados-1 downto 0);

  --Botoes
  signal outKEY: std_logic_vector(larguraDados-1 downto 0);

begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY(0);
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => CLOCK_50, saida => CLK);
end generate;

-- Barramento de leitura
-- busDataReader <= outRAM;
busDataReader <= outKEY;
busDataReader <= outSW;
-- Port maps infinitos...

CPU :  entity work.CPU  generic map (larguraDados => larguraDados, larguraEnderecos => larguraEnderecos, larguraInstrucao => larguraInstrucao)
        port map( CLOCK_50 => CLK,
					 Instruction_IN => OutROM,
					 Data_IN => busDataReader,
					 Data_OUT => outCPUData,	
					 ROM_Address => InROM,
					 Data_Address => outCPUAddr,
					 RD => RD,
					 WR => WR);
					 
-- O port map completo da ROM.
ROM : entity work.memoriaROM   generic map (dataWidth => larguraInstrucao, addrWidth => larguraEnderecos)
          port map (Endereco => InROM, Dado => OutROM);

-- O port map completo do decoder de blocos.			 
DECODER_BLOCKS: entity work.decoder3x8   
          port map (entrada => InDecoderBlocks, saida => OutDecoderBlocks);
			 
-- O port map completo do decoder de enderecos.			 
DECODER_ADDRESSES: entity work.decoder3x8   
          port map (entrada => InDecoderAddr, saida => OutDecoderAddr);
			 
-- O port map completo do decodificador dos leds
LED_REGISTER : entity work.registradorLED  generic map(larguraDados => larguraDados)
			 port map (WR => WR,
						bloco => OutDecoderBlocks(4),
						endereco => OutDecoderAddr(2 downto 0),
						dados => outCPUData,
						saida => OutLEDR,
						CLK =>CLK,
            selector => dividerA5);

-- O port map completo do decoder da memória RAM.	
RAM : entity work.memoriaRAM  generic map(dataWidth => larguraDados, addrWidth => larguraEnderecos-3)
			 port map (addr => RAMAddr, we => WR, re => RD, 
							habilita => OutDecoderBlocks(0), clk => CLK, 
							dado_in => outCPUData,
							dado_out => busDataReader);

-- O port map completo do decodificador dos displays de 7 seg
 SEVEN_SEG_REGISTER : entity work.registrador7Seg generic map(larguraDados => 4)
       port map (
         CLK => CLK,
         WR => WR,
         bloco => OutDecoderBlocks(4),
         endereco => OutDecoderAddr(5 downto 0),
         dados => outCPUData(3 downto 0),
         selector => dividerA5,
         HEX0 => OutHex0,
         HEX1 => OutHex1,
         HEX2 => OutHex2,
         HEX3 => OutHex3,
         HEX4 => OutHex4,
         HEX5 => OutHex5
       );
		 
LOGICASW : entity work.logicaSW 
			 port map (SW_7_0 => SW(7 downto 0),
						  SW_8 => SW(8),
						  SW_9 => SW(9),
						  RD => RD,
						bloco => OutDecoderBlocks(5),
						endereco => OutDecoderAddr(2 downto 0),
						sw_ou_key => dividerA5,
						saida => outSW);
						
LOGICAKEY : entity work.logicaKey
			 port map (CLK => CLK,
			          KEY => KEY(3 downto 0),
                FPGA_reset => FPGA_RESET_N,
						    RD => RD,
					    	WR => WR,
						    bloco => outDecoderBlocks(5),
						    addr => OutDecoderAddr(4 downto 0),
						    reset_addr => outCPUAddr,
						    sw_ou_key => dividerA5,
						    saida => outKEY);
						


-- Sinais organizados
InDecoderBlocks <= outCPUAddr(8 downto 6);
InDecoderAddr <= outCPUAddr(2 downto 0);
RAMAddr <= outCPUAddr(5 downto 0);
dividerA5 <= outCPUAddr(5);

-- Saida
LEDR <= OutLEDR;

-- Saida 7seg
 HEX0 <= OutHex0;
 HEX1 <= OutHex1;
 HEX2 <= OutHex2;
 HEX3 <= OutHex3;
 HEX4 <= OutHex4;
 HEX5 <= OutHex5;

end architecture;