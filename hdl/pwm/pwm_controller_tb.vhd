library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_controller_tb is
end entity pwm_controller_tb;

architecture testbench of pwm_controller_tb is

constant CLK_PERIOD : time :=  20 us;
constant W_PERIOD	: integer := 12;
constant F_PERIOD	: integer := 6;
constant W_DUTY_CYCLE	: integer := 10;
constant F_DUTY_CYCLE	: integer := 9;

component pwm_controller is
  generic (
    -- CLK_PERIOD_NS = period in ns (ex: CLK_PERIOD_NS = 1000000 -> CLK_PERIOD = 1 ms)
    CLK_PERIOD_NS 	: integer := 20000; -- in ns
    W_PERIOD		: integer := 12;
    F_PERIOD		: integer := 6;
    W_DUTY_CYCLE	: integer := 10;
    F_DUTY_CYCLE	: integer := 9
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    -- PWM repetition period in milliseconds;
    -- datatype (W.F) is individually assigned
    period : in unsigned(W_PERIOD - 1 downto 0);
    -- PWM duty cycle between [0 1]; out-of-range values are hard-limited
    -- datatype (W.F) is individually assigned
    duty_cycle : in std_logic_vector(W_DUTY_CYCLE - 1 downto 0);
    output : out std_logic
  );
end component pwm_controller;

  signal clk_tb         : std_logic := '0';
  signal rst_tb         : std_logic := '0';
  signal period_tb   	: unsigned(W_PERIOD-1 downto 0) := (others => '0');
  signal duty_cycle_tb	: std_logic_vector(W_DUTY_CYCLE-1 downto 0) := (others => '0');
  signal output_tb 	: std_logic;

begin

  dut : component pwm_controller
    port map (
      clk   => clk_tb,
      rst   => rst_tb,
      period => period_tb,
      duty_cycle  => duty_cycle_tb,
      output => output_tb
    );

  clk_gen : process is
  begin

    clk_tb <= not clk_tb;
    wait for CLK_PERIOD / 2;

  end process clk_gen;

  -- Create period and duty_cycle signals
  p_dc_stim : process is
  begin

    rst_tb	<= '1';
    wait for (50 * CLK_PERIOD)*2;

    rst_tb	<= '0';

    -- period of 1 ms
    period_tb <= "000001000000";
    -- 50% duty cycle
    duty_cycle_tb <= "0100000000";
    wait for (50 * CLK_PERIOD)*100;

    -- period of 1 ms
    period_tb <= "000001000000";
    -- ~100% duty cycle
    duty_cycle_tb <= "0111111111";
    wait for (50 * CLK_PERIOD)*100;

    -- period of 25 ms
    period_tb <= "011001000000";
    -- ~10% duty cycle
    duty_cycle_tb <= "0000110100";
    wait for (50 * CLK_PERIOD)*250;

    -- period of 25 ms
    period_tb <= "011001000000";
    -- 50% duty cycle
    duty_cycle_tb <= "0100000000";
    wait for (50 * CLK_PERIOD)*250;

    -- period of 32 ms
    period_tb <= "100000000000";
    -- ~10% duty cycle
    duty_cycle_tb <= "0000110100";
    wait for (50 * CLK_PERIOD)*250;

    -- period of 32 ms
    period_tb <= "100000000000";
    -- 50% duty cycle
    duty_cycle_tb <= "0100000000";
    wait for (50 * CLK_PERIOD)*250;

    rst_tb <= '1';
    wait;

  end process p_dc_stim;

end architecture testbench;
