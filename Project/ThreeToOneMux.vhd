-- 32 Bit 3-1 Muliplexer Component (May not be needed)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY ThreeToOneMux IS
	PORT (
		in0  : IN std_logic_vector(31 DOWNTO 0);  -- first input
		in1  : IN std_logic_vector(31 DOWNTO 0);  -- second input
		in2  : IN std_logic_vector(31 DOWNTO 0);  -- second input
		out0 : OUT std_logic_vector(31 DOWNTO 0);-- output
		cSwitch : IN std_logic_vector(1 DOWNTO 0) -- switch
	);
END ThreeToOneMux;
ARCHITECTURE Behavioral OF ThreeToOneMux IS
BEGIN
	
with cSwitch select
    out0 <=  in0 when "00",
         in1 when "01",
         in2 when "10",
         x"00000000"  when others;
	           
END Behavioral;

