library ieee;
use ieee.std_logic_1164.all;

entity ContadorV0 is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
           larguraEnderecos : natural := 9;
			  larguraEnderecos_ROM:  natural := 10;
				larguraDadosMuxJump : natural := 9;
				larguraInstrucao : natural := 16;
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
    HEX5 : out std_logic_vector(6 downto 0);
	 Buzzer: out std_logic;
	 		----
		VGA_HS		:	out	std_logic;								--horiztonal sync pulse
		VGA_VS		:	out	std_logic;								--vertical sync pulse
		VGA_R			:	out	std_logic_vector(3 DOWNTO 0);
		VGA_G			:	out	std_logic_vector(3 DOWNTO 0);
		VGA_B			:	out	std_logic_vector(3 DOWNTO 0)
		
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
  signal outCPUAddr : std_logic_vector(larguraEnderecos_rom-1 downto 0);
  signal InROM : std_logic_vector(larguraEnderecoS_rom-1 downto 0);
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
  
  signal  segs: std_logic_vector(larguraDados-1 downto 0);
  signal saida_buzzer  : std_logic;
  
  -- vga 
  	signal SIG_HAB_LIN_VGA, SIG_HAB_COL_VGA, SIG_HAB_DATA_VGA, SIG_HAB_WRITE_VGA, SIG_HAB_WRITE_VGA_OUT : std_logic;
	signal SIG_LIN_VGA, 		SIG_COL_VGA , SIG_DATA_VGA : std_logic_vector(7 downto 0);
	signal color_vga : std_logic_vector(2 downto 0);

begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY(1);
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => CLOCK_50, saida => CLK);
end generate;

-- Barramento de leitura
-- busDataReader <= outRAM;
busDataReader <= outKEY;
busDataReader <= outSW;
busDataReader <= segs;
-- Port maps infinitos...

CPU :  entity work.CPU  generic map (larguraDados => larguraDados, larguraEnderecos => larguraEnderecos, larguraInstrucao => larguraInstrucao,larguraEnderecos_Rom=> larguraEnderecos_Rom)
        port map( CLOCK_50 => CLK,
					 Instruction_IN => OutROM,
					 Data_IN => busDataReader,
					 Data_OUT => outCPUData,	
					 ROM_Address => InROM,
					 Data_Address => outCPUAddr,
					 RD => RD,
					 WR => WR);
					 
-- O port map completo da ROM.
ROM : entity work.memoriaROM   generic map (dataWidth => larguraInstrucao, addrWidth => larguraEnderecos_Rom)
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
			liga => outCPUAddr,
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
						


						
						
interfaceBaseTempo : entity work.divisorGenerico_e_Interface
              port map (clk => CLK,
              habilitaLeitura => (RD and outDecoderBlocks(5) and OutDecoderAddr(5) and dividerA5),
              limpaLeitura => (not(outCPUAddr(9)) and outCPUAddr(8) and outCPUAddr(7) and outCPUAddr(6) and outCPUAddr(5) and
                  outCPUAddr(4) and outCPUAddr(3) and outCPUAddr(2) and not(outCPUAddr(1)) and
						not(outCPUAddr(0)) and WR),
              leituraUmSegundo => segs,
				  seletor => not(key(3)));						
						
						
-- Sinais organizados
InDecoderBlocks <= outCPUAddr(8 downto 6);
InDecoderAddr <= outCPUAddr(2 downto 0);
RAMAddr <= outCPUAddr(5 downto 0);
dividerA5 <= outCPUAddr(5);

-- Saida
LEDR <= OutLEDR;


flipflop_buzzer : entity work.FlipFlop port map (DIN => outCPUData(0), DOUT => saida_buzzer, ENABLE => ((outCPUAddr(9)) and outCPUAddr(8) and outCPUAddr(7) and outCPUAddr(6) and outCPUAddr(5) and
                  outCPUAddr(4) and outCPUAddr(3) and outCPUAddr(2) and (outCPUAddr(1)) and
						(outCPUAddr(0)) and WR), CLK => CLK, RST => '0');



--Endereço 128
SIG_HAB_LIN_VGA <= WR AND
							(NOT outCPUAddr(8)) AND
							outCPUAddr(7) AND
						 (NOT outCPUAddr(6)) AND
						 (NOT outCPUAddr(5)) AND
						 (NOT outCPUAddr(4)) AND
						 (NOT outCPUAddr(3)) AND
						 (NOT outCPUAddr(2)) AND
						 (NOT outCPUAddr(1)) AND
						 (NOT outCPUAddr(0));						
						
						
REG_LIN_VGA : entity work.registradorGenerico generic map (larguraDados => 8)
			port map(
				DIN => outCPUData,
				DOUT => SIG_LIN_VGA,
				ENABLE => SIG_HAB_LIN_VGA,
				CLK => CLK,
				RST => '0'
			);	

--Endereço 129
SIG_HAB_COL_VGA <= WR AND
							(NOT outCPUAddr(8)) AND
							outCPUAddr(7) AND
						 (NOT outCPUAddr(6)) AND
						 (NOT outCPUAddr(5)) AND
						 (NOT outCPUAddr(4)) AND
						 (NOT outCPUAddr(3)) AND
						 (NOT outCPUAddr(2)) AND
						 (NOT outCPUAddr(1)) AND
						 (outCPUAddr(0));						
						
REG_COL_VGA : entity work.registradorGenerico generic map (larguraDados => 8)
			port map(
				DIN => outCPUData,
				DOUT => SIG_COL_VGA,
				ENABLE => SIG_HAB_COL_VGA,
				CLK => CLK,
				RST => '0'
			);
						
						
--Endereço 130
SIG_HAB_DATA_VGA <= WR AND
							(NOT outCPUAddr(8)) AND
							outCPUAddr(7) AND
						 (NOT outCPUAddr(6)) AND
						 (NOT outCPUAddr(5)) AND
						 (NOT outCPUAddr(4)) AND
						 (NOT outCPUAddr(3)) AND
						 (NOT outCPUAddr(2)) AND
						 (outCPUAddr(1)) AND
						 (NOT outCPUAddr(0));
						 
REG_DATA_VGA : entity work.registradorGenerico generic map (larguraDados => 8)
			port map(
				DIN => color_vga & outCPUData(4 downto 0),
				DOUT => SIG_DATA_VGA,
				ENABLE => SIG_HAB_DATA_VGA,
				CLK => CLK,
				RST => '0'
			);
			
REG_COR_VGA : entity work.registradorGenerico generic map (larguraDados => 3)
			port map(
				DIN => outCPUData(2 downto 0),
				DOUT => color_vga,
				ENABLE =>  WR AND
							(NOT outCPUAddr(8)) AND
							outCPUAddr(7) AND
						 (NOT outCPUAddr(6)) AND
						 (NOT outCPUAddr(5)) AND
						 (NOT outCPUAddr(4)) AND
						 (NOT outCPUAddr(3)) AND
						 ( outCPUAddr(2)) AND
						 (NOT outCPUAddr(1)) AND
						 (NOT outCPUAddr(0)),
				CLK => CLK,
				RST => '0'
			);		
			
SIG_HAB_WRITE_VGA_OUT <= WR AND
							(NOT outCPUAddr(8)) AND
							outCPUAddr(7) AND
						 (NOT outCPUAddr(6)) AND
						 (NOT outCPUAddr(5)) AND
						 (NOT outCPUAddr(4)) AND
						 (NOT outCPUAddr(3)) AND
						 (NOT outCPUAddr(2)) AND
						 (outCPUAddr(1)) AND
						 (outCPUAddr(0));
			
	driverVGA: entity work.driverVGA  
	port map (CLOCK_50    => CLOCK_50,								--clock 50 MHz
		--FPGA_RESET_N:	IN		std_logic;								--active low asycnchronous reset
		VGA_HS		=> 	 VGA_HS,							--horiztonal sync pulse
		VGA_VS		=> 	 VGA_VS,										--vertical sync pulse
		VGA_R			=> 	 VGA_R,		
		VGA_G			=> 	 VGA_G,		
		VGA_B			=> 	 VGA_B,		
		posLin => 	SIG_LIN_VGA,	
		posCol =>  SIG_COL_VGA,
		dadoIN => SIG_DATA_VGA, 
		VideoRAMWREnable => SIG_HAB_WRITE_VGA_OUT
		);				
						
						
Buzzer<= saida_buzzer;
-- Saida 7seg
 HEX0 <= OutHex0;
 HEX1 <= OutHex1;
 HEX2 <= OutHex2;
 HEX3 <= OutHex3;
 HEX4 <= OutHex4;
 HEX5 <= OutHex5;

end architecture;