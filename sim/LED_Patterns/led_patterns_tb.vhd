library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Common_pkg.all;

entity led_patterns_tb is
end entity led_patterns_tb;

architecture testbench of led_patterns_tb is

  constant CLK_PERIOD : time := 10 ns;

  component led_patterns is
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
  end component led_patterns;

  signal clk_tb			: std_ulogic := '0';
  signal rst_tb       		: std_ulogic := '0';
  signal push_button_tb		: std_ulogic := '0';
  signal switches_tb		: std_ulogic_vector(3 downto 0) := "0000";
  signal hps_led_control_tb	: boolean := false;
  signal base_period_tb		: unsigned(7 downto 0) := "00010000";
  signal led_reg_tb		: std_ulogic_vector(7 downto 0) := "00000000";
  signal led_tb			: std_ulogic_vector(7 downto 0) := "00000000";

begin

  dut_lp : component led_patterns
    port map (
	clk		=> clk_tb,
	rst		=> rst_tb,
	push_button	=> push_button_tb,
	switches	=> switches_tb,
	hps_led_control	=> hps_led_control_tb,
	base_period	=> base_period_tb,
	led_reg		=> led_reg_tb,
	led		=> led_tb
    );

  clk_generator : process is
  begin

    clk_tb <= not clk_tb;
    wait for CLK_PERIOD / 2;

  end process clk_generator;

  -- Create switch and push button signals

  sw_push_stim : process is
  begin

    rst_tb	<= '1';
    wait for 10 * CLK_PERIOD;

    rst_tb	<= '0';
-- tests to make sure state only changes if push button is pressed
    switches_tb <= "0101";
    wait for 20 * CLK_PERIOD;
    switches_tb <= "0001";
    wait for 20 * CLK_PERIOD;
    switches_tb <= "0011";
    wait for 20 * CLK_PERIOD;
-----------------------------------------------------------------

-- tests the push button
    push_button_tb <= '1';
    wait for 200 * CLK_PERIOD;
    push_button_tb <= '0';
    wait for 500 * CLK_PERIOD;
    
    switches_tb <= "0100";
    wait for 50 * CLK_PERIOD;
    push_button_tb <= '1';
    wait for 200 * CLK_PERIOD;
    push_button_tb <= '0';
    wait for 500 * CLK_PERIOD;
    
    rst_tb <= '1';
    wait for 50 * CLK_PERIOD;
    rst_tb <= '0';

    wait;

  end process sw_push_stim;

end architecture testbench;
