-- Shift a word left twice (multiply by 4) *This may serve no purpose and there is a vhdl function call that can replace this
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY ShiftLeft IS
	PORT (
		input  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ShiftLeft;
ARCHITECTURE Behavioral OF ShiftLeft IS
BEGIN
	output(31)          <= input(31); 	   -- Maintain sign
	output(30 DOWNTO 2) <= input(28 DOWNTO 0); -- Do the left shift by 2
	output(1 DOWNTO 0) <= (OTHERS => '0'); 	   -- Fill the last 2 bits with zeroes
END Behavioral;
