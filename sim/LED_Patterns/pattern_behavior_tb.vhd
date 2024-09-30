library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Common_pkg.all;

entity pattern_behavior_tb is
end entity pattern_behavior_tb;

architecture testbench of pattern_behavior_tb is

  constant CLK_PERIOD : time := 10 ns;

  component pattern_behavior is
    port (
      clk		 : in std_ulogic;
      rst		: in std_ulogic;
      patterns		: in std_ulogic_vector(4 downto 0);
      led		: out std_ulogic_vector(6 downto 0)
    );
  end component pattern_behavior;

  signal clk_tb		: std_ulogic := '0';
  signal rst_tb       	: std_ulogic := '0';
  signal patterns_tb	: std_ulogic_vector(4 downto 0) := "00000";
  signal led_tb 	: std_ulogic_vector(6 downto 0) := "0000000";

  begin

  dut : component pattern_behavior
    port map (
      clk   	=> clk_tb,
      rst 	=> rst_tb,
      patterns	=> patterns_tb,
      led	=> led_tb
    );

  patterns_generator : process is
  begin

    clk_tb <= not clk_tb;
    wait for CLK_PERIOD / 2;

  end process patterns_generator;

  -- Create patterns signal
  patterns_stim : process is
  begin

    rst_tb	<= '1';
    wait for 10 * CLK_PERIOD;

    rst_tb	<= '0';

    patterns_tb <= "00001";
    wait for 50 * CLK_PERIOD;

    patterns_tb <= "00010";
    wait for 50 * CLK_PERIOD;

    patterns_tb <= "00100";
    wait for 100 * CLK_PERIOD;

    patterns_tb <= "01000";
    wait for 100 * CLK_PERIOD;

    patterns_tb <= "10000";
    wait for 200 * CLK_PERIOD;

    patterns_tb <= "00000";
    wait for 100 * CLK_PERIOD;

    wait;

  end process patterns_stim;

end architecture testbench;
