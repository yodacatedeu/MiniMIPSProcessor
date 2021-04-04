-- A Sign Extender with respect to most the significant bit
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY SIGN_EXTENDER IS
	PORT (  --clk	: IN std_logic;
		numIn   : IN STD_logic_vector(15 DOWNTO 0); -- num to be extended
		numOut  : OUT STD_logic_vector(31 DOWNTO 0) -- the extended number
	);
END SIGN_EXTENDER;
ARCHITECTURE Behavioral OF SIGN_EXTENDER IS
BEGIN
--process(clk)
--begin
--	if rising_edge(clk) then
	-- concat  0x0000 with numIn if msb is 0 else add 0xffff
	numOut <= x"0000" & numIn WHEN numIn(15) = '0'
	          ELSE
	          x"FFFF" & numIn;
--	end if;
--end process;
END Behavioral;
