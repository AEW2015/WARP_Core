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
           rec_data : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (3 downto 0);
           btn : in STD_LOGIC_VECTOR (3 downto 0);
           send_data : out STD_LOGIC;
           we : out STD_LOGIC;
           data_tx : out STD_LOGIC_VECTOR (7 downto 0);
           data_rx : in STD_LOGIC_VECTOR (7 downto 0);
           addr : out STD_LOGIC_VECTOR (14 downto 0);
           dout : out STD_LOGIC_VECTOR (31 downto 0);
           din : in STD_LOGIC_VECTOR (31 downto 0);
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
    signal uart_flag:std_logic;
    signal uart_data:std_logic_vector(7 downto 0):=(others=>'0');
begin
process(clk,rst_n)
begin
    if(rst_n = '0') then
        counter <= (others=>'0');
        uart_data <= (others=>'0');
        uart_flag <= '0';
    elsif(clk'event and clk = '1') then
        counter <= counter + 1;
        uart_data <= data_rx;
        uart_flag <= rec_data;
    end if;
end process;

led_en <= sw;
led_input <= std_logic_vector(counter(43 downto 12));
rgb_en <= "1111";
send_data <= rec_data or btn(0);
data_tx <= x"64" when btn(0)='1' else uart_data;
we <= btn(0);
dout <= (others => '0');

rgb0_input <= din(23 downto 0);
rgb1_input <= din(23 downto 0);
rgb2_input <= din(23 downto 0);
rgb3_input <= din(23 downto 0);

  

end Behavioral;
