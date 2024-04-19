----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2024 06:46:24 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity IFetch is
Port (
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
end IFetch;
 
architecture Behavioral of IFetch is
type ROMentry is array(0 to 31) of std_logic_vector(31 downto 0);
signal ROM : ROMentry := (
 --instructions
 B"100011_00001_00000_0000000000000000", --X"8C200000"
 B"100011_00010_00000_0000000000000100", --X"8C400004"
 B"000000_00000_00001_00011_00000_100000", --X"00011820"
 B"000000_00000_00000_00100_00000_100000", --X"00002020"
 B"001000_00000_00011_0000000000001000", --X"20030008"
 B"001000_00000_00110_0000000000001000", --X"20060008"
 B"101011_00011_00101_0000000000000000", --X"AC650000"
 B"001000_00011_00011_0000000000000100", --X"20630004"
 B"001000_00100_00100_0000000000000001", --X"20840001"
 B"000000_00110_00101_00111_00000_100000", --X"00C53820"
 B"000000_00110_00000_00101_00000_100000", --X"00C02820"
 B"000000_00111_00000_00110_00000_100000", --X"00E03020"
 B"000100_00010_00100_0000000000000001", --X"10440001"
 B"000010_00000000000000000000000110", --X"08000006"
 B"000000_00000_00001_00011_00000_100000", --X"00011820"
 B"000000_00000_00000_00100_00000_100000", --X"00002020"
 B"100011_00011_00101_0000000000000000", --X"8C650000"
 B"001000_00011_00011_0000000000000100", --X"20630004"
 B"001000_00100_00100_0000000000000001", --X"20840001"
 B"000100_00010_00100_0000000000000001", --X"10440001"
 B"000010_00000000000000000000010000", --X"08000010"
others => X"00000000");
signal Q : std_logic_vector(31 downto 0) := X"00000000";
signal Next_Addr : std_logic_vector(31 downto 0) := X"00000000";
signal D : std_logic_vector(31 downto 0) := X"00000000";
signal Br : std_logic_vector(31 downto 0) := X"00000000";
signal TmpPC4 : std_logic_vector(31 downto 0);
begin
process(rst, en, clk)
begin
    if rst = '1' then 
        Q <= X"00000000";
    elsif rising_edge(clk) then
        if en = '1' then
        Q <= Next_Addr;
        end if;
    end if;
end process;
TmpPC4 <= Q + 4;
PC4 <= TmpPC4;
 
process(PCSrc, BranchAddress)
begin
    if PCSrc = '1' then
        Br <= BranchAddress;
    else Br <= TmpPC4;
    end if;
end process;


process(jump, jumpAddress)
begin
    if jump = '1' then Next_Addr <= jumpAddress;
    else Next_Addr <= Br;
    end if;
end process;
 
Instruction <= ROM(conv_integer(Q(6 downto 2)));
 
end Behavioral;