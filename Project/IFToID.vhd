--IF/ID Pipeline Register:
--	Input:
--	1.	Instruction (32 bits)
--	Output:
--	1.	Op code: first 6 bits (31-26)
--	2.	Read Register 1 (rs): next 5 bits (25-21)
--	3.	Read Register 2 (rt): next 5 bits (20-16)
--	4.	Immediate Value: last 16 bits (15-0)
--	5.	Write Register for "I" instruction: same as register 2 (20-16)
--	6.	Write Register for "R" Instruction (rd): next 5 bits after register 2 (15-11)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY IFToID IS
	PORT (
		clk : IN std_logic;
		-- Inputs

		instruction  	  : IN STD_logic_vector(31 DOWNTO 0);  -- the instruction

		-- Outputs (same as Inputs)
		OpCode		: OUT std_logic_vector(5 DOWNTO 0);	-- the opeartion
		readRegister1	: OUT std_logic_vector (4 DOWNTO 0); 	-- the first register rs
		readRegister2   : OUT std_logic_vector (4 DOWNTO 0);	-- the second register rt
		immediateValue  : OUT std_logic_vector (15 DOWNTO 0);	-- the immediate value
		IwriteRegister  : OUT std_logic_vector (4 DOWNTO 0); 	-- Register where where data will be written to if "I" instruction
		RwriteRegister  : OUT std_logic_vector (4 DOWNTO 0)  	-- Register where where data will be written to if "R" instruction
	);
END IFToID;
ARCHITECTURE Behavioral OF IFToID IS
BEGIN
	process(clk)
	begin
		if rising_edge(clk) then
			OpCode 	       <= instruction(31 DOWNTO 26);
			readRegister1  <= instruction(25 DOWNTO 21);
			readRegister2  <= instruction(20 DOWNTO 16);
			immediateValue <= instruction(15 DOWNTO 0);
			IwriteRegister <= instruction(20 DOWNTO 16);
			RwriteRegister <= instruction(15 DOWNTO 11);

		end if;
	end process;

	
	
END Behavioral;

