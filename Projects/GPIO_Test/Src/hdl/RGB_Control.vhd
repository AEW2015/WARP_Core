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
           rgb_en : in STD_LOGIC_VECTOR(3 downto 0);
           rgb0_input : in STD_LOGIC_VECTOR (23 downto 0);
           rgb1_input : in STD_LOGIC_VECTOR (23 downto 0);
           rgb2_input : in STD_LOGIC_VECTOR (23 downto 0);
           rgb3_input : in STD_LOGIC_VECTOR (23 downto 0);
           rgb0 : out STD_LOGIC_VECTOR (2 downto 0);
           rgb1 : out STD_LOGIC_VECTOR (2 downto 0);
           rgb2 : out STD_LOGIC_VECTOR (2 downto 0);
           rgb3 : out STD_LOGIC_VECTOR (2 downto 0)
           );
end RGB_Control;

architecture Behavioral of RGB_Control is

signal rgb_counter, rgb_counter_next : unsigned(19 downto 0) := (others=>'0');
	signal rgb0_reg, rgb0_reg_next : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal rgb1_reg, rgb1_reg_next : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal rgb2_reg, rgb2_reg_next : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal rgb3_reg, rgb3_reg_next : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal red0,green0,blue0: unsigned(7 downto 0);
	signal red1,green1,blue1: unsigned(7 downto 0);
	signal red2,green2,blue2: unsigned(7 downto 0);
	signal red3,green3,blue3: unsigned(7 downto 0);
begin

rgb0 <= rgb0_reg;
rgb1 <= rgb1_reg;
rgb2 <= rgb2_reg;
rgb3 <= rgb3_reg;

process(rst_n,CLK)
begin
	if(rst_n = '0') then
		rgb0_reg <= (others=>'0');
		rgb1_reg <= (others=>'0');
		rgb2_reg <= (others=>'0');
		rgb3_reg <= (others=>'0');
		rgb_counter <= (others=>'0');
	elsif rising_edge(clk) then
		rgb_counter <= rgb_counter_next;
		rgb0_reg <=rgb0_reg_next;
		rgb1_reg <=rgb1_reg_next;
		rgb2_reg <=rgb2_reg_next;
		rgb3_reg <=rgb3_reg_next;
	end if;
end process;


rgb_counter_next <= rgb_counter+1 ;
red0 <= unsigned(rgb0_input(7 downto 0));
green0 <= unsigned(rgb0_input(15 downto 8));
blue0 <= unsigned(rgb0_input(23 downto 16));
red1 <= unsigned(rgb1_input(7 downto 0));
green1 <= unsigned(rgb1_input(15 downto 8));
blue1 <= unsigned(rgb1_input(23 downto 16));
red2 <= unsigned(rgb2_input(7 downto 0));
green2 <= unsigned(rgb2_input(15 downto 8));
blue2 <= unsigned(rgb2_input(23 downto 16));
red3 <= unsigned(rgb3_input(7 downto 0));
green3 <= unsigned(rgb3_input(15 downto 8));
blue3 <= unsigned(rgb3_input(23 downto 16));





process (rgb_counter,rgb0_reg,rgb_en, red0, green0, blue0)
begin
	rgb0_reg_next <= rgb0_reg;
	if(rgb_counter = 0) then
		rgb0_reg_next <= (others=>rgb_en(0));
	end if;
	if(rgb_counter(19 downto 9) = red0) then
		rgb0_reg_next(0) <= '0';
	end if;
	if(rgb_counter(19 downto 9) = green0) then
		rgb0_reg_next(1) <= '0';
	end if;
	if(rgb_counter(19 downto 9) = blue0) then
		rgb0_reg_next(2) <= '0';
	end if;
end process;

process (rgb_counter,rgb1_reg,rgb_en, red1, green1, blue1)
begin
	rgb1_reg_next <= rgb1_reg;
	if(rgb_counter = 0) then
		rgb1_reg_next <= (others=>rgb_en(1));
	end if;
	if(rgb_counter(19 downto 9) = red1) then
		rgb1_reg_next(0) <= '0';
	end if;
	if(rgb_counter(19 downto 9) = green1) then
		rgb1_reg_next(1) <= '0';
	end if;
	if(rgb_counter(19 downto 9) = blue1) then
		rgb1_reg_next(2) <= '0';
	end if;
end process;

process (rgb_counter,rgb2_reg,rgb_en, red2, green2, blue2)
begin
	rgb2_reg_next <= rgb2_reg;
	if(rgb_counter = 0) then
		rgb2_reg_next <= (others=>rgb_en(2));
	end if;
	if(rgb_counter(19 downto 9) = red2) then
		rgb2_reg_next(0) <= '0';
	end if;
	if(rgb_counter(19 downto 9) = green2) then
		rgb2_reg_next(1) <= '0';
	end if;
	if(rgb_counter(19 downto 9) = blue2) then
		rgb2_reg_next(2) <= '0';
	end if;
end process;

process (rgb_counter,rgb3_reg,rgb_en, red3, green3, blue3)
begin
	rgb3_reg_next <= rgb3_reg;
	if(rgb_counter = 0) then
		rgb3_reg_next <= (others=>rgb_en(3));
	end if;
	if(rgb_counter(19 downto 9) = red3) then
		rgb3_reg_next(0) <= '0';
	end if;
	if(rgb_counter(19 downto 9) = green3) then
		rgb3_reg_next(1) <= '0';
	end if;
	if(rgb_counter(19 downto 9) = blue3) then
		rgb3_reg_next(2) <= '0';
	end if;
end process;


end Behavioral;
