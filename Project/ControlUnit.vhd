-- The Control Unit (Differs from stndard MIPS as it simply takes 14 different instructions determined by the opcode)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY ControlUnit IS
	PORT (
		opcode        : IN std_logic_vector(5 DOWNTO 0); -- instruction 31-26 -- this will also be sent direcly to ALU
		ALUop	      : OUT std_logic_vector(5 DOWNTO 0); -- will be same as opcode
		regDst        : OUT std_logic; -- 0 for immediate and LW/SW, 1 for register arith
		memRead       : OUT std_logic; -- 1 for reading memory
		memToRegister : OUT std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		memWrite      : OUT std_logic; -- 1 for writing data
		ALUsrc        : OUT std_logic; -- 0 for second operand to be a register else 1 for second operand is immediate value (direct value offest for a mem address)
		regWrite      : OUT std_logic  -- 1 for computed result is written to destination register, in this project only 0 for SW 
	);
END ControlUnit;
ARCHITECTURE Behavioral OF ControlUnit IS
BEGIN
	PROCESS (opcode)
	BEGIN
		--regWrite <= '0'; --Deassert for next command -- ignore for now
		

-- 14 diff instructions: (1)Addi, (2)Andi, (3)Ori, (4)Slti, (5)Add, (6)Sub, (7)And, (8)Or, (9)Slt, (10)Xor, (11)Sll, (12)Srl, (13)LW, (14)SW (there will be 9 different operations in ALU)
			if (opcode >  "000000" and opcode <  "000101") then -- Inst 1 - 4: Imediate Arithmetic 
				regDst        <= '0'; -- maybe coul be "x"
				memRead       <= '0';
				memToRegister <= '1';
				memWrite      <= '0';
				ALUsrc        <= '1';
				regWrite      <= '1'; --AFTER 10 ns; -- ignore these for now
			elsif (opcode >  "000100" and opcode <  "001101") then-- Inst 5 - 12: Register Arithmetic (Shifts will be register arithmetic here)
 				regDst        <= '1';
				memRead       <= '0';
				memToRegister <= '1';
				memWrite      <= '0';
				ALUsrc        <= '0';
				regWrite      <= '1'; --AFTER 10 ns;
			elsif opcode =  "001101" then-- Inst: 13 LW
				regDst        <= '0';
				memRead       <= '1';
				memToRegister <= '0';
				memWrite      <= '0';
				ALUsrc        <= '1';
				regWrite      <= '1'; --AFTER 10 ns;
			elsif opcode =  "001110" then -- Inst: 14 SW
				regDst        <= '0';
				memRead       <= '0';
				memToRegister <= 'X'; -- doesn't matter
				memWrite      <= '1';
				ALUsrc        <= '1';
				regWrite      <= '0'; --AFTER 10 ns;
			else 			      -- nothing
				regDst        <= '0';
				memRead       <= '0';
				memToRegister <= '0';
				memWrite      <= '0';
				ALUsrc        <= '0';
				regWrite      <= '0';
			END if;
			ALUop <= opcode;
	END PROCESS;
END Behavioral;
