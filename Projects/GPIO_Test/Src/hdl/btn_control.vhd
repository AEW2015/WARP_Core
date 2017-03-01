----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2017 08:39:28 AM
-- Design Name: 
-- Module Name: btn_control - Behavioral
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

entity btn_control is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           btn_0 : in STD_LOGIC;
           btn_1 : in STD_LOGIC;
           btn_2 : in STD_LOGIC;
           btn_3 : in STD_LOGIC;
           btn_out : out STD_LOGIC_VECTOR (3 downto 0));
end btn_control;

architecture Behavioral of btn_control is

begin

btn_out <= btn_3 & btn_2 & btn_1 & btn_0;


end Behavioral;
