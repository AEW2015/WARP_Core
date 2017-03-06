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
		tck_in  : in std_logic;                                -- Input clock for logic (if clock comes from outside)
		rst_n  : in std_logic;                                -- Input clock for logic (if clock comes from outside)
		data_in : out std_logic_Vector(DATA_WIDTH-1 downto 0); -- data to receive from JTAG
		tck_out : out std_logic;                               -- JTAG tck signal used by logic (no matter where it comes from)
		data_in_update : out std_logic;                        -- Signal indicating data in has been updated
		data_out_capture : out std_logic                       -- Signal indicating that data out has been captured  
	);
end bscan_if;

architecture rtl of bscan_if is
	
	constant VERSION : Natural := 1;
	
	signal drck, shift, tdi, tdo, jtag_reset, capture, update, tck_int, tck_bscan : std_logic;
	signal shift_reg : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	--signal data_out_latch, data_out_shift : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	--signal data_in_latch, data_in_shift : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	--signal data_in_latch : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal sel : std_logic;
	type fsm is (IDLE,SEND,DELAY,DATA,D_SEND,PASS);
    signal state,state_next: fsm;
    signal counter,counter_next: unsigned(3 downto 0);
    
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

	-- External TCK 
	use_external_tck_gen : if USE_EXTERNAL_TCK = true generate
		tck_int <= tck_in;
		tck_out <= tck_in;
	end generate;
	
	-- Internal TCK
	use_internal_tck : if USE_EXTERNAL_TCK = false generate
	
		
		no_tck_bufg : if INSTANCE_TCK_BUFG=false generate
			tck_int <= tck_bscan;
		end generate;
		
		tck_bufg : if INSTANCE_TCK_BUFG=true generate
			tck_bufg : BUFG
				port map (
					O => tck_int,
					I => tck_bscan
			);		
		end generate;
		tck_out <= tck_int;
	end generate;
	
	

	--------------------------------------------------
	-- Shift Register. Used for both input and output
	--------------------------------------------------
	
	-- TODO: Three ways to handle the clocking of this register: (need to support with generic)
	--  1. Use the drck as is shown below (optional add bufg)
	--  2. Use the trck and the sel signal  (optional add bufg)
	--  3. Use an input clock (from another BSCAN module)


--we want the shift register to change ever 32 bits, and to end after software set length...
	process(tck_int)
	begin
		if tck_int'event and tck_int='1' then
			data_out_capture <= '0';
			if sel = '1' then
				if capture = '1' then
					-- Latch all of the data into the shift register that should be sent out of the BSCAN.
					-- This is done BEFORE the data is shifted (to get the correct data loaded)
					shift_reg <= data_out;
					data_out_capture <= '1';
				elsif shift = '1' then
					-- Perform a shift of the shift register
					shift_reg <= shift_reg(DATA_WIDTH-2 downto 0) & tdi;
				end if;
			end if;
		end if;
	end process;
	--data_out_capture <= capture;
	tdo <= shift_reg(DATA_WIDTH-1);





--We don't need input
	----------------------------
	-- Input Data
	----------------------------
	input_gen : if USE_INPUT_REGISTER generate


		process(tck_int,update,sel)
		begin
			if tck_int'event and tck_int = '1' then
				--data_in_update <= '0';
			end if;
--------------------------------------------------------------------------------------------
			if update = '1' and sel = '1' then
				--data_in_update <= '1';
				--data_in <= shift_reg;
			end if;
		end process;

	end generate;
	
	no_input_gen : if USE_INPUT_REGISTER = false generate
		--data_in <= (others => '0');
		--data_in_update <= '0';
	end generate;

process (tck_in,rst_n)
begin
    if(rst_n ='0') then
        state <= IDLE;
        counter <= (others=>'0');
    elsif  tck_in'event and tck_in ='1' then
        state<= state_next;
        counter <= counter_next;
    end if;
end process;
	
process (state,update,sel,shift_reg)
begin
    counter_next <= counter;
    state_next <= state;
    data_in_update <= '0';
    data_in <= "0011" & std_logic_vector(counter);
     case state is
        when IDLE =>
            if(update = '1' and sel = '1' and shift_reg = x"E8") then
                state_next <= SEND;
            end if;
        when SEND =>
            data_in_update <= '1';
            state_next <= DELAY;
            counter_next <= counter+1;
       when DELAY =>
             if(update = '0') then
                      state_next <= DATA;
             end if;
        when DATA =>
             if(update = '1' and sel = '1') then
                   state_next <= D_SEND;
               end if;
        when D_SEND =>
          data_in_update <= '1';
          state_next <= PASS;
          data_in <= shift_reg;
        when PASS =>
            if(update = '0' and sel = '0') then
               state_next <= IDLE;
           end if;
       end case;
end process;
	
	
	
end rtl;
