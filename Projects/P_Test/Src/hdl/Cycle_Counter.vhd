----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2017 08:56:24 AM
-- Design Name: 
-- Module Name: Cycle_Counter - Behavioral
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

entity Cycle_Counter is
 Port ( clk : in STD_LOGIC;
          rst_n : in STD_LOGIC;
          Cycle_Count : out STD_LOGIC_VECTOR(31 downto 0))
          ;
end Cycle_Counter;

architecture Behavioral of Cycle_Counter is
signal Cycle_reg: unsigned (31 downto 0);
begin

process(clk,rst_n)
begin
    if(rst_n = '0') then
        Cycle_reg <= (others=>'0');
    elsif(clk'event and clk = '1') then
        Cycle_reg <= Cycle_reg +1;
    end if;
end process;
Cycle_Count <= std_logic_vector(Cycle_reg);
end Behavioral;
