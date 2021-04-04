-- The File Containing the MIPS registers
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY REGISTER_FILE IS
	PORT (
		readRegister1 : IN std_logic_vector (4 DOWNTO 0);  -- First Register to read from
		readRegister2 : IN std_logic_vector (4 DOWNTO 0);  -- Second register to read from
		readData1     : OUT std_logic_vector (31 DOWNTO 0);-- Data read from register 1
		readData2     : OUT std_logic_vector (31 DOWNTO 0);-- Data read from register 2

		registerWrite : IN std_logic;			   -- Indicator if register is to be written to a register (1 is true)
		writeRegister : IN std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to
		writeData     : IN std_logic_vector (31 DOWNTO 0)  -- Data to be written to a register
	);
END REGISTER_FILE;
ARCHITECTURE Behavioral OF REGISTER_FILE IS
	TYPE registers IS ARRAY (0 to 31) OF std_logic_vector(31 DOWNTO 0);
	-- create 32 registers of 32 bits
	SIGNAL register_array : registers := (
		x"00000000", --$zero 	(0)
		x"00000001", --$at   	(1)	
		x"00000000", --$v0	(2)
		x"00000000", --$v1	(3)
		x"00000001", --$a0	(4)
		x"00000001", --$a1	(5)
		x"00000000", --$s2	(6)
		x"00000002", --$a3	(7)
		x"00000002", --$t0	(8)
		x"00000000", --$t1	(9)
		x"00000000", --$t2	(10)
		x"00000006", --$t3	(11)
		x"00000000", --$t4	(12)
		x"00000000", --$t5	(13)
		x"00000000", --$t6	(14)
		x"00000000", --$t7	(15)
		x"00000000", --$s0	(16)
		x"00000000", --$s1	(17)
		x"00000000", --$s2	(18)
		x"00000000", --$s3	(19)
		x"00000000", --$s4	(20)
		x"00000000", --$s5	(21)
		x"00000000", --$s6	(22)
		x"00000000", --$s7	(23)
		x"00000000", --$t8	(24)
		x"00000000", --$t9	(25)
		x"00000000", --$k0	(26)
		x"00000000", --$k1	(27)
		x"00000000", --$gp	(28)
		x"00000000", --$sp	(29)
		x"00000000", --$fp	(30)
		x"00000000"  --$ra	(31)
	);
BEGIN
	-- Read data from the read registers and assign it to the outputs
	readData1 <= register_array(to_integer(unsigned(readRegister1)));
	readData2 <= register_array(to_integer(unsigned(readRegister2)));

	--PROCESS (registerWrite) -- Sensitive to a change in registerWrite
	--BEGIN
		--IF (registerWrite = '1') THEN -- Write the desired data to the desired register if registerWrite = 1
			register_array(to_integer(unsigned(writeRegister))) <= writeData when registerWrite = '1';
		--END IF;
	--END PROCESS;
END Behavioral;
