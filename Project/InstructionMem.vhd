-- The instruction memory for the processor

-- Test instructions
--1. addi $2, $1, 2 ($1 = 1)* ans = 3
--000001 00001 00010 0000000000000010
--04220002
--
--2. and $3, $4 $5 ($4 =1, $5 = 1) * ans = 1
--000111 00100 00101 00011 00000000000
--1C851800
--
--3. sll $6, $7, $8 ($7 = 2, $8 = 2) * ans = 8
--001011 00111 01000 00110 00000000000
--2CE83000
--
--4. lw $9, 0($1) ($1 = 1, and data will be 5) * ans = 1 with data as 5 being loaded
--001101 00001 01001 0000000000000000
--34290000
--
--5. sw $11, 1($1) ($11 will hold 6) * ans = 2 with data being 6 written
--001110 00001 01011 0000000000000001
--382B0001
--
--6. andi $4, $1, 0 ($1 still holds 1) * ans = 0
--000010 00001 00100 0000000000000000
--08240000
--
--7. ori $5, $1, 0 ($1 still holds 1) * ans = 1
--000011 00001 00101 0000000000000000
--0C250000
--
--8. slti $2, $2, 4 ($2 should hold 3 from inst 1) * ans = 1
--000100 00010 00010 0000000000000100
--10420004
--
--9. sub $3, $6, $7 ($6 should hold 8 from inst 3, $7 still holds 2) * ans = 6
--000110 00110 00111 00011 00000000000
--18C71800
--
--10. and $11, $0, $1 ($0 is zero, and $1 is 1) * ans = 0
--000111 00000 00001 01011 00000000000
--1C015800
--
--
--11. or $12, $0, $1 (same register vals as inst 10) * ans = 1
--001000 00000 00001 01100 00000000000
--20016000
--
--12. slt $13, $6, $9 ($6 should hold 8 from inst 3, $9 = 5 from inst 4) * ans = 0
--001001 00110 01001 01101 00000000000
--24C96800
--
--13. xor $14, $1, $1 ($1 still holds 1) * ans = 0
--001010 00001 00001 01110 00000000000
--28217000
--
--14. srl $15, $6, $8 ($6 should hold 8 from inst 3, $8 = 2) * ans = 2
--001100 00110 01000 01111 00000000000
--30C87800


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY INSTRUCTION_MEMORY IS
	PORT (clk : IN std_logic;
		ADDRESS : IN STD_LOGIC_VECTOR (31 DOWNTO 0); 	 -- Address where the instruction is stored
		INSTRUCTION : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) -- The instruction itself
	);
END INSTRUCTION_MEMORY;
ARCHITECTURE Behavioral OF INSTRUCTION_MEMORY IS
	TYPE RAM_32_x_32 IS ARRAY(0 TO 31) OF std_logic_vector(31 DOWNTO 0); -- Instruction ram is 32 words long (1 word = 32 bits)
	SIGNAL InstMem : RAM_32_x_32 := ( -- Initialize all instructions to zero (for now)
		x"04220002",
		x"1C851800",
		x"2CE83000",
		x"34290000",
		x"382B0001",
		x"08240000",
		x"0C250000",
		x"10420004",
		x"18C71800",
		x"1C015800",
		x"20016000",
		x"24C96800", 
		x"28217000", 
		x"30C87800", 
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
	process(clk)
	begin
	if rising_edge(clk) then
		INSTRUCTION <= InstMem(to_integer(unsigned(ADDRESS))); -- Fetch instruction at the indicated address
	end if;
	end process;
END Behavioral;

