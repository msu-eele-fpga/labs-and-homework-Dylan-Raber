library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity one_pulse is
	port (
		clk	: in	std_ulogic;
		rst	: in	std_ulogic;
		input	: in	std_ulogic;
		pulse	: out	std_ulogic
	);
end entity one_pulse;

architecture one_pulse_arch of one_pulse is

signal pulse_enable : boolean := false;
signal pulse_sig    : std_ulogic := '0';

begin

	process (clk)
	begin
		if (rst = '1') then
			pulse_sig <= '0';
		else 
			if (pulse_sig = '1' and falling_edge(clk)) then
				pulse_sig <= '0';
			end if;
			if (rising_edge(input)) then
				pulse_sig <= '1';
			end if;
		end if;
	end process;
		
	pulse <= pulse_sig;

end architecture one_pulse_arch;