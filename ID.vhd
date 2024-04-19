library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
    
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
    
end ID;

architecture Behavioral of ID is

component REG_FILE is
    port ( 
    clk : in std_logic;
    en: in std_logic;
    
    ra1 : in std_logic_vector(4 downto 0);
    ra2 : in std_logic_vector(4 downto 0);
    
    wa : in std_logic_vector(4 downto 0);
    wd : in std_logic_vector(31 downto 0);
    
    regwr : in std_logic;
    
    rd1 : out std_logic_vector(31 downto 0);
    rd2 : out std_logic_vector(31 downto 0));
end component;

signal mux_o: std_logic_vector(4 downto 0);

begin


process(instr,reg_dst)
begin

    case reg_dst is
        when '0' => mux_o<=instr(20 downto 16);
        when others => mux_o<=instr(15 downto 11);
    end case;

end process;


RF_inst: REG_FILE port map(clk,en,instr(25 downto 21), instr(20 downto 16), mux_o,wd,reg_write,rd1,rd2);


 ext_imm(15 downto 0) <= instr(15 downto 0); 
 ext_imm(31 downto 16) <= (others => instr(15)) when ext_op = '1';

func<= instr(5 downto 0);
sa<= instr(10 downto 6);


end Behavioral;