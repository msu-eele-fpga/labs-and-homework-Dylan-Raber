library ieee;
use ieee.std_logic_1164.all;

entity vending_machine is
port (
	clk	: in	std_ulogic;
	rst	: in	std_ulogic;
	nickel	: in	std_ulogic;
	dime	: in	std_ulogic;
	dispense: out	std_ulogic;
	amount	: out	natural range 0 to 15
);
end entity vending_machine;

architecture vending_machine_arch of vending_machine is

type V_STATE is (Cent0, Cent5, Cent10, Cent15);

signal CURRENT_STATE 	: V_STATE;

begin

-- combinational
  state_logic : process(clk,rst)
  begin
    if rst = '1' then
      CURRENT_STATE <= Cent0;
    elsif rising_edge(clk) then
      case CURRENT_STATE is
        when Cent0 =>
          CURRENT_STATE <= Cent5  when (nickel = '1' and dime = '0') else
            		   Cent10 when (dime = '1' and nickel = '0') else
			   Cent10 when (dime = '1' and nickel = '1') else
            		   Cent0;
        when Cent5 =>
          CURRENT_STATE <= Cent10 when (nickel = '1' and dime = '0') else
            		   Cent15 when (dime = '1' and nickel = '0') else
			   Cent15 when (dime = '1' and nickel = '1') else
            		   Cent5;
        when Cent10 =>
          CURRENT_STATE <= Cent15 when (nickel = '1' and dime = '0') else
            		   Cent15 when (dime = '1' and nickel = '0') else
			   Cent15 when (dime = '1' and nickel = '1') else
            		   Cent10;
        when Cent15 =>
          CURRENT_STATE <= Cent0;
        when others =>
          CURRENT_STATE <= Cent0;
      end case;
    end if;
  end process state_logic;

  -- combinational
  output_logic : process(CURRENT_STATE)
  begin
    case CURRENT_STATE is
      when Cent0 =>
        dispense <= '0';
        amount <= 0;
      when Cent5 =>
        dispense <= '0';
        amount <= 5;
      when Cent10 =>
        dispense <= '0';
        amount <= 10;
      when Cent15 =>
        dispense <= '1';
        amount <= 15;
      when others =>
        dispense <= '0';
        amount <= 0;
    end case;
  end process output_logic;

end architecture vending_machine_arch;