----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2017 08:56:24 AM
-- Design Name: 
-- Module Name: Control - Behavioral
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

entity Control is
Port ( UART_busy : in STD_LOGIC;
       Instr : in STD_LOGIC_VECTOR(31 downto 0);
       Reg_a : out STD_LOGIC_VECTOR(4 downto 0);
       Reg_b : out STD_LOGIC_VECTOR(4 downto 0);
         Enable : out STD_LOGIC)
         ;
end Control;

architecture Behavioral of Control is

begin
--Reg_a <= Instr(27 downto 23);
Reg_a <= Instr(4 downto 0);
Reg_b <= Instr(22 downto 18);
enable <= not UART_busy and Instr(31);
end Behavioral;
