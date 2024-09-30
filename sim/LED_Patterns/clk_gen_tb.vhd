library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Common_pkg.all;

entity clk_gen_tb is
end entity clk_gen_tb;

architecture testbench of clk_gen_tb is

  constant CLK_PERIOD : time := 10 ns;

  component clk_gen is
    generic (
      system_clock_period : time := 20 ns
    );
    port (
      clk		: in std_ulogic;
      bp_timer		: in unsigned(35 downto 0);
      rst		: in std_ulogic;
      clk_out		: out std_ulogic
    );
  end component clk_gen;

  signal clk_tb		: std_ulogic := '0';
  signal bp_timer_tb    : unsigned(35 downto 0) := "000000000000000000000000000000000000";
  signal rst_tb       	: std_ulogic := '0';
  signal clk_out_tb 	: std_ulogic := '0';

begin

  dut : component clk_gen
    port map (
      clk   	=> clk_tb,
      bp_timer	=> bp_timer_tb,
      rst 	=> rst_tb,
      clk_out	=> clk_out_tb
    );

  clk_generator : process is
  begin

    clk_tb <= not clk_tb;
    wait for CLK_PERIOD / 2;

  end process clk_generator;

  -- Create bp_timer signal
  bp_stim : process is
  begin

    rst_tb	<= '1';
    wait for 10 * CLK_PERIOD;

    rst_tb	<= '0';

    bp_timer_tb <= "000000000000000000000000000001000000";
    wait for 500 * CLK_PERIOD;

    bp_timer_tb <= "000000000000000000000000000010000000";
    wait for 5000 * CLK_PERIOD;

    wait;

  end process bp_stim;

end architecture testbench;
