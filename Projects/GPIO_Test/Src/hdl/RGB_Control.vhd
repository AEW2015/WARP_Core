----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2017 06:59:59 PM
-- Design Name: 
-- Module Name: RGB_Control - Behavioral
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

entity RGB_Control is
    Port ( CLK : in STD_LOGIC;
           RST_N : in STD_LOGIC;
           rgb_en : in STD_LOGIC;
           rgb_input : in STD_LOGIC_VECTOR (23 downto 0);
           rgb : out STD_LOGIC_VECTOR (2 downto 0));
end RGB_Control;

architecture Behavioral of RGB_Control is

signal rgb_counter, rgb_counter_next : unsigned(19 downto 0) := (others=>'0');
	signal rgb_reg, rgb_reg_next : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal red,green,blue: unsigned(7 downto 0);
begin

rgb <= rgb_reg;

process(rst_n,CLK)
begin
	if(rst_n = '0') then
		rgb_reg <= (others=>'0');
		rgb_counter <= (others=>'0');
	elsif rising_edge(clk) then
		rgb_counter <= rgb_counter_next;
		rgb_reg <=rgb_reg_next;
	end if;
end process;


rgb_counter_next <= rgb_counter+1 ;
red <= unsigned(rgb_input(7 downto 0));
green <= unsigned(rgb_input(15 downto 8));
blue <= unsigned(rgb_input(23 downto 16));





process (rgb_counter,rgb_reg,rgb_en, red, green, blue)
begin
	rgb_reg_next <= rgb_reg;
	if(rgb_counter = 0) then
		rgb_reg_next <= (others=>rgb_en);
	end if;
	if(rgb_counter(19 downto 10) = red) then
		rgb_reg_next(0) <= '0';
	end if;
	if(rgb_counter(19 downto 10) = green) then
		rgb_reg_next(1) <= '0';
	end if;
	if(rgb_counter(19 downto 10) = blue) then
		rgb_reg_next(2) <= '0';
	end if;


	
end process;


end Behavioral;
