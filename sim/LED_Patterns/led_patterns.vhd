library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Common_pkg.all;

entity led_patterns is
  generic (
    system_clock_period : time := 20 ns
  );
  port (
    clk		 	: in std_ulogic;
    rst			: in std_ulogic;
    push_button		: in std_ulogic;
    switches		: in std_ulogic_vector(3 downto 0);
    hps_led_control	: in boolean;
    base_period		: in unsigned(7 downto 0);
    led_reg		: in std_ulogic_vector(7 downto 0);
    led			: out std_ulogic_vector(7 downto 0)
  );
end entity led_patterns;

architecture led_patterns_arch of led_patterns is

signal current_state 	: led_state;
-- with clk = 20 ns -> 50 MHz
constant CLK_FREQ	: integer := 50000000;
signal bp_timer		: unsigned(35 downto 0);
signal count		: unsigned(31 downto 0);

component async_conditioner is
	port (
		clk	: in	std_ulogic;
		rst	: in	std_ulogic;
		async	: in	std_ulogic;
		sync	: out	std_ulogic
	);
end component async_conditioner;

component pattern_SM is
	port (
		clk		: in	std_ulogic;
		rst		: in	std_ulogic;
		hps_led_control	: in 	boolean;
		switches	: in	std_ulogic_vector(3 downto 0);
		trans_done	: in	std_ulogic;
		state		: out	led_state
	);
end component pattern_SM;

component clk_gen is
  generic (
    system_clock_period : time := 20 ns
  );
  port (
    clk		 	: in std_ulogic;
    bp_timer		: in unsigned(35 downto 0);
    rst			: in std_ulogic;
    clk_out		: out std_ulogic
  );
end component clk_gen;

component pattern_behavior is
  port (
    clk		 	: in std_ulogic;
    rst			: in std_ulogic;
    patterns		: in std_ulogic_vector(4 downto 0);
    led			: out std_ulogic_vector(6 downto 0)
  );
end component pattern_behavior;

signal sync_push_button : std_ulogic;
signal clk_div	: std_ulogic;
signal cstate	: led_state;
signal S0_clk, S1_clk, S2_clk, S3_clk, S4_clk	: std_ulogic;
signal trans_done : std_ulogic := '1';
signal CNT_int : integer range 0 to 50000000;
signal start_trans : std_ulogic;
signal patterns : std_ulogic_vector(4 downto 0);
signal led_from_pb	: std_ulogic_vector(6 downto 0);

begin

  bp_timer <= shift_right((to_unsigned(CLK_FREQ,28) * base_period),4);

  pm_cg : component clk_gen
    port map (
      clk   	=> clk,
      bp_timer	=> bp_timer,
      rst   	=> rst,
      clk_out	=> clk_div
    );

  pm_op : component async_conditioner
    port map (
      clk   => clk,
      rst   => rst,
      async => push_button,
      sync  => sync_push_button
    );

  pm_pSM : component pattern_SM
    port map (
	clk		=> clk,
	rst		=> rst,
	hps_led_control	=> hps_led_control,
	switches	=> switches,
	trans_done	=> trans_done,
	state		=> cstate
    );

  pm_pb : component pattern_behavior
    port map (
      clk   	=> clk_div,
      rst   	=> rst,
      patterns	=> patterns,
      led	=> led_from_pb
    );

  trans_counter : process(clk,rst)

  begin

  if trans_done = '1' and rising_edge(sync_push_button) then
    trans_done <= '0';
  end if;

  if rst = '1' then
    trans_done <= '0';
    CNT_int <= 0;
  elsif trans_done = '0' then
    led(6 downto 0) <= "000" & switches;
    if rising_edge(clk) then
      if CNT_int = 50000000 then
	CNT_int <= 0;
	trans_done <= '1';
      else
	CNT_int <= CNT_int + 1;
      end if;
    end if;
  elsif trans_done = '1' then
    led(6 downto 0) <= led_from_pb;
  end if;

  end process;

  led_output_logic : process(cstate)

  begin

  if trans_done = '1' then
    case cstate is
      when State0 =>
	--led <= "1000000";
	patterns <= "00001";
      when State1 =>
	--led <= "0000011";
	patterns <= "00010";
      when State2 =>
	--led <= "0000000";
	patterns <= "00100";
      when State3 =>
	--led <= "0000000";
	patterns <= "01000";
      when State4 =>
	patterns <= "10000";
     end case;
  else
    patterns <= "00000";
  end if;

  end process;


    
end architecture led_patterns_arch;
