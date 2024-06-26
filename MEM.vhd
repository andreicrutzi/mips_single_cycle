----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2024 07:29:05 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
Port (  
        MemWrite: in std_logic;
        ALUResIN: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        en: in std_logic;
        MemData : out std_logic_vector(31 downto 0);
        ALUResOUT: out std_logic_vector(31 downto 0)
    );
end MEM;

architecture Behavioral of MEM is
type ram_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal MEM : ram_array:= (
    X"00000004",
    X"00000008",
     others => X"00000000");
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if en='1' and MemWrite='1' then
                MEM(conv_integer(ALUResIN(7 downto 2))) <= RD2;
            end if;
        end if;
    end process;
MemData <= MEM(conv_integer(Address));
end Behavioral;
