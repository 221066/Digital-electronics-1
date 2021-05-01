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

entity displayer is                                             --entity of displayer block (all requier inputs/outputs)
    port(
        clk125hz_i  : in std_logic;
        value_i     : in std_logic_vector(10 - 1 downto 0);       
        display_o   : out std_logic_vector(4 - 1 downto 0);        
        seg_o       : out std_logic_vector(3 - 1 downto 0);
        cnt         : out std_logic_vector(2 - 1 downto 0)      --outputing <cnt> only for visualizing in WF
    );
end entity displayer;

------------------------------------------------------------------------
-- Architecture 
------------------------------------------------------------------------

architecture dataflow of displayer is
    signal dec, s_d1, s_d2, s_d3 : integer;     --define signal for decimal conversion and for individual segments
    signal s_count : integer := 0;              --value of start point for counter  
    
    begin   
        p_stimulus: process(clk125hz_i, s_count)
        begin
        
        if rising_edge(clk125hz_i) then s_count <= s_count + 1;    --counter from 0 to 2 for selecting segments which depends on clock
        end if;
        if s_count = 3 then s_count <= 0;
        end if;
        
        cnt <= std_logic_vector(to_unsigned(s_count, 2));       --write counter value to <cnt> signal
        dec <= to_integer(unsigned(value_i));                   --conversion input value from binary array to integer
        s_d1 <= dec/100;                                        --separation of individual numbers from converted input value
        s_d2 <= (dec/10)-(s_d1*10);
        s_d3 <= dec-(s_d1*100)-(s_d2*10);

        case s_count is                                                                             --case statment for writing individual data to specific segment
            when 0 => display_o <= std_logic_vector(to_unsigned(s_d1, 4)); seg_o <= "001";
            when 1 => display_o <= std_logic_vector(to_unsigned(s_d2, 4)); seg_o <= "010";
            when others => display_o <= std_logic_vector(to_unsigned(s_d3, 4)); seg_o <= "100";
        end case;
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

architecture testbench of tb_displayer is       --define all require signals and constant for clocking

    constant c_CLK_125HZ_PERIOD : time    := 8 ms;
    
    signal s_clk_125Hz  : std_logic;
    signal s_value      : std_logic_vector(10 - 1 downto 0);
    signal s_display    : std_logic_vector(4 - 1 downto 0);
    signal s_cnt        : std_logic_vector(2 - 1 downto 0);
    signal s_seg        : std_logic_vector(3 - 1 downto 0);

begin
    uut_displayer : entity work.displayer       --porting all inputs/outputs
        port map(
            cnt         => s_cnt,
            clk125Hz_i  => s_clk_125Hz,
            value_i     => s_value,
            display_o   => s_display,
            seg_o       => s_seg
        );
        
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    
    p_stimulus : process                     -- process for simulating data for all digit excep 0
    begin
        s_value <= "1000100011";             --in dec 547
        wait for 1 sec;
        s_value <= "0001001111";			 --in dec 79
        wait for 1 sec;
        s_value <= "0000001000";		   	 --in dec 8
        wait for 1 sec;
        s_value <= "1111000010";		   	 --in dec 962
        wait for 1 sec;
        s_value <= "0101011110";		   	 --in dec 350
        wait for 1 sec;
        wait;                   -- Process is suspended forever
    end process p_stimulus;
    
    --------------------------------------------------------------------
    -- Clock generator process for 125kHz for display
    --------------------------------------------------------------------

    clk_gen : process
        begin
            while now < 5 sec loop        
                s_clk_125Hz <= '0';
                wait for c_CLK_125HZ_PERIOD;
                s_clk_125Hz <= '1';
                 wait for c_CLK_125HZ_PERIOD;
            end loop;
            wait;           -- Process is suspended forever
       end process clk_gen;
end architecture testbench;
```
