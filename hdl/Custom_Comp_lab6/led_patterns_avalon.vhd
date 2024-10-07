library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns_avalon is
  port (
    clk : in std_ulogic;
    rst : in std_ulogic;
    -- avalon memory-mapped slave interface
    avs_read 		: in std_logic;
    avs_write 		: in std_logic;
    avs_address 	: in std_logic_vector(1 downto 0);
    avs_readdata 	: out std_logic_vector(31 downto 0);
    avs_writedata : in std_logic_vector(31 downto 0);
    -- external I/O; export to top-level
    push_button 	: in std_ulogic;
    switches 		: in std_ulogic_vector(3 downto 0);
    led 				: out std_ulogic_vector(7 downto 0)
  );
end entity led_patterns_avalon;

architecture led_patterns_avalon_arch of led_patterns_avalon is

component led_patterns is
  generic (
    system_clock_period : time := 20 ns
  );
  port (
    clk		 			: in std_ulogic;
    rst					: in std_ulogic;
    push_button		: in std_ulogic;
    switches			: in std_ulogic_vector(3 downto 0);
    hps_led_control	: in boolean;
    base_period		: in unsigned(7 downto 0);
    led_reg				: in std_ulogic_vector(7 downto 0);
    led					: out std_ulogic_vector(7 downto 0)
  );
end component led_patterns;

signal hps_led_control_sig : boolean := false;
signal hps_led_control_sig_std : std_ulogic;
signal base_period_sig : unsigned(7 downto 0) := "00010000";
signal led_reg_sig : std_ulogic_vector(7 downto 0) := "00000000";

begin

  pm_lp : component led_patterns
  port map (
	clk		=> clk,
	rst		=> rst,
	push_button	=> push_button,
	switches	=> switches,
	hps_led_control	=> hps_led_control_sig,
	base_period	=> base_period_sig,
	led_reg		=> led_reg_sig,
	led		=> led
  );

  hps_std_converter : process(clk)
  begin
    if hps_led_control_sig_std = '1' then 
	   hps_led_control_sig <= true;
	 else
	   hps_led_control_sig <= false;
	 end if;
  end process;
  
  

  avalon_register_read : process(clk)
  begin
    if rising_edge(clk) and avs_read = '1' then
	   case avs_address is
		  when "00"	=> avs_readdata <= ("0000000000000000000000000000000" & hps_led_control_sig_std);
		  when "01"	=> avs_readdata <= ("000000000000000000000000" & std_logic_vector(base_period_sig));
		  when "10" => avs_readdata <= ("000000000000000000000000" & std_logic_vector(led_reg_sig));
		  when others => null;
		end case;
	 end if;
  end process;
  
  avalon_register_write : process(clk)
  begin
    if rst = '1' then
	   hps_led_control_sig_std <= '0';
		base_period_sig <= "00010000";
		led_reg_sig <= "00000000";
	 elsif rising_edge(clk) and avs_write = '1' then
	   case avs_address is
		  when "00" => hps_led_control_sig_std <= avs_writedata(0);
		  when "01" => base_period_sig <= unsigned(avs_writedata(7 downto 0));
		  when "10" => led_reg_sig <= std_ulogic_vector(avs_writedata(7 downto 0));
		  when others => null;
		end case;
    end if;
  end process;


end architecture led_patterns_avalon_arch;