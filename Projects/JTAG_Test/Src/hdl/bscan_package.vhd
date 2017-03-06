library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bscan_package is

	component bscan_if
		generic(
			USE_INPUT_REGISTER : Boolean := true;
			USE_EXTERNAL_TCK : Boolean := false;
			INSTANCE_TCK_BUFG : Boolean := false;
			JTAG_CHAIN : Natural := 1;
			DATA_WIDTH : Natural
		);
		port(
			tck_in : in std_logic := 0;
			data_out : in std_logic_vector(DATA_WIDTH-1 downto 0); -- data to send out of JTAG
			data_in : out std_logic_Vector(DATA_WIDTH-1 downto 0);  -- data to receive from JTAG
			tck_out : out std_logic;
			data_in_update : out std_logic;
		   data_out_capture : out std_logic                      -- Signal indicating that data out has been captured  
		);
	end component;

	component bscan_if_sync
		generic(
			JTAG_CHAIN : Natural := 1;
			DATA_WIDTH : Natural					-- Width of the register (must explicitly state)			
		);
		port(
			clk : in std_logic;   				-- synchronous clock
			data_out : in std_logic_vector(DATA_WIDTH-1 downto 0); 	-- data to send out of JTAG
			data_out_valid : in std_logic;
			data_out_ready : out std_logic;
			data_in : out std_logic_Vector(DATA_WIDTH-1 downto 0);  -- data to receive from JTAG
			data_in_update : out std_logic
		);
	end component;


end bscan_package;

package body bscan_package is
end package body;

