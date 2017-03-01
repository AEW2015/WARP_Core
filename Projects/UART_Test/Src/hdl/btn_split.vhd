----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2017 08:36:08 AM
-- Design Name: 
-- Module Name: btn_split - Behavioral
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

entity btn_split is
    Port ( btn_in : in STD_LOGIC_VECTOR (3 downto 0);
           btn0 : out STD_LOGIC;
           btn1 : out STD_LOGIC;
           btn2 : out STD_LOGIC;
           btn3 : out STD_LOGIC);
end btn_split;

architecture Behavioral of btn_split is

begin

btn0 <= btn_in(0);
btn1 <= btn_in(1);
btn2 <= btn_in(2);
btn3 <= btn_in(3);



end Behavioral;
