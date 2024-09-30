library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Common_pkg.all;

entity transition_state is
  port (
    clk		 	: in std_ulogic;
    push_button		: in std_ulogic;
    rst			: in std_ulogic;
    start		: in std_ulogic;
    switches		: in std_ulogic_vector(3 downto 0);
    led			: out std_ulogic_vector(6 downto 0);
    trans_done		: out std_ulogic
  );
end entity transition_state;

architecture transition_state_arch of transition_state is

begin

  counter : process(clk,rst)

  signal CNT_int : integer range 0 to 50000000;

  begin

  if rst = '1' then
    trans_done <= '0';
    CNT_int <= 0;
  elsif start = '1' then
    led <= '000' & switches;
    if rising_edge(clk) then
      if CNT_int = 50000000 then
	CNT_int = 0;
	trans_done <= '1';
      else
	CNT_int = CNT_int + 1;
	trans_done <= '0';
      end if;
    end if;
  end if;

  end process;

end architecture transition_state_arch;
