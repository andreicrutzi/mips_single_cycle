----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2024 05:03:30 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
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
end UC;

architecture Behavioral of UC is

begin
    process(Instr)
    begin --Br_? <= '0' Jmp <= '0';
    RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0';
    Branch <= '0'; Jump <='0'; MemWrite <= '0';
    MemtoReg <= '0'; RegWrite <= '0'; ALUOp <= "00";
    case Instr is
        when "000000" => --R Type
            RegDst <= '1'; RegWrite <= '1';
            --ALUOp <= "codR";
            ALUOp <= "00";
        when "001000" =>
            ALUSrc <= '1'; RegWrite <= '1';
            ALUOp <= "10";
        when "100011" =>
            ALUSrc <= '1'; MemtoReg <= '1';
            RegWrite <= '1'; ALUOp <= "10";
        when "101011" =>
            MemWrite <= '1'; ALUOp <= "10";
        when "000100" =>
            Branch <= '1'; ALUOp <= "11";
        when "000010" =>
            Jump <= '1';
        when others => ALUOp <= "00";
    end case;
        
    end process;    

end Behavioral;