# Project

Link to repository: https://github.com/221066/Digital-electronics-1.git

## displayer:

```vhdl
library ieee;               
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration 
------------------------------------------------------------------------
entity displayer is
    port(
        clk         : in std_logic;
        value_i     : in std_logic_vector(10 - 1 downto 0);       
        display_o   : out std_logic_vector(4 - 1 downto 0);        
        seg_o       : out std_logic_vector(3 - 1 downto 0)
    );
end entity displayer;

------------------------------------------------------------------------
-- Architecture 
------------------------------------------------------------------------
architecture dataflow of displayer is
    signal dec, cnt, s_d1, s_d2, s_d3 : integer;
    
    begin
        p_clk_gen: process(clk)
        begin
            if rising_edge(clk) then cnt <= cnt + 1;
            end if;
            if cnt>2 then cnt <= 0;
            end if;
        end process p_clk_gen;
   
        p_stimulus: process
        begin
   
            dec <= to_integer(unsigned(value_i));
            s_d1 <= dec/100;
            s_d2 <= (dec/10)-(s_d1*10);
            s_d3 <= dec-(s_d1*100)-(s_d2*10);
        
            case cnt is
                when 0 => display_o <= std_logic_vector(to_unsigned(s_d1, 4)); seg_o <= "001";
                when 1 => display_o <= std_logic_vector(to_unsigned(s_d2, 4)); seg_o <= "010";
                when others => display_o <= std_logic_vector(to_unsigned(s_d3, 4)); seg_o <= "100";
            end case;
            wait for 100 ms;
        end process p_stimulus;
end architecture dataflow;
```

## tb_displayer:

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_displayer is
    -- Entity of testbench is always empty
end entity tb_displayer;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_displayer is

    constant c_CLK_125HZ_PERIOD : time    := 30 ns;
    -- Local signals
    signal s_clk_125Hz : std_logic;
    signal s_value    : std_logic_vector(10 - 1 downto 0);
    signal s_display    : std_logic_vector(4 - 1 downto 0);

begin

    uut_displayer : entity work.displayer
        port map(
            clk => s_clk_125Hz,
            value_i    => s_value,
            display_o    => s_display

        );
        
    p_clk_gen : process
        begin
            while now < 7500 ps loop        
                s_clk_125Hz <= '0';
                wait for c_CLK_125HZ_PERIOD / 2;
                s_clk_125Hz <= '1';
                 wait for c_CLK_125HZ_PERIOD / 2;
            end loop;
            wait;
       end process p_clk_gen;

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        s_value <= "1000100011";             --d 989
        wait for 200 ns;
        s_value <= "0001001111";			 --h 001
        wait for 200 ns;
        s_value <= "0000000111";		   	 --h 032
        wait for 200 ns;
        s_value <= "1111000010";		   	 --h 032
        wait for 200 ns;
        s_value <= "0101011110";		   	 --h 032
        wait for 200 ns;
        wait;                   -- Process is suspended forever
    end process p_stimulus;

end architecture testbench;
```
