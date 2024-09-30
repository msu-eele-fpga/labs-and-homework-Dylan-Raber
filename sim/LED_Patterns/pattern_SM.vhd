library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Common_pkg.all;

entity pattern_SM is
  port (
    clk			: in std_ulogic;
    rst			: in std_ulogic;
    hps_led_control	: in boolean;
    switches		: in std_ulogic_vector(3 downto 0);
    trans_done		: in std_ulogic;
    state		: out led_state
  );
end entity;

architecture pattern_SM_arch of pattern_SM is

signal current_state 	: led_state;

begin

  -- combinational
  state_logic : process(clk,rst)
  begin
    if (hps_led_control) then
      -- controlled by arm hps (not important for lab4)
    else
      -- controlled by state machine 
      if rst = '1' then
	current_state <= State0;
      elsif rising_edge(clk) and trans_done = '1' then
        case current_state is
          when State0 =>
 	    current_state <= State1 when (switches = "0001") else
            		     State2 when (switches = "0010") else
	    		     State3 when (switches = "0011") else
			     State4 when (switches = "0100") else
            		     State0;
          when State1 =>
 	    current_state <= State0 when (switches = "0000") else
            		     State2 when (switches = "0010") else
	    		     State3 when (switches = "0011") else
			     State4 when (switches = "0100") else
            		     State1;
          when State2 =>
 	    current_state <= State1 when (switches = "0001") else
            		     State0 when (switches = "0000") else
	    		     State3 when (switches = "0011") else
			     State4 when (switches = "0100") else
            		     State2;
          when State3 =>
 	    current_state <= State1 when (switches = "0001") else
            		     State2 when (switches = "0010") else
	    		     State0 when (switches = "0000") else
			     State4 when (switches = "0100") else
            		     State3;
          when State4 =>
 	    current_state <= State1 when (switches = "0001") else
            		     State2 when (switches = "0010") else
	    		     State3 when (switches = "0011") else
			     State0 when (switches = "0000") else
            		     State4;
	  when others =>
	    current_state <= State0;
	end case;
      end if;
    end if;
  end process;

state <= current_state;

end architecture pattern_SM_arch;
