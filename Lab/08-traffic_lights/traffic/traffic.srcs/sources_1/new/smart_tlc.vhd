library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for traffic light controller
------------------------------------------------------------------------
entity tlc_smart is
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        -- Traffic lights (RGB LEDs) for two directions
        south_o : out std_logic_vector(3 - 1 downto 0);
        west_o  : out std_logic_vector(3 - 1 downto 0)
    );
end entity tlc_smart;

------------------------------------------------------------------------
-- Architecture declaration for traffic light controller
------------------------------------------------------------------------
architecture Behavioral of tlc_smart is

    -- Define the states
    type t_state is (STOP1,
                     WEST_GO,
                     WEST_WAIT,
                     STOP2,
                     SOUTH_GO,
                     SOUTH_WAIT);
    -- Define the signal that uses different states
    signal s_state  : t_state;

    -- Internal clock enable
    signal s_en     : std_logic;
    -- Local delay counter
    signal   s_cnt  : unsigned(5 - 1 downto 0);
    signal   sensors  : unsigned(2 - 1 downto 0);

    -- Specific values for local counter
    constant c_DELAY_4SEC : unsigned(5 - 1 downto 0) := b"1_0000";
    constant c_DELAY_2SEC : unsigned(5 - 1 downto 0) := b"0_1000";
    constant c_DELAY_1SEC : unsigned(5 - 1 downto 0) := b"0_0100";
    constant c_ZERO       : unsigned(5 - 1 downto 0) := b"0_0000";

    -- Output values
    constant c_RED        : std_logic_vector(3 - 1 downto 0) := b"100";
    constant c_YELLOW     : std_logic_vector(3 - 1 downto 0) := b"110";
    constant c_GREEN      : std_logic_vector(3 - 1 downto 0) := b"010";

begin


    s_en <= '1';

    p_smart_traffic_fsm : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then       -- Synchronous reset
                s_state <= STOP1 ;      -- Set initial state
                s_cnt   <= c_ZERO;      -- Clear all bits

            elsif (s_en = '1') then

                case s_state is

                    when STOP1 =>
                        if (s_cnt < c_DELAY_1SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            if (sensors = "10") then
                                s_state <= SOUTH_GO;
                                s_cnt   <= c_ZERO;
                            else
                                s_state <= WEST_GO;
                                s_cnt   <= c_ZERO;
                            end if;
                        end if;

                    when WEST_GO =>
                        
                        if (s_cnt < c_DELAY_4SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            if (sensors = "00" or sensors = "01") then
                                s_state <= WEST_GO;
                                s_cnt   <= c_ZERO;
                            else
                                s_state <= WEST_WAIT;
                                s_cnt   <= c_ZERO;
                            end if;
                        end if;

                    when WEST_WAIT =>
                        
                        if (s_cnt < c_DELAY_2SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            s_state <= STOP2;
                            s_cnt   <= c_ZERO;   
                        end if;
                        
                    when STOP2 =>
                        
                        if (s_cnt < c_DELAY_1SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            if (sensors = "01") then
                                s_state <= WEST_GO;
                                s_cnt   <= c_ZERO;
                            else
                                s_state <= SOUTH_GO;
                                s_cnt   <= c_ZERO;
                            end if;
                        end if;
                        
                    when SOUTH_GO =>
                        
                        if (s_cnt < c_DELAY_4SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            if (sensors = "10" or sensors = "00") then
                                s_state <= SOUTH_GO;
                                s_cnt   <= c_ZERO;
                            else
                                s_state <= SOUTH_WAIT;
                                s_cnt   <= c_ZERO;
                            end if;
                        end if;
                        
                    when SOUTH_WAIT =>
                        
                       if (s_cnt < c_DELAY_2SEC) then
                           s_cnt <= s_cnt + 1;
                       else
                           s_state <= STOP1;
                           s_cnt   <= c_ZERO;
                       end if;

                    when others =>
                        s_state <= STOP1;

                end case;
            end if; -- Synchronous reset
        end if; -- Rising edge
    end process p_smart_traffic_fsm;

    p_output_fsm : process(s_state)
    begin
        case s_state is
            when STOP1 =>
                south_o <= c_RED;
                west_o  <= c_RED;
            when WEST_GO =>
                south_o <= c_RED;
                west_o  <= c_GREEN;
            when WEST_WAIT =>
                south_o <= c_RED;
                west_o  <= c_YELLOW;
            when STOP2 =>
                south_o <= c_RED;
                west_o  <= c_RED;
            when SOUTH_GO =>
                south_o <= c_GREEN;
                west_o  <= c_RED;
            when SOUTH_WAIT =>
                south_o <= c_YELLOW;
                west_o  <= c_RED;
            when others =>
                south_o <= c_RED;
                west_o  <= c_RED;
        end case;
    end process p_output_fsm;

end architecture Behavioral;
