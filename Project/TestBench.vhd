library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
USE IEEE.NUMERIC_STD.ALL;
library work;

ENTITY MIPS_TB is
end MIPS_TB;

ARCHITECTURE tb of MIPS_TB is
	--setting each clock cycle to be 20 ns
	CONSTANT period : TIME := 20 ns;
	--inputs
	SIGNAL reset : std_logic;
	SIGNAL clk : std_logic := '0';
	--output
	SIGNAL pc_out : std_logic_vector(31 downto 0);


BEGIN
	--connecting the signals in the testbench to the inputs and output in the MIPS entity
	UUT : entity work.MIPS PORT MAP(reset=>reset, clk=>clk, pc_out=>pc_out);

	PROCESS
	BEGIN
		--resetting all the values in the processor
		clk<= '0';
		reset<= '1';
		wait for period/2;

		clk<= '0';
		reset<= '0';
		wait for period/2;

		--goes through 19 clock cycles needed for the processor to demonstrate the test instructions (Stored in instruction memory)
		for I in 1 to 19 loop
			clk<= '1';
			wait for period/2;
			clk<= '0';
			wait for period/2;
		end loop;
END PROCESS;

END tb;
