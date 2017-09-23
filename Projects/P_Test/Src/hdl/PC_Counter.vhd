----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2017 08:56:24 AM
-- Design Name: 
-- Module Name: PC_Counter - Behavioral
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

entity PC_Counter is
Port ( clk : in STD_LOGIC;
         rst_n : in STD_LOGIC;
         enable : in STD_LOGIC;
         PC_in : in STD_LOGIC_VECTOR(31 downto 0);
         PC_out : out STD_LOGIC_VECTOR(31 downto 0))
         ;
end PC_Counter;

architecture Behavioral of PC_Counter is
signal PC_reg: unsigned (31 downto 0);
begin
process(clk,rst_n)
begin
    if(rst_n = '0') then
        PC_reg <= (others=>'0');
    elsif(clk'event and clk = '1') then
        if (enable = '1') then
            PC_reg <= unsigned(PC_in) +1;
        end if;
    end if;
end process;
PC_out <= std_logic_vector(PC_reg);
end Behavioral;
