-- 5 Bit 2-1 Muliplexer Component: used for determining the destination register
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY Reg_Dest_Mux IS
	PORT (
		in0  : IN std_logic_vector(4 DOWNTO 0);  -- first input
		in1  : IN std_logic_vector(4 DOWNTO 0);  -- second input
		out0  : OUT STD_logic_vector(4 DOWNTO 0);-- output
		cSwitch  : IN STD_logic        		  -- switch
	);
END Reg_Dest_Mux;
ARCHITECTURE Behavioral OF Reg_Dest_Mux IS
BEGIN
	out0 <= in0 WHEN cSwitch = '0' ELSE -- choose first input if switch = 0, else choose second input
	           in1;
END Behavioral;
