library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

--use work.tmr_package.all;

-----------------------------------------------------------------------------------------------
--
-- Interface for the BSCAN. Provides basic functionality for reading from and writing to
-- a BSCAN port. This module does not handle any clock domain crossing - it is a simple
-- interface that is synchronous with the BSCAN JTAG clock.
--
-----------------------------------------------------------------------------------------------
entity bscan_if is
	generic(
		FAMILY : String := "7SERIES";
		USE_INPUT_REGISTER : Boolean := true;
		USE_EXTERNAL_TCK : Boolean := false;
		INSTANCE_TCK_BUFG : Boolean := false;
		JTAG_CHAIN : Natural := 1;		-- Indicates the JTAG chain number (i.e. 1-4)
		DATA_WIDTH : Natural := 8				-- Width of the register (must explicitly state when instancing)
	);
	port(
		data_out : in std_logic_vector(DATA_WIDTH-1 downto 0); -- data to send out of JTAG
		clk  : in std_logic;                                -- Input clock for logic (if clock comes from outside)
		rst_n  : in std_logic;                                -- Input clock for logic (if clock comes from outside)
		data_in : out std_logic_Vector(DATA_WIDTH-1 downto 0); -- data to receive from JTAG
		addr : out std_logic_Vector(11 downto 0); -- data to receive from JTAG

	

		mem_we : out std_logic;                        -- Signal indicating data in has been updated
		
		data_finished : out std_logic                       -- Signal indicating that data out has been captured  
	);
end bscan_if;

architecture rtl of bscan_if is
component  aFifo is
   generic (
       DATA_WIDTH :integer := 8;
       ADDR_WIDTH :integer := 4
   );
   port (
       -- Reading port.
       Data_out    :out std_logic_vector (DATA_WIDTH-1 downto 0);
       Empty_out   :out std_logic;
       ReadEn_in   :in  std_logic;
       RClk        :in  std_logic;
       -- Writing port.
       Data_in     :in  std_logic_vector (DATA_WIDTH-1 downto 0);
       Full_out    :out std_logic;
       WriteEn_in  :in  std_logic;
       WClk        :in  std_logic;
    
       Clear_in:in  std_logic
   );
end component;

	
	constant VERSION : Natural := 1;
	
	signal drck, shift, tdi, tdo, jtag_reset, capture, update, jtag_clk, tck_bscan : std_logic;
	signal aFifo_we,aFifo_we_next,rst,password,password_next: std_logic;
	signal counter_rst,counter_rst_reg,counter_rst_reg_2: std_logic;
	signal data_done,data_done_reg,data_done_reg_2: std_logic;
	signal afifo_re,empty,afifo_re_reg: std_logic;
	signal shift_reg,shift_next,shift_s1,shift_s2,data_reg,data_next,test: std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal sel,sync1,sync2 : std_logic;
	type fsm is (IDLE,SEND,DELAY,DATA,D_SEND,PASS,DONE);
    signal state,state_next: fsm;
    type fsm_j is (IDLE,SEND,TEST_REG);
    signal jstate,jstate_next: fsm_j;
    signal counter,counter_next: unsigned(3 downto 0);
    signal mem_counter,mem_counter_next,mem_counter_reg: unsigned(11 downto 0);
    signal bitcount,bitcount_next,bitcount_s1,bitcount_s2 : unsigned(4 downto 0) := (others => '0');
    
begin

	gen_7series : if FAMILY = "7SERIES" generate

	-- Instance BSCAN element
	BSCANE2_inst1 : BSCANE2
	 generic map (
		  JTAG_CHAIN => JTAG_CHAIN
	 )
	 port map 
	 (
		  CAPTURE => capture, -- 1-bit output: CAPTURE output from TAP controller.
		  DRCK    => drck,    -- 1-bit output: Gated TCK output. When SEL is asserted, DRCK toggles when CAPTURE or
									 -- SHIFT are asserted.
		  RESET   => jtag_reset,    -- 1-bit output: Reset output for TAP controller.
		  RUNTEST => open,    -- 1-bit output: Output asserted when TAP controller is in Run Test/Idle state.
		  SEL     => sel,    -- 1-bit output: USER instruction active output.
		  SHIFT   => shift,   -- 1-bit output: SHIFT output from TAP controller.
		  TCK     => tck_bscan,     -- 1-bit output: Test Clock output. Fabric connection to TAP Clock pin.
		  TDI     => tdi,     -- 1-bit output: Test Data Input (TDI) output from TAP controller.
		  TMS     => open,    -- 1-bit output: Test Mode Select output. Fabric connection to TAP.
		  UPDATE  => update,    -- 1-bit output: UPDATE output from TAP controller
		  TDO     => tdo      -- 1-bit input: Test Data Output (TDO) input for USER function.
	 );
	end generate;
	
	gen_virtex5 : if FAMILY = "VIRTEX5" generate

	-- Instance BSCAN element
	BSCAN_inst : BSCAN_VIRTEX5
	 generic map (
		  JTAG_CHAIN => JTAG_CHAIN
	 )
	 port map 
	 (
		  CAPTURE => capture, -- 1-bit output: CAPTURE output from TAP controller.
		  DRCK    => tck_bscan,    -- 1-bit output: Gated TCK output. When SEL is asserted, DRCK toggles when CAPTURE or
									 -- SHIFT are asserted.
		  RESET   => jtag_reset,    -- 1-bit output: Reset output for TAP controller.
		  SEL     => sel,    -- 1-bit output: USER instruction active output.
		  SHIFT   => shift,   -- 1-bit output: SHIFT output from TAP controller.
		  TDI     => tdi,     -- 1-bit output: Test Data Input (TDI) output from TAP controller.
		  UPDATE  => update,    -- 1-bit output: UPDATE output from TAP controller
		  TDO     => tdo      -- 1-bit input: Test Data Output (TDO) input for USER function.
	 );
	end generate;

	
	-- Internal TCK
	use_internal_tck : if USE_EXTERNAL_TCK = false generate
	
		
		no_tck_bufg : if INSTANCE_TCK_BUFG=false generate
			jtag_clk <= tck_bscan;
		end generate;
		
		tck_bufg : if INSTANCE_TCK_BUFG=true generate
			tck_bufg : BUFG
				port map (
					O => jtag_clk,
					I => tck_bscan
			);		
		end generate;
		
	end generate;
	
	

	--------------------------------------------------
	-- Shift Register. Used for both input and output
	--------------------------------------------------
	
	-- TODO: Three ways to handle the clocking of this register: (need to support with generic)
	--  1. Use the drck as is shown below (optional add bufg)
	--  2. Use the trck and the sel signal  (optional add bufg)
	--  3. Use an input clock (from another BSCAN module)



	process(jtag_clk)
begin
    if jtag_clk'event and jtag_clk='1' then
        jstate<=jstate_next;
        bitcount<=bitcount_next;
        aFifo_we<=aFifo_we_next;
        shift_reg <= shift_next;
        data_reg <= data_next;
        password <= password_next;
    end if;
end process;
	tdo <= shift_reg(DATA_WIDTH-1);


process (jstate,bitcount,aFifo_we,sel,capture,update,shift_reg,shift,tdi,data_reg,password)
begin
    jstate_next<=jstate;
    bitcount_next<=bitcount;
    aFifo_we_next<='0';
    shift_next <= shift_reg;
    data_next <= data_reg;
    password_next <= password;
    counter_rst <= '0';
    data_done <= '0';
     case jstate is
        when IDLE =>
            if(sel = '1' and capture = '1') then
                shift_next <= x"00000000";
                bitcount_next <= to_unsigned(0,5);
                jstate_next <= send;
                --signal restart counter
                counter_rst <= '1';
                
            end if; 
        when SEND =>
            if(sel = '1' and shift = '1') then
                shift_next <= shift_reg(DATA_WIDTH-2 downto 0) & tdi;
                bitcount_next<=bitcount+1;
                if(bitcount = 0 and password = '1') then -- and shift_reg=x"deadbeef"
                   aFifo_we_next<='1';
                   data_next <= shift_reg; --x"54657374"               
                end if;
                if(bitcount = 0 and shift_reg=x"deadbeef") then -- and shift_reg=x"deadbeef"
                   --aFifo_we_next<='1';
                   --data_next <= x"54657374"; --x"54657374"
                   password_next <= '1';
                end if;
            end if;
        when TEST_REG =>
       end case;
     if(sel = '0') then
         if(password = '1') then 
           aFifo_we_next<='1';
           data_next <= shift_reg;     
           data_done <= '1';         
        end if;
        jstate_next <= IDLE;
        password_next <= '0';
     end if;
end process;


aFifo_inst : aFifo
	 generic map (
		 DATA_WIDTH => 32,
         ADDR_WIDTH => 4
	 )
	 port map 
	 (
		    -- Reading port.
         Data_out    => data_in,
         Empty_out   => empty,
         ReadEn_in   => afifo_re,
         RClk        => clk,
         -- Writing port.
         Data_in     => data_reg,
         Full_out    => open,
         WriteEn_in  => aFifo_we,
         WClk        => jtag_clk,
      
         Clear_in   => rst
	 );


process(clk,rst_n)
begin
    if(rst_n = '0') then
         mem_counter <= (others=>'0');
    elsif(clk'event and clk = '1') then
         mem_counter <= mem_counter_next;
         mem_counter_reg <= mem_counter;
        counter_rst_reg <= counter_rst;
        counter_rst_reg_2 <= counter_rst_reg;
        data_done_reg <= data_done;
        data_done_reg_2 <= data_done_reg;
        afifo_re_reg <= afifo_re;
    end if;
end process;

mem_counter_next <= (others => '0') when counter_rst_reg_2 = '1' else
                    mem_counter+1   when afifo_re = '1'          else
                    mem_counter;
afifo_re <= not empty;

mem_we <= afifo_re_reg;



data_finished <= data_done_reg_2;
rst <= not rst_n;

addr <= std_logic_vector(mem_counter_reg);	

end rtl;
