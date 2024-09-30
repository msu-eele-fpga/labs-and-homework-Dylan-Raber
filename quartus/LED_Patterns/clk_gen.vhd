library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Common_pkg.all;

entity clk_gen is
  generic (
    system_clock_period : time := 20 ns
  );
  port (
    clk		 	: in std_ulogic;
    bp_timer		: in unsigned(35 downto 0);
    rst			: in std_ulogic;
    clk_out		: out std_ulogic
  );
end entity clk_gen;

architecture clk_gen_arch of clk_gen is

signal clk_out_sig 	: std_ulogic := '0';
signal count		: unsigned(31 downto 0);
	
begin


  clock_generator : process(clk,rst)
    begin
    if (rst = '1') then
	-- count = 32 bits;
      count <= "00000000000000000000000000000000";
    else
      if (rising_edge(clk)) then
      	if (count = bp_timer(31 downto 0)) then
      	  count <= "00000000000000000000000000000000";
	  clk_out_sig <= not clk_out_sig;
      	else 
	  count <= count + 1;
        end if;
      end if;
    end if;
  end process;

  clk_out <= clk_out_sig;

end architecture clk_gen_arch;
