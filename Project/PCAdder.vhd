-- Increments the program counter by 4 (May be uneccessary (since no support for branching/jumping) and/or may change it to increment by only 1 since it's technically reading from an array of 32 bits in the memory component)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY PC_ADDER IS
	PORT (
		PC_In   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_Out  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END PC_ADDER;
ARCHITECTURE Behavioral OF PC_ADDER IS
BEGIN
	
	PC_Out <= PC_In + x"0001"; -- 1 or 4?

END Behavioral;
