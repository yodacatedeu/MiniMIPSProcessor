-- The data memory for the processor
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
ENTITY Data_Memory IS
	PORT (
		ADDRESS   : IN STD_LOGIC_VECTOR (31 DOWNTO 0); 	-- Address to access
		READ_DATA  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);-- Data to read
		WRITE_DATA : IN STD_LOGIC_VECTOR (31 DOWNTO 0);	-- Data to Write
		MEM_READ   : IN STD_LOGIC;			-- Read indicator (1 for read, 0 else)
		MEM_WRITE  : IN STD_LOGIC			-- Write indicator (1 for write, 0 else)
	);
END Data_Memory;
ARCHITECTURE Behavioral OF Data_Memory IS
	TYPE RAM_32_x_32 IS ARRAY(0 TO 31) OF std_logic_vector(31 DOWNTO 0); -- Memory will be 32 words long (1 word = 32 bits)
	SIGNAL DataMem : RAM_32_x_32 := ( -- Initializing memory to empty (utilizing Hex for convenience)
		x"00000000", 
		x"00000005",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000", 
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000"
	);
BEGIN
	PROCESS (MEM_WRITE, MEM_READ) -- sensitive to either a switch on read or write

	BEGIN
		IF (MEM_READ = '1') THEN -- Read Case
			READ_DATA <= DataMem(to_integer(unsigned(ADDRESS))); -- Assign the read data to the data at the given address
		ELSIF (MEM_WRITE = '1') THEN -- Write Case
			DataMem(to_integer(unsigned(ADDRESS))) <= WRITE_DATA; -- Write the given data to the given address
		END IF;
	END PROCESS;
END Behavioral;
