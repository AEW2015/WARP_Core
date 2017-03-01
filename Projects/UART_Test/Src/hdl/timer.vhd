----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2017 05:39:27 PM
-- Design Name: 
-- Module Name: timer - Behavioral
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

entity timer is
    Port ( clk : in STD_LOGIC;
            rst_n : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (3 downto 0));
end timer;

architecture Behavioral of timer is
    signal counter,counter_next:unsigned(28 downto 0):=(others=>'0');
begin

process(clk,rst_n)
begin
    if(rst_n = '0') then
        counter <= (others=>'0');
    elsif(clk'event and clk = '1') then
        counter <= counter + 1;
    end if;
end process;


led <= sw or std_logic_vector(counter(28 downto 25));





end Behavioral;
