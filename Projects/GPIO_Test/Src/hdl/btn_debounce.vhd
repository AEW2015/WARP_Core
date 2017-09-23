----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2017 08:39:28 AM
-- Design Name: 
-- Module Name: btn_debounce - Behavioral
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

entity btn_debounce is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           btn_out : out STD_LOGIC);
end btn_debounce;

architecture Behavioral of btn_debounce is
constant counter_Size : integer := 19;
    signal counter_out, counter_out_next : unsigned(counter_size DOWNTO 0) := (OTHERS => '0');
	signal flip_flops : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal counter_set : STD_LOGIC;
begin
	btn_out <= flip_flops(2);
	counter_set <= flip_flops(0) xor flip_flops(1);
	counter_out_next <= (others=>'0') when counter_set  = '1' else
									counter_out + 1 when counter_out(counter_Size) = '0' else
									counter_out;
	
	
	process(rst_n,clk)
	begin
		if (rst_n = '0') then
			flip_flops <= (others=>'0');
			counter_out <= (others => '0');
		elsif rising_edge(clk) then
			counter_out <= counter_out_next;
			flip_flops(0) <= btn_in;
			flip_flops(1) <= flip_flops(0);
			if(counter_out(counter_Size) = '1') then
				flip_flops(2) <= flip_flops(1);
			end if;
		end if;
	end process;


end Behavioral;
