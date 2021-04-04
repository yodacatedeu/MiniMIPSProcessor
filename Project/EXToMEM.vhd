--EX/MEM Pipeline Register:
--	Input:
--	1.	memRead       
--	2.	memToRegister 
--	3.	memWrite     
--	4.	regWrite
--	5.	Read data 2 (write data for memory)
--	6.	ALU result
--	7.	Value from multiplexer between IF/ID Out 11 and 12
--	Output:
--	1.	memRead       
--	2.	memToRegister 
--	3.	memWrite     
--	4.	regWrite
--	5.	Read data 2 (write data for memory)
--	6.	ALU result
--	7.	Value from multiplexer between IF/ID Out 11 and 12

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY EXToMEM IS
	PORT (
		clk : IN std_logic;
		-- Input
		memReadIN         : IN std_logic; -- 1 for reading memory
		memToRegisterIN   : IN std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		memWriteIN        : IN std_logic; -- 1 for writing data
		regWriteIN  	  : IN std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readData2IN       : IN std_logic_vector (31 DOWNTO 0);-- Data read from register 
		ALUResultIN 	  : IN std_logic_vector (31 DOWNTO 0);-- Computed result from ALU
		writeRegisterIN   : IN std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to (Came from multiplexer between IwriteRegister and RwriteRegister)

		-- Outputs (same as Inputs)
		memReadOUT         : OUT std_logic; -- 1 for reading memory
		memToRegisterOUT   : OUT std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		memWriteOUT        : OUT std_logic; -- 1 for writing data
		regWriteOUT  	   : OUT std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readData2OUT       : OUT std_logic_vector (31 DOWNTO 0);-- Data read from register 2
		ALUResultOUT 	   : OUT std_logic_vector (31 DOWNTO 0);-- Computed result from ALU
		writeRegisterOUT   : OUT std_logic_vector (4 DOWNTO 0)  -- Register where where data will be written to (Came from multiplexer between IwriteRegister and RwriteRegister)
		
	);
END EXToMEM;
ARCHITECTURE Behavioral OF EXToMEM IS
BEGIN

	process(clk)
	begin
		if rising_edge(clk) then
			
			memReadOUT <= memReadIN;
			memToRegisterOUT <= memToRegisterIN;
			memWriteOUT <= memWriteIN;
			regWriteOUT <= regWriteIN;
			readData2OUT <= readData2IN;
			ALUResultOUT <= ALUResultIN;
			writeRegisterOUT <= writeRegisterIN;			
		end if;
	end process;

	
	
END Behavioral;
