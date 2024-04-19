----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2024 06:52:15 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
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
end EX;

architecture Behavioral of EX is
    signal ALUCtrl: std_logic_vector(2 downto 0);
    signal A: std_logic_vector(31 downto 0);
    signal B: std_logic_vector(31 downto 0);
    signal C: std_logic_vector(31 downto 0);
begin
process (ALUOp, func)
begin
    case ALUOp is
        when "00" =>
            case func is
                when "100000" => ALUCtrl <= "100";
                when others => ALUCtrl <= "100";
            end case;
        when "10" => ALUCtrl <= "100";
        when "11" => ALUCtrl <= "101";
        when others => ALUCtrl <= "100";
    end case;
end process;

process (ALUSrc)
begin
case ALUSrc is
    when '1' => B <= Ext_Imm;
    when others => B <= RD2;
end case;
end process;

process (ALUCtrl)
begin
case ALUCtrl is
    when "100" => C <= A + B;
    when "101" => C <= A - B;
    when others => C <= A + B;
end case;
end process;
end Behavioral;
