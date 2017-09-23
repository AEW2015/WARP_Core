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
           uart_in_enpty : in STD_LOGIC;
           uart_out_empty : in STD_LOGIC;
           read_uart_in : out STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (3 downto 0);
           bscan_rec : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (3 downto 0);
           send_uart_out : out STD_LOGIC;
           data_tx : out STD_LOGIC_VECTOR (7 downto 0);
           addr_mem : out STD_LOGIC_VECTOR (11 downto 0);
           data_rx : in STD_LOGIC_VECTOR (7 downto 0);
           led_en : out STD_LOGIC_VECTOR (3 downto 0);
           rgb_en : out STD_LOGIC_VECTOR (3 downto 0);
           rgb0_input : out std_logic_vector(23 downto 0);
           rgb1_input : out std_logic_vector(23 downto 0);
           rgb2_input : out std_logic_vector(23 downto 0);
           rgb3_input : out std_logic_vector(23 downto 0);
           JTAG_WRITE_DATA : out STD_LOGIC_VECTOR (31 downto 0);
           MEM_READ_DATA : in STD_LOGIC_VECTOR (31 downto 0);
           led_input : out STD_LOGIC_VECTOR (31 downto 0));
end Top_Control;

architecture Behavioral of Top_Control is
    type reg_type is array (0 to 31)
        of std_logic_vector (31 downto 0);
        signal regs: reg_type:= (
        x"DEAD0000",
        x"DEAD0001",
        x"DEAD0002",
        x"DEAD0003",
        x"DEAD0004",
        others => x"00000000");


    signal counter,counter_next:unsigned(43 downto 0):=(others=>'0');

    signal uart_data:std_logic_vector(7 downto 0):=(others=>'0');
    signal state_data:std_logic_vector(7 downto 0):=(others=>'0');
    signal decode_input:std_logic_vector(3 downto 0):=(others=>'0');
    signal decode_output:std_logic_vector(7 downto 0):=(others=>'0');
    signal mem_data:std_logic_vector(31 downto 0):=(others=>'0');
    signal reg_data,reg_data_next:std_logic_vector(31 downto 0):=(others=>'0');
    signal uart_state_reg,uart_state_next:unsigned(2 downto 0):=(others=>'0');
    signal reg_index: unsigned (4 downto 0);
    signal digit_counter, digit_counter_next :unsigned (3 downto 0):=(others=>'0');
    
    type fsm is (IDLE,REG,SEND0,SEND1,SEND2,SEND3,SEND4,SEND5,SEND6,SEND7,SEND8,SEND_NUMBER,SEND_CHAR);
        signal state,state_next: fsm;
        
    signal mem_counter,mem_counter_next: unsigned(11 downto 0);
    signal send_flag: std_logic;
        
begin
process(clk,rst_n)
begin
    if(rst_n = '0') then
        counter <= (others=>'0');
        reg_data <= (others=>'0');
        digit_counter <= (others=>'0');
        uart_data <= (others=>'0');

        uart_state_reg <= "100" ;

         state <= IDLE;
         mem_counter <= (others=>'0');
    elsif(clk'event and clk = '1') then
        counter <= counter + 1;
        digit_counter <= digit_counter_next ;
        reg_data <= reg_data_next ;
        uart_state_reg <= uart_state_next;

        state<= state_next;

        mem_counter <= mem_counter_next;
        if(uart_state_reg = 2) then
            uart_data <= data_rx;
        end if;        
       if(state = REG) then
           mem_data <= MEM_READ_DATA;  
       end if;
      
    end if;
end process;


reg_index <= unsigned(mem_data(4 downto 0));
led_en <= sw;
led_input <=  std_logic_vector(counter(43 downto 12));
rgb_en <=  btn;
read_uart_in <= '1' when uart_state_reg = 1 else '0';
send_uart_out <= '1' when uart_state_reg = 3 or send_flag = '1' else '0';
data_tx <= state_data when send_flag = '1' else
            uart_data;

uart_state_next <= (others=>'0') when (uart_state_reg >= 4 and ( (not uart_in_enpty) = '1')) else uart_state_reg+1 when uart_state_reg < 4 else uart_state_reg;

JTAG_WRITE_DATA <= x"00000000";

process (state,bscan_rec,mem_counter,uart_out_empty,decode_output,mem_data,btn,reg_data,digit_counter,reg_index)
begin
    decode_input <= (others =>'0');
    send_flag <= '0';
    mem_counter_next <= mem_counter;
    state_data <= (others=>'0');
    state_next <= state;
    digit_counter_next <= (others=>'0');
    reg_data_next <= reg_data;
     case state is
        when IDLE =>
            mem_counter_next <= to_unsigned(0,12);
            if(bscan_rec = '1' or btn(0) = '1') then
                state_next <= REG;
            end if;
        when REG =>
             state_next <= SEND0;   
             send_flag <= '1';
             decode_input <= std_logic_vector(mem_counter(11 downto 8));
             state_data <= decode_output;        
        when SEND0 =>
              state_next <= SEND1;
              reg_data_next <= regs(to_integer(reg_index));   
              send_flag <= '1';
              decode_input <= std_logic_vector(mem_counter(7 downto 4));
              state_data <= decode_output;
        when SEND1 =>
             state_next <= SEND2;   
             send_flag <= '1';
             decode_input <= std_logic_vector(mem_counter(3 downto 0));
             state_data <= decode_output;
        when SEND2 =>
             if(mem_data = x"00000000") then
                state_next <= SEND_CHAR;
                digit_counter_next <= to_unsigned(3,4);
                reg_data_next <= x"456E6423";
             else
                 state_next <= SEND_NUMBER;
                 digit_counter_next <= to_unsigned(7,4);   
             end if;
             send_flag <= '1';
             state_data <= x"3A";   
             mem_counter_next <= mem_counter+1;     
        when SEND_NUMBER =>   
             send_flag <= '1';
             decode_input <= std_logic_vector(reg_data(31 downto 28));
             state_data <= decode_output;
             if(digit_counter = 0) then
                 state_next <= SEND7;   
             end if;
             digit_counter_next <= digit_counter-1;
             reg_data_next <= reg_data(27 downto 0) & x"0";     
        when SEND_CHAR =>
            send_flag <= '1';
            state_data <= reg_data(31 downto 24);
            if(digit_counter = 0) then
            state_next <= SEND7;   
            end if;
            digit_counter_next <= digit_counter-1;
            reg_data_next <= reg_data(23 downto 0) & x"00";     
        when SEND3 =>
             state_next <= SEND4;   
             send_flag <= '1';
             state_data <= reg_data(31 downto 24);
        when SEND4 =>
            state_next <= SEND5;   
            send_flag <= '1';
            state_data <= reg_data(23 downto 16);
        when SEND5 =>
            state_next <= SEND6;   
            send_flag <= '1';
            state_data <= reg_data(15 downto 8);
        when SEND6 =>
            state_next <= SEND7;   
            send_flag <= '1';
            state_data <= reg_data(7 downto 0);
        when SEND7 =>
            state_next <= SEND8;
            send_flag <= '1';
            state_data <= x"0A"; 
        when SEND8 =>
            if(mem_data = x"00000000") then
                state_next <= IDLE;
                send_flag <= '1';
                state_data <= x"0D"; 
            elsif(uart_out_empty = '1') then
                state_next <= REG;
                send_flag <= '1';
                state_data <= x"0D"; 
            end if;
            
           
       end case;
end process;

addr_mem <= std_logic_vector(mem_counter);

with decode_input select decode_output <=
    x"30" when "0000",
    x"31" when "0001",
    x"32" when "0010",
    x"33" when "0011",
    x"34" when "0100",
    x"35" when "0101",
    x"36" when "0110",    
    x"37" when "0111",    
    x"38" when "1000",    
    x"39" when "1001",    
    x"41" when "1010",    
    x"42" when "1011",    
    x"43" when "1100",    
    x"44" when "1101",    
    x"45" when "1110",    
    x"46" when "1111";   

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
