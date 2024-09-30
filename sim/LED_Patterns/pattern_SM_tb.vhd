-- Copyright 2106 Ricardo Jasinski
-- from the book Effective Coding with VHDL by Ricardo Jasinski
-- SPDX-License-Identifier: CC0-1.0
-- CC0 1.0 Universal (CC0 1.0) Public Domain Dedication
--  Summary: https://creativecommons.org/publicdomain/zero/1.0/
--  Full text: https://creativecommons.org/publicdomain/zero/1.0/legalcode
-- Modified by Trevor Vannoy and Dylan Raber; Copyright 2024
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Common_pkg.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity pattern_SM_tb is
end entity pattern_SM_tb;

architecture testbench of pattern_SM_tb is

  signal clk_tb      		: std_ulogic := '0';
  signal rst_tb      		: std_ulogic := '0';
  signal trans_done_tb		: std_ulogic := '1';
  signal hps_led_control_tb	: boolean := false;
  signal switches_tb		: std_ulogic_vector(3 downto 0) := "0000";
  signal state_tb		: led_state;
  signal i			: integer;

  signal switch_data	: std_ulogic_vector(3 downto 0);
  signal testing_done	: boolean;

begin

  duv : entity work.pattern_SM
    port map (
	clk		=> clk_tb,
	rst		=> rst_tb,
	hps_led_control	=> hps_led_control_tb,
	switches	=> switches_tb,
	trans_done	=> trans_done_tb,
	state		=> state_tb
    );

  clk_tb <= not clk_tb after CLK_PERIOD / 2;
  rst_tb <= '1', '0' after 50 ns;

  stimuli_generator : process is

  variable seq : std_logic_vector(3 downto 0);

  begin

    wait until not rst_tb;

    -- Generate all possible 4 bit vectors
    for i in 0 to 15 loop
      seq := std_logic_vector(to_unsigned(i,seq'length));

      switches_tb <= seq;

      wait for 100 ns;

      --wait on testing_done'transaction;
    end loop;

    switches_tb <= "0010";
    wait for 100 ns;
    switches_tb <= "0000";
    wait for 100 ns;
    switches_tb <= "0110";
    wait for 100 ns;
    switches_tb <= "0011";
    wait for 100 ns;
    switches_tb <= "0100";
    wait for 100 ns;
    switches_tb <= "0000";
    wait for 100 ns;
    switches_tb <= "0001";
    wait for 100 ns;
    switches_tb <= "1010";
    wait for 100 ns;
    switches_tb <= "0000";
    wait for 100 ns;

    print("End of testbench.");
    std.env.finish;

  end process stimuli_generator;

end architecture testbench;
