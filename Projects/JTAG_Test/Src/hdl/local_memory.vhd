----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2017 03:00:53 PM
-- Design Name: 
-- Module Name: local_memory - Behavioral
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

entity local_memory is
generic(
    ADDR_WIDTH: integer := 12;
    DATA_WIDTH: integer := 32
);
port(
    clk: in std_logic;
    we: in std_logic;
    addr_in: in std_logic_vector(ADDR_WIDTH-1 downto 0);
    addr_out: in std_logic_vector(ADDR_WIDTH-1 downto 0);
    din: in std_logic_vector(DATA_WIDTH-1 downto 0);
    dout: out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end local_memory;

architecture Behavioral of local_memory is
    type ram_type is array (0 to 2**ADDR_WIDTH-1)
    of std_logic_vector (DATA_WIDTH-1 downto 0);
    signal ram: ram_type:= (
    x"41414141",
    x"42414141",
    x"43424141",
    x"44434241",
    x"45444342",
    others => x"00000000");
    signal addr_reg: std_logic_vector(ADDR_WIDTH-1 downto 0);

begin
process (clk)
begin
    if ( clk'event and clk = '1') then
        if (we = '1') then
        ram(to_integer(unsigned(addr_in))) <= din;
        end if;
    addr_reg <= addr_out;
    end if;
end process;
dout <= ram(to_integer(unsigned(addr_reg)));

end Behavioral;
