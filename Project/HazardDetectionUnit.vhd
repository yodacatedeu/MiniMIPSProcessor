-- Hazard Detection (will attempt at an implemetation but will unlikely be integrated into this project)
-- It is meant to only detect Load-Use Hazard, for the Forwarding Unit is meant to handle data hazards
-- Note this processor does not support branches nor jumps, so no detecion of branch hazards.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY HazardDetectionUnit IS
	PORT (
		-- Inputs
		IFToIDRegisterRs 	: in std_logic_vector(4 downto 0);	-- Rs comming out from IFToID pipeline register
		IFToIDRegisterRt 	: in std_logic_vector(4 downto 0);	-- Rt comming out from IFToID pipeline register
		IDToEXMemRead		: in std_logic; 			-- Coming out from IDToEX pipeline register: 1 for reading data memory, 0 else
		IDToEXRegisterRt 	: in std_logic_vector(4 downto 0);	-- Rt comming out from IDToEX pipeline register

		-- Outputs		
		PCWrite 		: out std_logic;			-- Used to stall instruction fetch by preventing program counter increment with the value being 0 for the stall
		IFToIDWrite 		: out std_logic;			-- Used to stall IFToID pipeline register by value being 0
		SwitchForMUXToIDToEX	: out std_logic 			-- A switch used to stall control values being sent to IDToEX pipeline register by this switch being set to 1 which is used in the 
										-- multiplexer between the Control Unit and the IDToEX pipeline register, in which all control values will be set to 0.
		
	);
END HazardDetectionUnit;

ARCHITECTURE Behavioral OF HazardDetectionUnit IS
BEGIN
	process(IFToIDRegisterRs, IFToIDRegisterRt, IDToEXMemRead, IDToEXRegisterRt)
	begin
		-- Check for Load-Use Hazard detection, stall if true
		-- ID/EX.MemRead       and((ID/EX.RegisterRt = IF/ID.RegisterRs) or  (ID/EX.RegisterRt = IF/ID.RegisterRt))
		if IDToEXMemRead = '1' and((IDToEXRegisterRt = IFToIDRegisterRs) or  (IDToEXRegisterRt = IFToIDRegisterRt)) then
			PCWrite 		<= '0';
			IFToIDWrite		<= '0';
			SwitchForMUXToIDToEX 	<= '1';
		-- Else proceed as normal
		else
			PCWrite 		<= '1';
			IFToIDWrite		<= '1';
			SwitchForMUXToIDToEX 	<= '0';
		end if;
	end process;

END Behavioral;
