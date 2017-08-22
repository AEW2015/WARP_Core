----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2017 08:56:24 AM
-- Design Name: 
-- Module Name: Regs - Behavioral
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

entity pc_regs is
port(
    clk: in std_logic;
    rst: in std_logic;
    we: in std_logic;
    rs1_addr: in std_logic_vector(4 downto 0);
    rs2_addr: in std_logic_vector(4 downto 0);
    rd_addr: in std_logic_vector(4 downto 0);
    rd_data: in std_logic_vector(31 downto 0);
    rs1_data: out std_logic_vector(31 downto 0);
    rs2_data: out std_logic_vector(31 downto 0)
);
end pc_regs;

architecture Behavioral of pc_regs is
    type reg_type is array (0 to 31)
    of std_logic_vector (31 downto 0);
    signal gpregs: reg_type:= (

    others => x"00000000");

begin
process (rst,clk)
begin
	if (rst = '0') then
		gpregs <= (others=>(others=>'0'));
    elsif ( clk'event and clk = '1') then
        if (we = '1') then
        gpregs(to_integer(unsigned(rd_addr))) <= rd_data;
        end if;
    end if;
end process;
rs1_data <= (others=>'0') when rs1_addr = "00000" else gpregs(to_integer(unsigned(rs1_addr)));
rs2_data <= (others=>'0') when rs2_addr = "00000" else gpregs(to_integer(unsigned(rs2_addr)));


end Behavioral;

