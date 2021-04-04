--ID/EX Pipeline Register:
--	Input:
--	1.	ALUop	      
--	2.	regDst        
--	3.	memRead       
--	4.	memToRegister 
--	5.	memWrite     
--	6.	ALUsrc        
--	7.	regWrite      
--	8.	Read data 1
--	9.	Read data 2
--	10.	Sign extend
--	11.	Write Register for ?I? instruction
--	12.	Write Register for ?R? Instruction (rd)

--	Output:
--	1.	ALUop	      
--	2.	regDst        
--	3.	memRead       
--	4.	memToRegister 
--	5.	memWrite     
--	6.	ALUsrc        
--	7.	regWrite      
--	8.	Read data 1
--	9.	Read data 2
--	10.	Sign extend
--	11.	Write Register for ?I? instruction
--	12.	Write Register for ?R? Instruction (rd) 
--	o	11 and 12 will be sent to a multiplexer to determine whcih will be the write register

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY IDToEX IS
	PORT (
		clk : IN std_logic;
		-- Inputs
				
		ALUopIN	      	  : IN std_logic_vector(5 DOWNTO 0); -- same as opcode
		regDstIN          : IN std_logic; -- 0 for immediate and LW/SW, 1 for register arith
		memReadIN         : IN std_logic; -- 1 for reading memory
		memToRegisterIN   : IN std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		memWriteIN        : IN std_logic; -- 1 for writing data
		ALUsrcIN          : IN std_logic; -- 0 for second operand to be a register else 1 for second operand is immediate value (direct value offest for a mem address)
		regWriteIN  	  : IN std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readData1IN       : IN std_logic_vector (31 DOWNTO 0);-- Data read from register 1
		readData2IN       : IN std_logic_vector (31 DOWNTO 0);-- Data read from register 2
		signExtendIN  	  : IN STD_logic_vector(31 DOWNTO 0);  -- the extended number
		IwriteRegisterIN  : IN std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to if "I" instruction
		RwriteRegisterIN  : IN std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to if "R" instruction

		-- Outputs (same as Inputs)
		ALUopOUT	   : OUT std_logic_vector(5 DOWNTO 0); -- same as opcode
		regDstOUT          : OUT std_logic; -- 0 for immediate and LW/SW, 1 for register arith
		memReadOUT         : OUT std_logic; -- 1 for reading memory
		memToRegisterOUT   : OUT std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		memWriteOUT        : OUT std_logic; -- 1 for writing data
		ALUsrcOUT          : OUT std_logic; -- 0 for second operand to be a register else 1 for second operand is immediate value (direct value offest for a mem address)
		regWriteOUT  	   : OUT std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readData1OUT       : OUT std_logic_vector (31 DOWNTO 0);-- Data read from register 1
		readData2OUT       : OUT std_logic_vector (31 DOWNTO 0);-- Data read from register 2
		signExtendOUT  	   : OUT STD_logic_vector(31 DOWNTO 0);  -- the extended number
		IwriteRegisterOUT  : OUT std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to if "I" instruction
		RwriteRegisterOUT  : OUT std_logic_vector (4 DOWNTO 0)  -- Register where where data will be written to if "R" instruction
		
	);
END IDToEx;
ARCHITECTURE Behavioral OF IDToEX IS
BEGIN

	process(clk)
	begin
		if rising_edge(clk) then
			ALUopOUT <= ALUopIN;
			regDstOUT <= regDstIN;
			memReadOUT <= memReadIN;
			memToRegisterOUT <= memToRegisterIN;
			memWriteOUT <= memWriteIN;
			ALUsrcOUT <= ALUsrcIN;
			regWriteOUT <= regWriteIN;
			readData1OUT <= readData1IN;
			readData2OUT <= readData2IN;
			signExtendOUT <= signExtendIN;
			IwriteRegisterOUT <= IwriteRegisterIN;
			RwriteRegisterOUT <= RwriteRegisterIN;
		end if;
	end process;

	
	
END Behavioral;

