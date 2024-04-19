----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2024 06:07:20 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity test_env is
    Port ( 
           clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
         );
end test_env;


architecture Behavioral of test_env is


component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;



component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;



component UC is
     Port ( Instr: in std_logic_vector(5 downto 0);
            RegDst: out std_logic;
            ExtOp: out std_logic;            
            ALUSrc: out std_logic; 
            Branch: out std_logic; 
            Jump: out std_logic;
            ALUOp: out std_logic_vector(1 downto 0);
            MemWrite: out std_logic;
            MemtoReg: out std_logic;
            RegWrite: out std_logic;
            JmpR:  out std_logic
        );
end component;




component ID is
    
    port(
        reg_write: in std_logic;
        instr: in std_logic_vector(25 downto 0);
        reg_dst: in std_logic;
        en: in std_logic;
        ext_op: in std_logic;
        wd: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        
        ext_imm: out std_logic_vector(31 downto 0);
        rd1: out std_logic_vector(31 downto 0);
        rd2: out std_logic_vector(31 downto 0);
        func: out std_logic_vector(5 downto 0);
        sa: out std_logic_vector(4 downto 0)
    
    );
    
end component;



component IFetch is

port(
    jump : in std_logic;
    jumpAddress : in std_logic_vector(31 downto 0);
    PCSrc : in std_logic;
    BranchAddress : in std_logic_vector(31 downto 0);
    rst : in std_logic;
    en : in std_logic;
    clk : in std_logic;
    Instruction : out std_logic_vector(31 downto 0);
    PC4 : out std_logic_vector(31 downto 0)
);

end component;


component EX is

Port (  RD1: in std_logic_vector(31 downto 0);
            ALUSrc : in std_logic;
            RD2: in std_logic_vector(31 downto 0);
            Ext_Imm: in std_logic_vector(31 downto 0);
            sa: in std_logic_vector(4 downto 0);
            func: in std_logic_vector(5 downto 0);
            ALUOp: in  std_logic_vector(1 downto 0);
            PC4: in std_logic_vector(31 downto 0);
            BranchAddress: out std_logic_vector(31 downto 0);
            ALURes: out std_logic_vector(31 downto 0);
            Zero: out std_logic
    );
    
end component;

component MEM is

Port (  
        MemWrite: in std_logic;
        ALUResIN: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        en: in std_logic;
        MemData : out std_logic_vector(31 downto 0);
        ALUResOUT: out std_logic_vector(31 downto 0)
    );

end component;

signal enable: std_logic;
signal jump_UC: std_logic;
signal instruction: std_logic_vector(31 downto 0);
signal pc: std_logic_vector(31 downto 0);
signal reg_write_UC: std_logic;
signal reg_dst, ext_op: std_logic;
signal branch_address: std_logic_vector(31 downto 0);
signal rd1,rd2: std_logic_vector(31 downto 0);
signal sum: std_logic_vector(31 downto 0);
signal ext_imm: std_logic_vector(31 downto 0);
signal func: std_logic_vector(5 downto 0);
signal sa: std_logic_vector(4 downto 0);
signal alu_res: std_logic_vector(31 downto 0);
signal func_ext,sa_ext: std_logic_vector(31 downto 0);
signal alu_res_out: std_logic_vector(31 downto 0);
signal mem_data: std_logic_vector(31 downto 0);

signal alu_op: std_logic_vector(1 downto 0);
signal zero: std_logic;
signal branch, jump,alu_src, mem_write, mem_to_reg, reg_write : std_logic;
signal pc_src: std_logic;
signal mux_out: std_logic_vector(31 downto 0);


begin


MPG_inst: MPG port map(enable,btn(0),clk);



IFetch_inst: IFetch port map(
jump_UC,
X"00000000",
sw(1),
branch_address,
btn(1),
enable,
clk,
instruction,
pc
);



ID_inst: ID port map(
reg_write_UC,
instruction(25 downto 0),
reg_dst,
enable,
ext_op,
sum,
clk,
rd1,
rd2,
ext_imm,
func,
sa
);



UC_inst: UC port map(
instruction(31 downto 26),
reg_dst,
ext_op,
alu_src,
branch,
jump,
alu_op,
mem_write,
mem_to_reg,
reg_write
);


EX_inst: EX port map(
rd1,
alu_src,
rd2,
ext_imm,
sa,
func,
alu_op,
pc,
branch_address,
alu_res,
zero
);

MEM_inst: MEM port map(
mem_write,
alu_res,
rd2,
clk,
enable,
alu_res_out,
mem_data
);

process(mem_to_reg, alu_res_out, mem_data)
begin
    case mem_to_reg is
    when '1' => sum <= alu_res_out;
    when others => sum <= mem_data;
    end case;
end process;


func_ext <= "00000000000000000000000000" & func;
sa_ext <=   "000000000000000000000000000" & sa;
pc_src <= zero and branch;

process(sw(7 downto 5))
begin

    case sw(7 downto 5) is
    
    when "000" => mux_out <= instruction;
    when "001" => mux_out <= pc;
    when "010" => mux_out <= rd1;
    when "011" => mux_out <=rd2;
    when "100" => mux_out <=sum;
    when "101" => mux_out <= ext_imm;
    when "110" => mux_out <= func_ext;
    when others => mux_out <= sa_ext;
    
    end case;
    
end process;
    
    SSD_inst: SSD port map(
    clk,
    mux_out,
    an,
    cat
    );
    


led(9 downto 0) <= alu_op & reg_dst & ext_op & alu_src & branch & jump & mem_write & mem_to_reg & reg_write;






end Behavioral;