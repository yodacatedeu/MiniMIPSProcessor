-- The ALU: preforms 8 different operations:
-- 1 add 
-- 2. or 
-- 3. set less than 
-- 4. subtract 
-- 5. and 
-- 6. xor 
-- 7. shift left 
-- 8. shift right
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY ALU IS
	PORT (
		a1           : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- Arg 1
		a2           : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- Arg 2
		alu_control  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);  -- The operation
		alu_result   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);-- the result
		zero         : OUT STD_LOGIC			  -- true if the result = 0, else false 
	);
END ALU;
ARCHITECTURE Behavioral OF ALU IS
	SIGNAL resultX : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
	PROCESS (a1, a2, alu_control)
	BEGIN
		CASE alu_control IS
			-- 1: addition
			WHEN "0001" =>
				resultX <= std_logic_vector(signed(a1) + signed(a2));
			-- 2: or
			WHEN "0010" =>
				resultX <= a1 OR a2;
			-- 3: set les than
			WHEN "0011" =>
				IF (signed(a1) < signed(a2)) THEN
					resultX <= x"00000001";
				ELSE
					resultX <= x"00000000";
				END IF;
			-- 4: subtract
			WHEN "0100" =>
				resultX <= std_logic_vector(signed(a1) - signed(a2));
			-- 5: and
			WHEN "0101" =>
				resultX <= a1 AND a2;
			-- 6: xor
			WHEN "0110" =>
				resultX <= a1 XOR a2;
			-- 7: shift left
			WHEN "0111" =>
				resultX <= std_logic_vector(shift_left(signed(a1), to_integer(unsigned(a2))));
			-- 8: shift right
			WHEN "1000" =>
				resultX <= std_logic_vector(shift_right(signed(a1), to_integer(unsigned(a2))));
			-- Nop
			WHEN others => NULL;
			resultX <= x"00000000";
		END CASE;
	END PROCESS;
	-- concurent code
	alu_result <= resultX;
	zero <= '1' WHEN resultX = x"00000000" ELSE
	        '0';
END Behavioral;
