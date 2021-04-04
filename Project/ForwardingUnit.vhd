-- Forwarding Unit, meant to handle all other data hazards (excluding Branch/Jump).  This implementation will unlikely be integrated into the main processor
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY ForwardingUnit IS
	PORT (
		-- Inputs
		IDToEXRegisterRs 	: in std_logic_vector(4 downto 0);	-- Rs comming out from IFToID pipeline register
		IDToEXRegisterRt 	: in std_logic_vector(4 downto 0);	-- Rt comming out from IFToID pipeline register
		EXToMEMRegisterRd	: in std_logic_vector(4 downto 0);	-- Destination register coming from EXToMEM pipeline register
		MEMToWBRegisterRd	: in std_logic_vector(4 downto 0);	-- Destination register coming from MEMToWB pipeline register
		EXToMEMRegWrite		: in std_logic; 			-- RegWrite control value from EXToMEM pipeline register
		MEMToWBRegWrite		: in std_logic; 			-- RegWrite control value from MEMToWB pipeline register

		-- Outputs		
		ALUArg1Switch		: out std_logic_vector(1 downto 0); 	-- Used in 1st 3-1 Multiplexer before ALU to determine the 1st argument
		ALUArg2Switch		: out std_logic_vector(1 downto 0)	-- Used in 2nd 3-1 Multiplexer before ALU to determine the 2nd argument
		
	);
END ForwardingUnit;

ARCHITECTURE Behavioral OF ForwardingUnit IS
BEGIN
	process(IDToEXRegisterRs, IDToEXRegisterRt, EXToMEMRegisterRd, MEMToWBRegisterRd, EXToMEMRegWrite, MEMToWBRegWrite)
	begin	
		-- In all cases, in order to forward: the forwarding instruction must write to a register (EX/MEM.RegWrite or MEM/WB.RegWrite = 1) 
		-- and the destination register cannnot be $zero since it is supposed to be a constant; thus, its data is not meant to change.
		
	-- Check if data hazard for ALU Arg 1.  To handle double data hazards, only forward from MEM/WB if not already forwarding from EX/MEM
		-- EX/MEM.RegisterRd = ID/EX.RegisterRs: forward from EX/MEM pipeline register for ALU Arg 1
		if EXToMEMRegisterRd = IDToEXRegisterRs and not(EXToMEMRegisterRd = "00000") and EXToMEMRegWrite ='1' then
			ALUArg1Switch <= "10"; -- Multiplexer will pick 3rd input for ALU arg 1 (Coming from ALU result in EX/MEM pipeline register)
		--    MEM/WB.RegisterRd = ID/EX.RegisterRs: forward from MEMToWB pipeline register for ALU Arg 1
		elsif MEMToWBRegisterRd = IDToEXRegisterRs and not(MEMToWBRegisterRd = "00000") and MEMToWBRegWrite ='1' then
			ALUArg1Switch <= "01"; -- Multiplexer will pick 2nd input for ALU arg 1 (Coming from ALU result in MEM/WB pipeline register)
		-- Else don't forward: pick the default argument for the ALU Arg 1 ("00")
		else
			ALUArg1Switch <= "00";
		end if;
			
	-- Check if data hazard for ALU Arg 2.  To handle double data hazards, only forward from MEM/WB if not already forwarding from EX/MEM
		-- EX/MEM.RegisterRd = ID/EX.RegisterRt: forward from EX/MEM pipeline register for ALU Arg 2
		if EXToMEMRegisterRd = IDToEXRegisterRt and not(EXToMEMRegisterRd = "00000") and EXToMEMRegWrite ='1' then
			ALUArg2Switch <= "10"; -- Multiplexer will pick 3rd input for ALU arg 2 (Coming from ALU result in EX/MEM pipeline register)
		--    MEM/WB.RegisterRd = ID/EX.RegisterRt: forward from MEMToWB pipeline register for ALU Arg 2
		elsif MEMToWBRegisterRd = IDToEXRegisterRt and not(MEMToWBRegisterRd = "00000") and MEMToWBRegWrite ='1' then
			ALUArg2Switch <= "01"; -- Multiplexer will pick 2nd input for ALU arg 2 (Coming from ALU result in MEM/WB pipeline register)
		-- Else don't forward: pick the default argument for the ALU Arg 2 ("00")
		else
			ALUArg2Switch <= "00";	
		end if;

	end process;

END Behavioral;
