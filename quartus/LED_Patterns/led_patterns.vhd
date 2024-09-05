library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity led_patterns is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk					: in	std_ulogic;
		rst					: in	std_ulogic;
		push_button			: in	std_ulogic;
		switches				: in	std_ulogic_vector(3 downto 0);
		hps_led_control	: in 	boolean;
		base_period			: in	unsigned(7 downto 0);
		led_reg				: in	std_ulogic_vector(7 downto 0);
		led					: in	std_ulogic_vector(7 downto 0)
	);
	end entity led_patterns;
	
	architecture led_patterns_arch of led_patterns is
	
	
	begin
	
	
	
	end architecture led_patterns_arch;