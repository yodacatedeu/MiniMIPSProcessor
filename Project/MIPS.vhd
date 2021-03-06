-- The MIPS Processor
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
USE IEEE.NUMERIC_STD.ALL;
library work;

entity MIPS is
port (
reset: in std_logic; 
clk: in std_logic;
 pc_out: out std_logic_vector(31 downto 0)

);
end MIPS;

architecture Behavioral of MIPS is

---------- Components ---------------------------------------------

	-- Control Unit
	component ControlUnit
	port(--clk : IN std_logic;C:/Users/aronb/OneDrive/Com Architecture/Project/MIPS.vhd
		opcode        : IN std_logic_vector(5 DOWNTO 0); -- instruction 31-26 -- this will also be sent direcly to ALU
		ALUop	      : OUT std_logic_vector(5 DOWNTO 0); -- will be same as opcode
		regDst        : OUT std_logic; -- 0 for immediate and LW/SW, 1 for register arith
		memRead       : OUT std_logic; -- 1 for reading memory
		memToRegister : OUT std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		memWrite      : OUT std_logic; -- 1 for writing data
		ALUsrc        : OUT std_logic; -- 0 for second operand to be a register else 1 for second operand is immediate value (direct value offest for a mem address)
		regWrite      : OUT std_logic  -- 1 for computed result is written to destination register, in this project only 0 for SW 
	);
	end component;
	for ctrlUnit: ControlUnit use entity work.ControlUnit;

	-- Instruction Memory
	component INSTRUCTION_MEMORY
	port(clk : IN std_logic;
		ADDRESS : IN STD_LOGIC_VECTOR (31 DOWNTO 0); 	 -- Address where the instruction is stored
		INSTRUCTION : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) -- The instruction itself
	);
	end component;
	for instMEM: INSTRUCTION_MEMORY use entity work.INSTRUCTION_MEMORY;
    
     -- Data Memory
    component DATA_MEMORY
    port(--clk : IN std_logic;
    		ADDRESS   : IN STD_LOGIC_VECTOR (31 DOWNTO 0); 	-- Address to access
		READ_DATA  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);-- Data to read
		WRITE_DATA : IN STD_LOGIC_VECTOR (31 DOWNTO 0);	-- Data to Write
		MEM_READ   : IN STD_LOGIC;			-- Read indicator (1 for read, 0 else)
		MEM_WRITE  : IN STD_LOGIC			-- Write indicator (1 for write, 0 else)
    );
    end component;
    for dataMEM: DATA_MEMORY use entity work.DATA_MEMORY;
    
    -- ALU
    component alu
    port(--clk : IN std_logic;
		a1           : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- Arg 1
		a2           : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- Arg 2
		alu_control  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);  -- The operation
		alu_result   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);-- the result
		zero         : OUT STD_LOGIC			  -- true if the result = 0, else false 
	);
    end component;
    for alu0: alu use entity work.alu;

    -- ALU Control
    component alu_control
	port(--clk : IN std_logic;
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
    end component;
    for aluCtrl: alu_control use entity work.alu_control;

    -- Register File
    component REGISTER_FILE
        port(--clk : IN std_logic;
		readRegister1 : IN std_logic_vector (4 DOWNTO 0);  -- First Register to read from
		readRegister2 : IN std_logic_vector (4 DOWNTO 0);  -- Second register to read from
		readData1     : OUT std_logic_vector (31 DOWNTO 0);-- Data read from register 1
		readData2     : OUT std_logic_vector (31 DOWNTO 0);-- Data read from register 2

		registerWrite : IN std_logic;			   -- Indicator if register is to be written to a register (1 is true)
		writeRegister : IN std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to
		writeData     : IN std_logic_vector (31 DOWNTO 0)  -- Data to be written to a register
	);
            
    end component;
    for rf0 : REGISTER_FILE use entity work.REGISTER_FILE;
    --for rf1 : REGISTER_FILE use entity work.REGISTER_FILE;


    -- Sign Extender
    component SIGN_EXTENDER
        port(
		numIn   : IN STD_logic_vector(15 DOWNTO 0); -- num to be extended
		numOut  : OUT STD_logic_vector(31 DOWNTO 0) -- the extended number
	);
    end component;
    for signext0 : SIGN_EXTENDER use entity work.SIGN_EXTENDER;

    -- Two to One 32-bit Multiplexer
    component TwoToOneMux
        port(
		in0      : IN std_logic_vector(31 DOWNTO 0);  -- first input
		in1      : IN std_logic_vector(31 DOWNTO 0);  -- second input
		out0     : OUT STD_logic_vector(31 DOWNTO 0);-- output
		cSwitch  : IN STD_logic        		      -- switch
	);
    end component;
    for muxalusrc : TwoToOneMux use entity work.TwoToOneMux;
    for muxaluout : TwoToOneMux use entity work.TwoToOneMux;

    -- Two to One 5-bit Multiplexer
    component Reg_Dest_Mux
        port(
		in0      : IN std_logic_vector(4 DOWNTO 0);  -- first input
		in1      : IN std_logic_vector(4 DOWNTO 0);  -- second input
		out0     : OUT STD_logic_vector(4 DOWNTO 0);-- output
		cSwitch  : IN STD_logic        		      -- switch
	);
    end component;
    for muxregdest: Reg_Dest_Mux use entity work.Reg_Dest_Mux;

    -- If/ID Pipeline Register
    component IFToID
    Port (clk         : in std_logic;
	  -- Inputs

		instruction  	  : IN STD_logic_vector(31 DOWNTO 0);  -- the instruction

		-- Outputs (same as Inputs)
		OpCode		: OUT std_logic_vector(5 DOWNTO 0);	-- the opeartion
		readRegister1	: OUT std_logic_vector (4 DOWNTO 0); 	-- the first register rs
		readRegister2   : OUT std_logic_vector (4 DOWNTO 0);	-- the second register rt
		immediateValue  : OUT std_logic_vector (15 DOWNTO 0);	-- the immediate value
		IwriteRegister  : OUT std_logic_vector (4 DOWNTO 0); 	-- Register where where data will be written to if "I" instruction
		RwriteRegister  : OUT std_logic_vector (4 DOWNTO 0)  	-- Register where where data will be written to if "R" instruction
	);
    end component;
    for regpipe1 : IFToID use entity work.IFToID;

    -- ID/EX Pipeline Register
    component IDToEX 
    Port (clk : IN std_logic;
		-- Inputs
				
		ALUopIN	      	  : IN std_logic_vector(5 DOWNTO 0); -- same as opcode
		regDstIN          : IN std_logic; -- 0 for immediate and LW/SW, 1 for register arith
		memReadIN         : IN std_logic; -- 1 for reading memory
		memToRegisterIN   : IN std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		memWriteIN        : IN std_logic; -- 1 for writing data
		ALUsrcIN          : IN std_logic; -- 0 for second operand to be a register else 1 for second operand is immediate value (direct value offest for a mem address)
		regWriteIN  	  : IN std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readData1IN       : IN std_logic_vector (31 DOWNTO 0);-- Data read from register 1
		readData2IN       : IN std_logic_vector (31 DOWNTO 0);-- Data read from register 2
		signExtendIN  	  : IN STD_logic_vector(31 DOWNTO 0);  -- the extended number
		IwriteRegisterIN  : IN std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to if "I" instruction
		RwriteRegisterIN  : IN std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to if "R" instruction

		-- Outputs (same as Inputs)
		ALUopOUT	   : OUT std_logic_vector(5 DOWNTO 0); -- same as opcode
		regDstOUT          : OUT std_logic; -- 0 for immediate and LW/SW, 1 for register arith
		memReadOUT         : OUT std_logic; -- 1 for reading memory
		memToRegisterOUT   : OUT std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		memWriteOUT        : OUT std_logic; -- 1 for writing data
		ALUsrcOUT          : OUT std_logic; -- 0 for second operand to be a register else 1 for second operand is immediate value (direct value offest for a mem address)
		regWriteOUT  	   : OUT std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readData1OUT       : OUT std_logic_vector (31 DOWNTO 0);-- Data read from register 1
		readData2OUT       : OUT std_logic_vector (31 DOWNTO 0);-- Data read from register 2
		signExtendOUT  	   : OUT STD_logic_vector(31 DOWNTO 0);  -- the extended number
		IwriteRegisterOUT  : OUT std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to if "I" instruction
		RwriteRegisterOUT  : OUT std_logic_vector (4 DOWNTO 0)  -- Register where where data will be written to if "R" instruction
		
	);
    end component;
    for regpipe2 : IDToEx use entity work.IDToEX;

    -- EX/MEM Pipeline Register
    component EXToMEM
    Port (clk : IN std_logic;
		-- Input
		memReadIN         : IN std_logic; -- 1 for reading memory
		memToRegisterIN   : IN std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		memWriteIN        : IN std_logic; -- 1 for writing data
		regWriteIN  	  : IN std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readData2IN       : IN std_logic_vector (31 DOWNTO 0);-- Data read from register 
		ALUResultIN 	  : IN std_logic_vector (31 DOWNTO 0);-- Computed result from ALU
		writeRegisterIN   : IN std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to (Came from multiplexer between IwriteRegister and RwriteRegister)

		-- Outputs (same as Inputs)
		memReadOUT         : OUT std_logic; -- 1 for reading memory
		memToRegisterOUT   : OUT std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		memWriteOUT        : OUT std_logic; -- 1 for writing data
		regWriteOUT  	   : OUT std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readData2OUT       : OUT std_logic_vector (31 DOWNTO 0);-- Data read from register 2
		ALUResultOUT 	   : OUT std_logic_vector (31 DOWNTO 0);-- Computed result from ALU
		writeRegisterOUT   : OUT std_logic_vector (4 DOWNTO 0)  -- Register where where data will be written to (Came from multiplexer between IwriteRegister and RwriteRegister)
		
	);
    end component;
    for regpipe3 : EXToMEM use entity work.EXToMEM;

    -- MEM/WB Pipeline Register
    component MEMToWB
    Port (clk : IN std_logic;
		-- Inputs
				
		memToRegisterIN   : IN std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		regWriteIN  	  : IN std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readDataIN       : IN std_logic_vector (31 DOWNTO 0);-- Data read from memory
		ALUResultIN 	  : IN std_logic_vector (31 DOWNTO 0);-- Computed result from ALU
		writeRegisterIN   : IN std_logic_vector (4 DOWNTO 0);  -- Register where where data will be written to (Came from multiplexer between IwriteRegister and RwriteRegister)

		-- Outputs (same as Inputs)
		
		memToRegisterOUT   : OUT std_logic; -- 0 for memRead data goes to destination register else 1 for ALU result to destination register
		regWriteOUT  	   : OUT std_logic;  -- 1 for computed result is written to destination register, in this project only 0 for SW
		readDataOUT       : OUT std_logic_vector (31 DOWNTO 0);-- Data read from memory
		ALUResultOUT 	   : OUT std_logic_vector (31 DOWNTO 0);-- Computed result from ALU
		writeRegisterOUT   : OUT std_logic_vector (4 DOWNTO 0)  -- Register where where data will be written to (Came from multiplexer between IwriteRegister and RwriteRegister)
	);
    end component;
    for regpipe4 : MEMToWB use entity work.MEMToWB;

    -- Program Counter (It's really just a wrapper)
    Component PROGRAM_COUNTER
    Port (
          PC_IN   : in std_logic_vector(31 downto 0);
          PC_OUT   : out std_logic_vector(31 downto 0));
    end component;
    for pcreg : PROGRAM_COUNTER use entity work.PROGRAM_COUNTER;

-- PC Adder
    component PC_ADDER
        port(
		PC_IN 	  : in std_logic_vector(31 downto 0);
             	PC_OUT    : out std_logic_vector(31 downto 0) -- incremented PC
	);
    end component;
    for pcadder : PC_ADDER use entity work.PC_ADDER;
  
------------ End Components ---------------------------

-- Signals
	signal pc_current: std_logic_vector(31 downto 0);
 	signal pcnext: std_logic_vector(31 downto 0);
	signal pc4: std_logic_vector(31 downto 0);
 	signal instr: std_logic_vector(31 downto 0);
 	signal reg_dst, reg_dstE, mem_to_reg, mem_to_regE, mem_to_regM, mem_to_regW: std_logic;
	signal OpCode, ALUop, ALUopE :  std_logic_vector(5 DOWNTO 0);
 	signal mem_read, mem_readE, mem_readM, mem_write, mem_writeE, mem_writeM, alu_src, alu_srcE, reg_write, reg_writeE, reg_writeM, reg_writeW: std_logic;
 	signal reg_write_dest, reg_write_destM, reg_write_destW: std_logic_vector(4 downto 0);
 	signal reg_write_data: std_logic_vector(31 downto 0);
 	signal reg_read_addr_1: std_logic_vector(4 downto 0);
 	signal reg_read_data_1, reg_read_data_1E: std_logic_vector(31 downto 0);
 	signal reg_read_addr_2: std_logic_vector(4 downto 0);
 	signal reg_read_data_2, reg_read_data_2E, reg_read_data_2M: std_logic_vector(31 downto 0);
	signal immediateVal : std_logic_vector(15 downto 0);
	signal IwriteRegister, IwriteRegisterE, RwriteRegister, RwriteRegisterE : std_logic_vector(4 downto 0);
 	signal sign_ext_im, sign_ext_imE: std_logic_vector(31 downto 0); --, read_data2
 	signal ctrlALU: std_logic_vector(3 downto 0);
 	signal ALU_out, ALU_outM, ALU_outW: std_logic_vector(31 downto 0);
 	signal zero_flag: std_logic;
 	signal mem_read_data, mem_read_dataW: std_logic_vector(31 downto 0);
 	signal tmp1: std_logic_vector(31 downto 0);
	signal ALUArg2 :std_logic_vector(31 downto 0);
	signal nullSig1, nullSig2 :std_logic_vector(31 downto 0);

	
begin

--nullSig1 <= x"00000000";
--nullSig2 <= x"00000000";
process(clk,reset)
begin 
if(reset='1') then
	pc_current <= x"00000000";
 elsif(rising_edge(clk)) then
  pc_current <= pcnext;
 end if;
end process;
--

--------------- The Data Path ---------------------------------------------------- 

-- IF: PC, Increment PC, instMEM, and regpipe1
	-- Program counter initialize
	pcreg : PROGRAM_COUNTER port map(pc_current, tmp1); 
	--pc4 <= pc_current; -- testing with pc
	--pc4 <= std_logic_vector(signed(pc_current) + x"00000004"); -- tetsing w/o using PC entitites
	-- Increment PC
	pcadder : PC_ADDER port map(tmp1, pc4);
	pcnext <= pc4;
	-- Fetch Instruction
	instMem : INSTRUCTION_MEMORY port map(clk, pc_current, instr);
	-- Send Instruction to IF/ID pipeline register
	regpipe1 : IFToID port map(clk, instr,  OpCode, reg_read_addr_1, reg_read_addr_2, immediateVal, IwriteRegister, RwriteRegister);
	
-- ID: ctrlUnit, Register File, signExtender and regpipe2
	-- Send instruction's opcode to the Control Unit
	ctrlUnit : ControlUnit port map(OpCode, ALUop, reg_dst, mem_read, mem_to_reg, mem_write, alu_src, reg_write);
	-- Access the Register File (inputs come from the IF/ID pipeline register) and Data from WB stage is written back here
	rf0: REGISTER_FILE port map(reg_read_addr_1, reg_read_addr_2, reg_read_data_1, reg_read_data_2, reg_writeW, reg_write_destW, reg_write_data);
	-- Extend the immediate value
	signext0: SIGN_EXTENDER port map(immediateVal, sign_ext_im);
	-- Send the control values, data from the register file, and the extended immediate value to the ID/EX pipeline Register
	regpipe2: IDToEX port map(clk, ALUop, reg_dst, mem_read, mem_to_reg, mem_write, alu_src, reg_write, reg_read_data_1, reg_read_data_2, sign_ext_im, IwriteRegister, RwriteRegister,
				       ALUopE, reg_dstE, mem_readE, mem_to_regE, mem_writeE, alu_srcE, reg_writeE, reg_read_data_1E, reg_read_data_2E, sign_ext_imE, IwriteRegisterE, RwriteRegisterE);

-- EX: MUX for aluSrc, ALUctrl, ALU, MUX for regDST, regpipe3
	-- Determine if the extended immediate value, or if the second register will be the other operand for the ALU via a multiplexer
	muxalusrc: TwoToOneMux port map(reg_read_data_2E, sign_ext_imE, ALUArg2, alu_srcE);
	-- Determine the actual ALU operation via the ALU Control Unit
	aluCtrl: alu_control port map(ALUopE, ctrlALU);
	-- Compute the result within the ALU
	alu0: ALU port map(reg_read_data_1E, ALUArg2, ctrlAlu, ALU_out, zero_flag);
	-- Determine the destination register (For either I or R instrcution) via a multiplexer
	muxregdest: Reg_Dest_Mux port map(IwriteRegisterE, RwriteRegisterE, reg_write_dest, reg_dstE);
	-- Continue passing along the neded control values, the ALUResult, and the destination register via the EX/MEM pipeline register
	regpipe3: EXToMEM port map(clk, mem_readE, mem_to_regE, mem_writeE, reg_writeE, reg_read_data_2E, ALU_out, reg_write_dest,
					mem_readM, mem_to_regM, mem_writeM, reg_writeM, reg_read_data_2M, ALU_outM, reg_write_destM);

-- MEM: dataMEM and regpipe4
	-- Access the data memory (if applicable) and either read or write data
	dataMEM: Data_Memory port map(alu_outM, mem_read_data, reg_read_data_2M, mem_readM, mem_writeM);
	-- Pass along the remaining control values, data from memory, the ALUResult, and the destination register via the MEMToWB pipeline register 
	regpipe4: MEMToWB port map(clk, mem_to_regM, reg_writeM, mem_read_data, ALU_outM, reg_write_destM,
					mem_to_regW, reg_writeW, mem_read_dataW, ALU_outW, reg_write_destW);

-- WB: muxaluout, and Register File once more
	-- Determine whether to write back the ALUResult or the data from memory to the destination register via a multiplexer
	muxaluout: TwoToOneMux port map(mem_read_dataW, ALU_outW, reg_write_data, mem_to_regW);

------ End Data Path -----------------------------------------
pc_out <= pc_current;
--data_written <= reg_write_data;

end behavioral;
