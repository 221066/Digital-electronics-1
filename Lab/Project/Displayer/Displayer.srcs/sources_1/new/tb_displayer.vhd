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