----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2017 09:20:17 PM
-- Design Name: 
-- Module Name: UART_RX - Behavioral
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

entity UART_RX is
 Generic (
   CLK_RATE: natural :=100_000_000;
   BAUD_RATE: natural :=115_200);
Port ( clk : in STD_LOGIC;
      rst_n : in STD_LOGIC;
      rx : in STD_LOGIC;
      read_en : in STD_LOGIC;
      data_out : out STD_LOGIC_VECTOR (7 downto 0);
      empty    : out STD_LOGIC);
end UART_RX;

architecture Behavioral of UART_RX is
component FIFO is
    Generic (
		constant DATA_WIDTH  : positive := 8;
		constant FIFO_DEPTH	: positive := 156);
	Port ( 
		CLK		: in  STD_LOGIC;
		RST_N		: in  STD_LOGIC;
		WriteEn	: in  STD_LOGIC;
		DataIn	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		ReadEn	: in  STD_LOGIC;
		DataOut	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		Empty	: out STD_LOGIC;
		Full	: out STD_LOGIC
	);
end component FIFO;
component Reciever_Core is
      Generic (
        CLK_RATE: natural :=100_000_000;
        BAUD_RATE: natural :=115_200);
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           rx : in STD_LOGIC;
           rec_data : out STD_LOGIC;
           rx_busy : out STD_LOGIC;
           data_rx : out STD_LOGIC_VECTOR (7 downto 0));
end component Reciever_Core;

signal rec_data,full,rx_busy: std_logic;  
signal data_rx: STD_LOGIC_VECTOR(7 downto 0);

begin
FIFO_i: component FIFO
     Generic map(
        DATA_WIDTH  =>8,
        FIFO_DEPTH  =>156)
     port map (
      clk => clk,
      RST_N => RST_N,
      WriteEn => rec_data,
      DataIn => data_rx,
      ReadEn => read_en,
      DataOut => data_out,
      Empty => Empty,
      Full => Full
    );
RX_i: component Reciever_Core
     Generic map(
        CLK_RATE  =>CLK_RATE,
        BAUD_RATE  =>BAUD_RATE)
     port map (
      clk => clk,
      RST_N => RST_N,
      rec_data => rec_data,
      data_rx => data_rx,
      rx => rx,
      rx_busy => rx_busy
    );

end Behavioral;
