----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2017 06:09:50 PM
-- Design Name: 
-- Module Name: LED_Control - Behavioral
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

entity LED_Control is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           led_en : in STD_LOGIC_VECTOR (3 downto 0);
           led_input : in STD_LOGIC_VECTOR (31 downto 0);
           led : out STD_LOGIC_VECTOR (3 downto 0));
end LED_Control;

architecture Behavioral of LED_Control is
    signal led_counter, led_counter_next : unsigned(7 downto 0) := (others=>'0');
	signal led_reg, led_reg_next : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal led_0, led_1, led_2, led_3: unsigned(7 downto 0);
begin

led <= led_reg;

process(rst_n,CLK)
begin
	if(rst_n = '0') then
		led_reg <= (others=>'0');
		led_counter <= (others=>'0');
	elsif rising_edge(clk) then
		led_counter <= led_counter_next;
		led_reg <=led_reg_next;
	end if;
end process;


led_counter_next <= (others=>'0') when led_counter = 254 else led_counter+1 ;
led_0 <= unsigned(LED_INPUT(7 downto 0));
led_1 <= unsigned(LED_INPUT(15 downto 8));
led_2 <= unsigned(LED_INPUT(23 downto 16));
led_3 <= unsigned(LED_INPUT(31 downto 24));




process (led_counter,led_reg,LED_en, led_0, led_1, led_2, led_3)
begin
	led_reg_next <= led_reg;
	if(led_counter = 0) then
		led_reg_next <= LED_en;
	end if;
	if(led_counter = led_0) then
		led_reg_next(0) <= '0';
	end if;
	if(led_counter = led_1) then
		led_reg_next(1) <= '0';
	end if;
	if(led_counter = led_2) then
		led_reg_next(2) <= '0';
	end if;
	if(led_counter = led_3) then
		led_reg_next(3) <= '0';
	end if;

	
end process;	

end Behavioral;
