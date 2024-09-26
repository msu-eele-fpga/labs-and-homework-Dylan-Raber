library ieee;
use ieee.std_logic_1164.all;

entity async_conditioner_tb is
end entity async_conditioner_tb;

architecture testbench of async_conditioner_tb is

  constant CLK_PERIOD : time := 20 ns;

  component async_conditioner is
	port (
		clk	: in	std_ulogic;
		rst	: in	std_ulogic;
		async	: in	std_ulogic;
		sync	: out	std_ulogic
	);
  end component async_conditioner;

  signal clk_tb         : std_ulogic := '0';
  signal rst_tb         : std_ulogic := '0';
  signal async_tb       : std_ulogic := '0';
  signal sync_tb	: std_ulogic := '0';
  signal sync_expected 	: std_ulogic;

begin

  dut : component async_conditioner
    port map (
      clk   => clk_tb,
      rst   => rst_tb,
      async => async_tb,
      sync  => sync_tb
    );

  clk_gen : process is
  begin

    clk_tb <= not clk_tb;
    wait for CLK_PERIOD / 2;

  end process clk_gen;

  -- Create the asynchronous signal
  -- note: synchronizer will cause a 1 clock cycle delay between async signal and sync signal,
  --       so any change in async will only trigger on sync after the 2 clock rising edges (so
  --	   long as the debouncer is done debouncing the sync signal already)
  async_stim : process is
  begin

    async_tb <= '0';
    wait for 6.8 * CLK_PERIOD;
    async_tb <= '1';
    wait for 1 * CLK_PERIOD;
    async_tb <= '0';
    -- synchronizer delay makes sync go to 9.8 CC = 196 ns (CC = 20 ns)
    wait for 1 * CLK_PERIOD;
    async_tb <= '1';
    wait for 4.3 * CLK_PERIOD;

    async_tb <= '0';
    wait for 2.6 * CLK_PERIOD;
    async_tb <= '1';
    wait for 1.5 * CLK_PERIOD;
    async_tb <= '0';
    wait for 3.4 * CLK_PERIOD;

    async_tb <= '1';

    wait;

  end process async_stim;

  -- Create the expected synchronized output waveform
  expected_sync : process is
  begin

    sync_expected <= 'U';
    wait for CLK_PERIOD;

    sync_expected <= '0';
    wait for 7 * CLK_PERIOD;
    -- synchronizer delay makes sync go high at 8 CC = 160 ns instead of 7 CC = 140 ns (CC = 20 ns)
    sync_expected <= '1';
    wait for 7 * CLK_PERIOD;
    -- synchronizer delay makes sync go low at 15 CC = 300 ns instead of 14 CC = 280 ns (CC = 20 ns)
    sync_expected <= '0';
    wait for 7 * CLK_PERIOD;
    -- synchronizer delay makes sync go high at 22 CC = 440 ns instead of 21 CC = 420 ns (CC = 20 ns)
    sync_expected <= '1';

    wait;

  end process expected_sync;

  check_output : process is

    variable failed : boolean := false;

  begin

    for i in 0 to 30 loop

      assert sync_expected = sync_tb
        report "Error for clock cycle " & to_string(i) & ":" & LF & "sync = " & to_string(sync_tb) & " sync_expected  = " & to_string(sync_expected)
        severity warning;

      if sync_expected /= sync_tb then
        failed := true;
      end if;

      wait for CLK_PERIOD;

    end loop;

    if failed then
      report "tests failed!"
        severity failure;
    else
      report "all tests passed!";
    end if;

    std.env.finish;

  end process check_output;

end architecture testbench;
