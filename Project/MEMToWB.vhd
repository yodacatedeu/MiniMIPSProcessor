--MEM/WB
--	Input:
--	1.	memToRegister
--	2.	regWrite
--	3.	ReadData
--	4.	ALUResult
--	5.	Value from multiplexer between IF/ID Out 11 and 12
--	Output:
--	1.	memToRegister
--	2.	regWrite
--	3.	ReadData
--	4.	ALUResult
--	5.	Value from multiplexer between IF/ID Out 11 and 12
-- readData and ALUResult will be multiplexed via memToRegister determining which value will be written back to register

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY MEMToWB IS
	PORT (
		clk : IN std_logic;
		-- Inputs
				
		memToRegisterIN   : IN std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		regWriteIN  	  : IN std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readDataIN       : IN std_logic_vector (31 DOWNTO 0);-- Data read from memory
		ALUResultIN 	  : IN std_logic_vector (31 DOWNTO 0);-- Computed result from ALU
		writeRegisterIN   : IN std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to (Came from multiplexer between IwriteRegister and RwriteRegister)

		-- Outputs (same as Inputs)
		
		memToRegisterOUT   : OUT std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		regWriteOUT  	   : OUT std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readDataOUT       : OUT std_logic_vector (31 DOWNTO 0);-- Data read from memory
		ALUResultOUT 	   : OUT std_logic_vector (31 DOWNTO 0);-- Computed result from ALU
		writeRegisterOUT   : OUT std_logic_vector (4 DOWNTO 0)  -- Register where where data will be written to (Came from multiplexer between IwriteRegister and RwriteRegister)
		
	);
END MEMToWB;
ARCHITECTURE Behavioral OF MemToWB IS
BEGIN

	process(clk)
	begin
		if rising_edge(clk) then
			
			memToRegisterOUT <= memToRegisterIN;
			regWriteOUT <= regWriteIN;
			readDataOUT <= readDataIN;
			ALUResultOUT <= ALUResultIN;
			writeRegisterOUT <= writeRegisterIN;
			
		end if;
	end process;

	
	
END Behavioral;
