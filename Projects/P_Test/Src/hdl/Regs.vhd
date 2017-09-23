----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2017 08:56:24 AM
-- Design Name: 
-- Module Name: Regs - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Regs is
port(
    clk: in std_logic;
    enable: in std_logic;
    we: in std_logic;
    addr_a: in std_logic_vector(4 downto 0);
    addr_b: in std_logic_vector(4 downto 0);
    din: in std_logic_vector(31 downto 0);
    d_a: out std_logic_vector(31 downto 0);
    d_b: out std_logic_vector(31 downto 0)
);
end Regs;

architecture Behavioral of Regs is
    type reg_type is array (0 to 31)
    of std_logic_vector (31 downto 0);
    signal ram: reg_type:= (
    x"40414141",
    x"41414141",
    x"42424141",
    x"43434241",
    x"44444342",
    x"45444342",
    x"46444342",
    others => x"00000000");

begin
process (clk)
begin
    if ( clk'event and clk = '1') then
        if (we = '1' and enable = '1') then
        ram(to_integer(unsigned(addr_b))) <= din;
        end if;
    end if;
end process;
d_a <= ram(to_integer(unsigned(addr_a)));
d_b <= ram(to_integer(unsigned(addr_b)));

end Behavioral;
