----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2017 10:02:45 AM
-- Design Name: 
-- Module Name: Reciever_Core - Behavioral
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

entity Reciever_Core is
    Generic (
        CLK_RATE: natural :=100_000_000;
        BAUD_RATE: natural :=9_600);
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           rx : in STD_LOGIC;
           rec_data : out STD_LOGIC;
           rx_busy : out STD_LOGIC;
           data_rx : out STD_LOGIC_VECTOR (7 downto 0));
end Reciever_Core;

architecture Behavioral of Reciever_Core is
-----------------------------------------------
function log2c (n: integer) return integer is 
variable m, p: integer; 
begin 
m := 0; 
p := 1; 
while p < n loop 
m := m + 1; 
p := p * 2; 
end loop; 
return m; 
end log2c;
---------------------------------------------------
constant BIT_COUNTER_MAX_VAL : Natural := CLK_RATE/BAUD_RATE/16 - 1;
constant BIT_COUNTER_BITS : Natural := log2c(BIT_COUNTER_MAX_VAL);
type fsm is (POWERUP,IDLE,STRT,DATAREAD,STP);
signal state,state_next: fsm;
signal bit_timer,bit_timer_next : unsigned(BIT_COUNTER_BITS-1 downto 0);
signal data, data_next : std_logic_vector(7 downto 0);
signal stime, stime_next : unsigned(3 downto 0);
signal dtime, dtime_next : unsigned(2 downto 0);
signal pulse: std_logic;


begin

process(rst_n,clk)
begin
	if(rst_n='0') then
		state<=POWERUP;
		data<=(others=>'0');
		stime<=(others=>'0');
		dtime<=(others=>'0');
		bit_timer<=(others=>'0');
	elsif (clk'event and clk ='1') then
		state<=state_next;
		data<=data_next;
		stime<=stime_next;
		dtime<=dtime_next;
		bit_timer<=bit_timer_next;
	end if;
end process;

process(state,pulse,stime,dtime,data,RX)
begin
	rx_busy<='1';
	rec_data<='0';
	stime_next<=stime;
	dtime_next<=dtime;
	data_next<=data;
	case state is 
		when POWERUP=>
			if(RX = '1') then
				state_next<=IDLE;
			else
				state_next<=POWERUP;
			end if;
		when IDLE=>
		rx_busy<='0';
			if(RX = '1') then
				state_next<=IDLE;
			else
				state_next<=STRT;
			end if;
		when STRT=>
			if(pulse = '1') then
				if(stime = "0110") then
					stime_next<=(others=>'0');
					dtime_next<=(others=>'0');
					state_next<=DATAREAD;
				else
					stime_next<=stime+1;
					state_next<=STRT;
				end if;
				else
					state_next<=STRT;
			end if;
		when DATAREAD=>
			if(pulse = '1') then
				if(stime = "1111") then
					stime_next<=(others=>'0');
					data_next<=RX&data(7 downto 1);
					if(dtime="111") then
						dtime_next<=(others=>'0');
						state_next<=STP;
					else
						dtime_next<=dtime+1;
						state_next<=DATAREAD;
					end if;
				else
					stime_next<=stime+1;
					state_next<=DATAREAD;
				end if;
				else
				state_next<=DATAREAD;
			end if; 
		when STP=>
			if(pulse = '1') then
				if(stime = "1111") then
					if(RX='1') then
						stime_next<=(others=>'0');
						rec_data<='1';
						state_next<=IDLE;
					else
						state_next<=STP;
					end if;
				else
					stime_next<=stime+1;
					state_next<=STP;
				end if;
				else
				state_next<=STP;
			end if; 
		--add data strobe
	end case;
end process;
--other logic
bit_timer_next<= (others=>'0') when (bit_timer = BIT_COUNTER_MAX_VAL) else
						bit_timer+1;
pulse <= '1' when bit_timer = BIT_COUNTER_MAX_VAL else
				'0';
--output
Data_RX<= data;		



end Behavioral;
