-- 32 Bit 2-1 Muliplexer Component: Can be used for all 2-1, 32-bit Mux components in processor
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY TwoToOneMux IS
	PORT (
		in0  : IN std_logic_vector(31 DOWNTO 0);  -- first input
		in1  : IN std_logic_vector(31 DOWNTO 0);  -- second input
		out0  : OUT STD_logic_vector(31 DOWNTO 0);-- output
		cSwitch  : IN STD_logic        		  -- switch
	);
END TwoToOneMux;
ARCHITECTURE Behavioral OF TwoToOneMux IS
BEGIN
	out0 <= in0 WHEN cSwitch = '0' ELSE -- choose first input if switch = 0, else choose second input
           	in1;
	
END Behavioral;
