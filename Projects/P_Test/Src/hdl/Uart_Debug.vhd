----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2017 08:56:24 AM
-- Design Name: 
-- Module Name: Uart_Debug - Behavioral
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

entity Uart_Debug is
Port ( clk : in STD_LOGIC;
         rst_n : in STD_LOGIC;
         enable : in STD_LOGIC;
         PC : in STD_LOGIC_VECTOR(31 downto 0);
         Cycle : in STD_LOGIC_VECTOR(31 downto 0);
         Instr : in STD_LOGIC_VECTOR(31 downto 0);
         rega : in STD_LOGIC_VECTOR(31 downto 0);
         UART_Empty : in STD_LOGIC;
         UART_Send : Out STD_LOGIC;
         UART_BUSY : Out STD_LOGIC;
         UART_DATA: out STD_LOGIC_VECTOR(7 downto 0))
         ;
end Uart_Debug;

architecture Behavioral of Uart_Debug is
    type fsm is (IDLE,REG,SEND0,SEND1,SEND2,SEND3,SEND4,SEND5,SEND6,SEND7,SEND8,SEND9,SENDA,
                SENDR1,SENDR2,SENDR3,SENDR4,SENDR5,SENDRD,SENDNL,SENDC,PAUSE);
    signal state,state_next: fsm;
    signal PC_reg,Cycle_reg,Instr_reg,rd_r: STD_LOGIC_VECTOR(31 downto 0);
    signal PC_reg_next,Cycle_reg_next,Instr_reg_next,rd_n: STD_LOGIC_VECTOR(31 downto 0);
    signal rn_r,rn_n : STD_LOGIC_VECTOR(4 downto 0);
    signal decode_input:std_logic_vector(3 downto 0):=(others=>'0');
    signal decode_output:std_logic_vector(7 downto 0):=(others=>'0');
    signal digit_counter, digit_counter_next :unsigned (3 downto 0):=(others=>'0');
begin
process(clk,rst_n)
begin
    if(rst_n = '0') then
        PC_reg <= (others=>'0');
        Cycle_reg <= (others=>'0');
        Instr_reg <= (others=>'0');
        rn_r <= (others=>'0');
        rd_r <= (others=>'0');
        state <= IDLE;
        digit_counter <= (others=>'0');
       
    elsif(clk'event and clk = '1') then
        PC_reg <= PC_reg_next;
        Cycle_reg <= Cycle_reg_next;
        Instr_reg <= Instr_reg_next;
        rn_r <= rn_n;
        rd_r <= rd_n;
        digit_counter <= digit_counter_next ;
        state<= state_next;
    

      
    end if;
end process;

process (state,UART_Empty,decode_output,PC_reg,Cycle_Reg,digit_counter,PC,Cycle,Instr_reg,Instr,Enable,rn_r,rd_r,rega)
begin

    state_next <= state;
    decode_input <= (others =>'0');
    UART_Send <= '0';
    UART_DATA <= (others=>'0');
    PC_reg_next <= PC_reg;
    Cycle_reg_next <= Cycle_reg;
    Instr_reg_next <= Instr_reg;
    rn_n <= rn_r;
    rd_n <= rd_r;
    digit_counter_next <= (others=>'0');
    UART_BUSY <='1';
     case state is
        when IDLE =>
            UART_BUSY <='0';
            if(Enable = '1') then
                state_next <= REG;
                PC_reg_next <= PC;
                Instr_reg_next <= Instr;
                Cycle_reg_next <= Cycle;
                rn_n <= Instr(4 downto 0);
                rd_n <= rega;
            end if;
        when REG =>
             state_next <= SEND0;   
             UART_Send <= '1';
             --decode_input <= std_logic_vector(mem_counter(11 downto 8));
             UART_DATA <= x"43";        
        when SEND0 =>
              state_next <= SEND1;
            UART_Send <= '1';
             --decode_input <= std_logic_vector(mem_counter(11 downto 8));
            UART_DATA <= x"3A";
            digit_counter_next <= to_unsigned(7,4);   
        when SEND1 =>
            UART_Send <= '1';
            decode_input <= Cycle_reg(31 downto 28);
            UART_DATA <= decode_output;
            if(digit_counter = 0) then
            state_next <= SEND2;   
            end if;
            digit_counter_next <= digit_counter-1;
            Cycle_reg_next <= Cycle_reg(27 downto 0) & x"0";  
        when SEND2 =>
            state_next <= SEND3;   
            UART_Send <= '1';
            --decode_input <= std_logic_vector(mem_counter(11 downto 8));
            UART_DATA <= x"20";   
        when SEND3 =>
             state_next <= SEND4;   
            UART_Send <= '1';
             --decode_input <= std_logic_vector(mem_counter(11 downto 8));
             UART_DATA <= x"50"; 
        when SEND4 =>
            state_next <= SEND5;   
            UART_Send <= '1';
            --decode_input <= std_logic_vector(mem_counter(11 downto 8));
            UART_DATA <= x"43"; 
        when SEND5 =>
            state_next <= SEND6;   
            UART_Send <= '1';
            --decode_input <= std_logic_vector(mem_counter(11 downto 8));
            UART_DATA <= x"3A";
            digit_counter_next <= to_unsigned(7,4); 
        when SEND6 =>
            UART_Send <= '1';
            decode_input <= PC_reg(31 downto 28);
            UART_DATA <= decode_output;
            if(digit_counter = 0) then
                state_next <= SEND7;   
            end if;
            digit_counter_next <= digit_counter-1;
            PC_reg_next <= PC_reg(27 downto 0) & x"0";         
        when SEND7 =>
            state_next <= SEND8;   
            UART_Send <= '1';
            --decode_input <= std_logic_vector(mem_counter(11 downto 8));
            UART_DATA <= x"20";   
        when SEND8 =>
             state_next <= SEND9;   
            UART_Send <= '1';
             --decode_input <= std_logic_vector(mem_counter(11 downto 8));
             UART_DATA <= x"49"; 
        when SEND9 =>
            state_next <= SENDA;   
            UART_Send <= '1';
            --decode_input <= std_logic_vector(mem_counter(11 downto 8));
            UART_DATA <= x"3A";
            digit_counter_next <= to_unsigned(7,4); 
        when SENDA =>
            UART_Send <= '1';
            decode_input <= Instr_reg(31 downto 28);
            UART_DATA <= decode_output;
            if(digit_counter = 0) then
                state_next <= SENDR1;   
            end if;
            digit_counter_next <= digit_counter-1;
            Instr_reg_next <= Instr_reg(27 downto 0) & x"0"; 
        when SENDR1 =>
                state_next <= SENDR2;   
                UART_Send <= '1';
                --decode_input <= std_logic_vector(mem_counter(11 downto 8));
                UART_DATA <= x"20";   
        when SENDR2 =>
                 state_next <= SENDR3;   
                UART_Send <= '1';
                 --decode_input <= std_logic_vector(mem_counter(11 downto 8));
                 UART_DATA <= x"52"; 
        when SENDR3 =>
                  state_next <= SENDR4;   
                 UART_Send <= '1';
                  --decode_input <= std_logic_vector(mem_counter(11 downto 8));
                  --UART_DATA <= x"52";  
                  decode_input <= "000"&rn_r(4);
                  UART_DATA <= decode_output;   
         when SENDR4 =>
                   state_next <= SENDR5;   
                  UART_Send <= '1';
                   --decode_input <= std_logic_vector(mem_counter(11 downto 8));
                   --UART_DATA <= x"52";  
                   decode_input <= rn_r(3 downto 0);
                   UART_DATA <= decode_output;   
        when SENDR5 =>
               state_next <= SENDRD;   
               UART_Send <= '1';
               --decode_input <= std_logic_vector(mem_counter(11 downto 8));
               UART_DATA <= x"3A";
               Instr_reg_next <= rega;
               digit_counter_next <= to_unsigned(7,4);           
          when SENDRD =>
           UART_Send <= '1';
           decode_input <= rd_r(31 downto 28);
           UART_DATA <= decode_output;
           if(digit_counter = 0) then
               state_next <= SENDNL;   
           end if;
           digit_counter_next <= digit_counter-1;
           rd_n <= rd_r(27 downto 0) & x"0";   
            
        when SENDNL =>
            state_next <= SENDC;
            UART_Send <= '1';
            --decode_input <= std_logic_vector(mem_counter(11 downto 8));
            UART_DATA <= x"0A"; 
        when SENDC =>
            state_next <= PAUSE;
            UART_Send <= '1';
            --decode_input <= std_logic_vector(mem_counter(11 downto 8));
            UART_DATA <= x"0D";         
        when PAUSE =>
          if(UART_Empty = '1') then
            state_next <= IDLE;
          end if;

    
       end case;
end process;

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
end Behavioral;
