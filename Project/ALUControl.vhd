-- The ALU Control component: determines one of eight operations from the opcode
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY alu_control IS
	PORT (
		ALUOp     : IN STD_LOGIC_VECTOR (5 DOWNTO 0); -- the op code
		-- 14 diff instructions: 
		-- (1)Addi, 
		-- (2)Andi, 
		-- (3)Ori, 
		-- (4)Slti, 
		-- (5)Add, 
		-- (6)Sub, 
		-- (7)And, 
		-- (8)Or, 
		-- (9)Slt, 
		-- (10)Xor, 
		-- (11)Sll, 
		-- (12)Srl, 
		-- (13)LW, 
		-- (14)SW
		operation : OUT STD_LOGIC_VECTOR (3 DOWNTO 0) -- the actual operation (8 different ones)
		-- 1 addi, add, lw, or sw (instruction 1, 5, 13, and 14)
		-- 2 ori or or (3 and 8)
		-- 3 slti or slt (4 and 9)
		-- 4 sub (6)
		-- 5 andi or and (2 and 7)
		-- 6 xor (10)
		-- 7 sll (11)
		-- 8 srl (12)

	);
END alu_control;
ARCHITECTURE Behavioral OF alu_control IS --
BEGIN
	process(ALUOp)
	begin	
		if ALUOp = "000001" or ALUOp = "000101" or ALUOp = "001101" or ALUOp = "001110" then -- 1: addi, add, lw, or sw (instruction 1, 5, 13, and 14)
			operation <= "0001";   
		elsif ALUOp = "000011" or ALUOp = "001000" then -- 2: ori or or (3 and 8)	
			operation <= "0010";	
		elsif ALUOp = "000100" or ALUOp = "001001" then -- 3: slti or slt (4 and 9)	
			operation <= "0011";
		elsif ALUOp = "000110" 			   then -- 4: sub (6)	
			operation <= "0100";
		elsif ALUOp = "000010" or ALUOp = "000111" then -- 5: andi or and (2 and 7)	
			operation <= "0101";
		elsif ALUOp = "001010" 		           then -- 6: xor (10)	
			operation <= "0110";
		elsif ALUOp = "001011"		  	   then -- 7: sll (11)	
			operation <= "0111";
		elsif ALUOp = "001100"			   then -- 8: srl (12)	
			operation <= "1000";
		else
			operation <= "0000";	
		
		END if;
	end Process;

END Behavioral;
