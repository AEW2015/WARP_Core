----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2017 06:17:14 PM
-- Design Name: 
-- Module Name: Top_Control - Behavioral
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

entity Top_Control is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (3 downto 0);
           btn : in STD_LOGIC_VECTOR (3 downto 0);
           led_en : out STD_LOGIC_VECTOR (3 downto 0);
           rgb_en : out STD_LOGIC_VECTOR (3 downto 0);
           rgb0_input : out std_logic_vector(23 downto 0);
           rgb1_input : out std_logic_vector(23 downto 0);
           rgb2_input : out std_logic_vector(23 downto 0);
           rgb3_input : out std_logic_vector(23 downto 0);
           led_input : out STD_LOGIC_VECTOR (31 downto 0));
end Top_Control;

architecture Behavioral of Top_Control is
    signal counter,counter_next:unsigned(43 downto 0):=(others=>'0');
begin
process(clk,rst_n)
begin
    if(rst_n = '0') then
        counter <= (others=>'0');
    elsif(clk'event and clk = '1') then
        counter <= counter + 1;
    end if;
end process;

led_en <= sw;
led_input <= std_logic_vector(counter(43 downto 12));
rgb_en <= btn;

with counter(29 downto 26) select rgb0_input <=
    x"FFFFFF" when "0000",
    x"FF0000" when "0001",
    x"00FF00" when "0010",
    x"0000FF" when "0011",
    x"CCFFFF" when "0100",
    x"00BFFF" when "0101",
    x"FF1493" when "0110",    
    x"FF00FF" when "0111",    
    x"00FFFF" when "1000",    
    x"FFFF00" when "1001",    
    x"FF6347" when "1010",    
    x"E6E6FA" when "1011",    
    x"FFDAB9" when "1100",    
    x"C0C0C0" when "1101",    
    x"40E0D0" when "1110",    
    x"DEB887" when "1111";   

with counter(26) select rgb1_input <=
    x"FF1493" when '0',
    x"00BFFF" when '1';
  

with counter(26) select rgb2_input <=
    x"E6E6FA" when '0',
    x"40E0D0" when '1';
   

with counter(26) select rgb3_input <=
     x"800080" when '0',
     x"FF7F50" when '1';    

end Behavioral;
