# Cyklo tachometr (cyclo tachometer)

## Team members
Rajm Jan, 
Podaný Matěj, 
Rohaľ Pavol, 
Pelka Jan

[Project folder](https://github.com/Matej-Podany/Digital-electronics-1/tree/main/Labs/project)

## Project objectives
Naším cílem je vytvořit funkční cyklo tachometr. Na základě zadání jsme se rozhodli, že náš tachometr bude mít tři sedmi segmentové displeje, na kterých bude moci zobrazit aktuální rychlost, průměrnou rychlost a ujetou vzdálenost.
Důležitou informací pro uživatele je, že je tachometr určen pro kola s poloměrem 31,83 cm, což odpovídá obvodu kola 2 m. Také jsme si zvolili, že veškerá čísla zobrazená na displejích jsou v praktických jednotkách,
tj. aktuální rychlost v km/h, průměrná rychlost v km/h a ujetá vzdálenost v km. Limity funkčnosti tachometru jsou tedy nastaveny na jakékoli hodnoty, které jsou <= 999. Tachometr má dvě tlačítka, první přepíná mezi zobrazovanou informací,
přičemž první z nich je aktuální rychlost, pak průměrná rychlost a jako poslední je zde ujetá vzdálenost. Opětovným stisknutím dojde tedy k přepnutí zpět na aktuální rychlost. Druhé tlačítko funguje jako reset a při jeho stisku dojde
k vynulování uražené vzdálenosti a průměrné rychlosti.

## Hardware description
Pri návrhu schématu ako aj plošného zapojenia sme museli zohľadniť viacero 
faktorov ako sú maximálne pracové napätia jednotlivých výstupov resp. vstupov. 
Pre praktickosť zapojenia a redukovanie použitých výstupov sme sa rozhodli 
použiť 4-bitový BCD dekóder pre jednotlivé 7-segmentové displaye zapojené 
paralelne. Dekóder je z rady 74HC4543 ktorý dokáže pracovať s napäťovou 
logikou 3,3V. Samotné 7-segmentové displaye su z výrobnej rady HD101, ktoré sa 
spínaju jednotlivo tranzistormi T1 až T3 pre každý display zvlášť. Ako predradné 
rezistory pre jednotivé segmenty displaya sme zvolili jeden integrovaný rezistor 
(zapuzdrená rezistorová rada) s hodnotou odporu 100R. Pri zostavovaní schématu
sme zohľadnili cenu a dostupnosť použitých súčiastok. V návrhu plošného zapojenia
sme u niektorých súčiastok použili variantu SMD aby sme tak zredukovali samotnú 
veľkosť dosky. Ako pripojovací konektor sme zvolili štandardizovaný angle type
2,54mm ktorý korešponduje s konektorom na doske A7-35. Konektor je umiestnení z
boku tak aby bola zjednodušená čitaťeľnosť displaya pri prípadnej praktickej 
realizácii. Spotreba pri plne rozsvietených dislayoch nepresahuje povolený limit 
1A. Ako posledným štylistickým krokom sme v doske obsiahli poligón ktorý 
redukuje chybovosť a straty na medenej vrstve. Výsledná doska má tak rozmery 50x40mm.

## VHDL modules description and simulations

### Schematic diagram
![OPTION schematic](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/OPTION/images/schematic.jpg "OPTION schematic")

### OPTION
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rajm Jan
-- 
-- Design Name: OPTION
-- Module Name: OPTION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity option is
  Port ( 
    btn_i    : in std_logic;                        -- input from button
    choose_o : out std_logic_vector(2 - 1 downto 0) -- output determinating which value will appear on display
  );
end option;

architecture Behavioral of option is
    -- definiton of states avaiable to be displayed
    type   state is (VELOCITY, AVG_VELOCITY,  DISTANCE);
                       
    signal s_state  : state;
    
begin
    p_choose_state : process(btn_i, s_state)
    begin
        case s_state is
            when VELOCITY =>
                if rising_edge(btn_i) then -- state is changed by every rising edge of button signal
                    s_state <= AVG_VELOCITY;
                end if;
            when AVG_VELOCITY =>
                if rising_edge(btn_i) then
                    s_state <= DISTANCE;
                end if;
            when DISTANCE =>
                if rising_edge(btn_i) then
                    s_state <= VELOCITY;
                end if;
            when others =>
                if rising_edge(btn_i) then
                    s_state <= VELOCITY;
                end if;
         end case;
    end process p_choose_state;
    
    p_output : process (s_state)
    begin
        
        case s_state is
            when VELOCITY =>
                choose_o <= "00"; -- this vector determinates which option will be displayed
            when AVG_VELOCITY =>
                choose_o  <= "01";   
            when DISTANCE =>
                choose_o  <= "10";   
            when others =>
                choose_o <= "00";
        end case;
    end process p_output;
    
end Behavioral;
```

### tb_OPTION
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rajm Jan
-- 
-- Design Name: OPTION
-- Module Name: OPTION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_option is
    -- Entity of testbench is always empty
end entity tb_option;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_option is

    --Local signals
   
    signal s_btn_i        :  std_logic;
    signal s_choose_o     :  std_logic_vector(2-1 downto 0);
    --signal s_state        :  std_logic;
    signal s_state        :  std_logic; 

begin
    uut_option: entity work.option
        port map (
           
            btn_i     => s_btn_i,
            choose_o  => s_choose_o
            --state   => s_state
        );
   
    --------------------------------------------------------------------
    -- Data generation process - simulation button presses
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
            s_btn_i <= '0';
            wait for 200 ns;
            s_btn_i <= '1';
            wait for 20 ns;
            s_btn_i <= '0';
            wait for 50 ns;
            s_btn_i <= '1';
            wait for 10 ns;
            s_btn_i <= '0';
            wait for 350 ns;
            s_btn_i <= '1';
            wait for 10 ns;
            s_btn_i <= '0';
            wait for 150 ns;
            s_btn_i <= '1';
            wait for 10 ns;
            s_btn_i <= '0';
            wait for 20 ns;
            s_btn_i <= '1';
            wait for 20 ns;
            s_btn_i <= '0';
            wait;
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
end architecture testbench;
```

### simulation OPTION
![OPTION simulation](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/OPTION/images/simulation1.jpg "OPTION simulation")

### Schematic diagram
![CLOCK schematic](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/CLOCK/images/schematic.jpg "CLOCK schematic")

### CLOCK
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Matěj Podaný, Rajm Jan
-- 
-- Design Name: CLOCK
-- Module Name: CLOCK
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock is
    generic(
            num_cycles : natural := 1 -- Number of generated cycles
    );
    Port ( clk1hz_o   : out STD_LOGIC; -- Output signal
           clk125hz_o : out STD_LOGIC -- Output signal
    );
    signal clk1hz   : std_logic; -- Output signal
    signal clk125hz : std_logic;-- Output signal
end clock;

architecture Behavioral of clock is

begin
    p_clk1hz : process
    begin
        for i in 1 to num_cycles loop -- Loop generating 1 hz pulse
            clk1hz_o <= '1';          
            wait for 500 ms;
            clk1hz_o <= '0';
            wait for 500 ms;          
        end loop;
    end process p_clk1hz;

    p_clk125hz : process
    begin
        for i in 1 to num_cycles loop -- Loop generating 125 hz pulse
            clk125hz_o <= '1';          
            wait for 4 ms;
            clk125hz_o <= '0';
            wait for 4 ms;          
        end loop;
    end process p_clk125hz;
end Behavioral;
```

### tb_CLOCK
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Matěj Podaný, Rajm Jan
-- 
-- Design Name: CLOCK
-- Module Name: CLOCK
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clock is
--  Port ( );
end tb_clock;

architecture Behavioral of tb_clock is
    signal s_clk1hz : std_logic;
    signal s_clk125hz : std_logic;
begin
    uut_clock : entity work.clock
        port map(
            clk1hz_o   => s_clk1hz,
            clk125hz_o => s_clk125hz
                );
end Behavioral;
```

### simulation CLOCK
![CLOCK simulation 1](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/CLOCK/images/simulation1.jpg "CLOCK simulation 1")
![CLOCK simulation 2](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/CLOCK/images/simulation2.jpg "CLOCK simulation 2")

### Schematic diagram
![COMPUTATION schematic](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/images/schematic.jpg "COMPUTATION schematic")

### COMPUTATION
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rajm Jan, Mat?j Podaný
-- 
-- Design Name: COMPUTATION
-- Module Name: COMPUTATION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity computation is
  Port ( 
    status_i   : in std_logic_vector(2-1 downto 0);
    reset_i    : in std_logic;
    clk1hz_i   : in std_logic;
    sensor_i   : in std_logic;
    s1_value   : out std_logic_vector(10-1 downto 0)
  );
end computation;

architecture Behavioral of computation is
    signal s_avg_velocity : std_logic_vector(10-1 downto 0);
    signal s_velocity     : std_logic_vector(10-1 downto 0);
    signal s_distance     : std_logic_vector(10-1 downto 0);
    signal s_value        : std_logic_vector(10-1 downto 0);
begin
p_velocity : entity work.velocity
        port map(
        -- submodule => top module
            clk1hz_i   => clk1hz_i,
            sensor_i   => sensor_i,
            velocity_o => s_velocity
        );

p_avg_velocity : entity work.avg_velocity 
        port map(
            clk1hz_i       => clk1hz_i,
            areset_i        => reset_i,
            vel2avg_i      => s_velocity,
            avg_velocity_o => s_avg_velocity
        );
        
p_distance : entity work.distance 
        port map(
            sensor_i   => sensor_i,
            areset_i    => reset_i,
            distance_o => s_distance
        );
        
p_output : entity work.output 
        port map(
            clk1hz_i       => clk1hz_i,
            status_i       => status_i,
            distance_i     => s_distance,
            avg_velocity_i => s_avg_velocity,
            velocity_i     => s_velocity,
            value_o        => s_value
        );
 p_finaloutput : process(clk1hz_i)
        begin
            if rising_edge(clk1hz_i) then
                s1_value <= s_value;
            end if;
        end process p_finaloutput;
end Behavioral;
```

### tb_COMPUTATION
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rajm Jan
-- 
-- Design Name: COMPUTATION
-- Module Name: COMPUTATION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_computation is
--  Port ( );
end tb_computation;

architecture Behavioral of tb_computation is
    signal s_status : std_logic_vector(2-1 downto 0);
    signal s_reset  : std_logic;
    signal s_clk    : std_logic;
    signal s_sensor : std_logic;
    
begin
uut_computation: entity work.computation
        port map (
            status_i => s_status,
            reset_i  => s_reset,
            clk1hz_i => s_clk,
            sensor_i => s_sensor
            
        );

p_reset_gen : process
    begin
        s_reset <= '0';
        wait for 7128 ms; -- reset during avarage velocity
        s_reset <= '1';
        wait for 53 ms;
        s_reset <= '0';
        wait for 4128 ms; -- reset during distance
        s_reset <= '1';
        wait for 53 ms;
        s_reset <= '0';
        wait;
    end process p_reset_gen;
    
p_status : process
    begin
        s_status <= "00"; -- velocity
        wait for 4000 ms;
        s_status <= "01"; -- avg. velocity
        wait for 4000 ms;
        s_status <= "10";
        wait for 4000 ms; -- distance
        s_status <= "11"; -- intentionaly unexpected value, should display velocity
        wait for 4000 ms;
        wait;
    end process p_status;
    
p_clk1hz : process
    begin
        while now < 16000 ms loop         
            s_clk <= '1';
            wait for 500 ms;
            s_clk <= '0';
            wait for 500 ms;
        end loop;
        wait;
    end process p_clk1hz;
    
p_sensor : process
    begin
    -----------------------------
    -- many signal assignments --
    -----------------------------
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        
        -- slower 300 ms
        
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        
        --
        
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        
        -- 
        
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        
        --
        
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        s_sensor <= '0';
        wait for 10 ms;
        s_sensor <= '1';
        wait for 10 ms;
        
        -- slower 300 ms
        
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        
        --
        
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        s_sensor <= '0';
        wait for 150 ms;
        s_sensor <= '1';
        wait for 150 ms;
        
        -- 
        
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        s_sensor <= '0';
        wait for 50 ms;
        s_sensor <= '1';
        wait for 50 ms;
        
        wait;
end process p_sensor;

end Behavioral;
```

### simulation COMPUTATION
![COMPUTATION simulation 1](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/images/simulation1.jpg "COMPUTATION simulation 1")
![COMPUTATION simulation 2](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/images/simulation2.jpg "COMPUTATION simulation 2")

### Schematic diagram
![DISPLAYER schematic](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/DISPLAYER/images/schematic.jpg "DISPLAYER schematic")

### DISPLAYER
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rohal´ Pavol, Mat?j Podaný
-- 
-- Design Name: DISPLAYER
-- Module Name: DISPLAYER
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library ieee;               
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration 
------------------------------------------------------------------------

entity displayer is                                             --entity of displayer block (all requier inputs/outputs)
    port(
        clk125hz_i  : in std_logic;
        value_i     : in std_logic_vector(10 - 1 downto 0) := "0000000000";       
        display_o   : out std_logic_vector(3 - 1 downto 0);        
        seg_o       : out std_logic_vector(4 - 1 downto 0);
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
            when 0 => seg_o <= std_logic_vector(to_unsigned(s_d1, 4)); display_o <= "001";
            when 1 => seg_o <= std_logic_vector(to_unsigned(s_d2, 4)); display_o <= "010";
            when others => seg_o <= std_logic_vector(to_unsigned(s_d3, 4)); display_o <= "100";
        end case;
    end process p_stimulus;
end architecture dataflow;
```

### tb_DISPLAYER
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rohal´ Pavol
-- 
-- Design Name: DISPLAYER
-- Module Name: DISPLAYER
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

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
    signal s_display    : std_logic_vector(3 - 1 downto 0);
    signal s_cnt        : std_logic_vector(2 - 1 downto 0);
    signal s_seg        : std_logic_vector(4 - 1 downto 0);

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

### simulation DISPLAYER
![DISPLAYER simulation 1](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/DISPLAYER/images/simulation1.jpg "DISPLAYER simulation 1")
![DISPLAYER simulation 2](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/DISPLAYER/images/simulation2.jpg "DISPLAYER simulation 2")
![DISPLAYER simulation 3](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/DISPLAYER/images/simulation3.jpg "DISPLAYER simulation 3")

### External module
DISPLAYER dává přímo informaci display_o pro externí navrženou desku se třemi sedmi segmentovými displeji. Je navržený i pro funkci desetinné tečky, této funkce však nevyužijeme. Zde máme jeho navržené schéma:
![External module](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/DISPLAYER/images/externalmodule.png "External module")


Externí modul si sám převede číselnou informaci ve 4 bitové binární podobě na 7 bitovou infomaci pro sedmi segmentový displej, přičemž jeden bit je pro jeden segment displeje.
Je navržen pro konektor angle type 2,5 mm standard. Jeho nákres na desce plošných spojů:
![Printed circuit board](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/DISPLAYER/images/printedcircuitboard.png "Printed circuit board")

Zde pak následuje tabulka propojení portů desky Arty A7-35 s navrženou deskou:
| **Arty A7-35 pin names** | **Printed circuit board pin names** |
| :-: | :-: |
| G13 | SV2+ 11 |
| B11 | SV2+ 9 |
| A11 | SV2+ 7 |
| D12 | SV2+ 5 |
| D13 | SV2+ 10 |
| B18 | SV2+ 8 |
| A18 | SV2+ 6 |

### p_VELOCITY
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Pelka Jan, Matěj Podaný
-- 
-- Design Name: p_VELOCITY
-- Module Name: COMPUTATION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library ieee;
use IEEE.math_real.all;                 -- Needed for power
use ieee.std_logic_1164.all;            -- Basic library
use ieee.numeric_std.all;               -- Needed for shifts

entity velocity is
    Port (
        clk1hz_i           : in std_logic;
        velocity_o         : out STD_logic_vector(10-1 downto 0)  := "0000000000";
        sensor_i           : in std_logic
    );
end velocity;
 
architecture behave of velocity is

begin
 
p_velocity : process(clk1hz_i)

  variable counter          : integer    := 0; 
  variable var1             : integer    := 0; 
  variable var2             : STD_logic_vector(10-1 downto 0);
                                                
    begin
    
    if rising_edge(sensor_i) then
        counter := counter + 1; 					-- if sensor detect magnet couter count it


    end if;

    if rising_edge(clk1hz_i) then 
        var1 := (counter*36)/5; 					-- calculating speed
        var2 := std_logic_vector(to_unsigned(var1, var2'length)); 	-- geting right data type
        velocity_o <= var2; 						-- instert data to output variable
        counter := 0; 							-- reseting counter
    end if;
  end process p_velocity;
end architecture behave;
```

### tb_p_VELOCITY
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Pelka Jan, Matěj Podaný
-- 
-- Design Name: p_VELOCITY
-- Module Name: COMPUTATION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tb_distance is
end entity tb_distance;

architecture testbench of tb_distance is

    signal s_sensor     :  std_logic;
    signal s_clk1hz     :  std_logic;
    signal s_velocity   :  std_logic_vector(10-1 downto 0);
    
    
begin
    uut_velocity: entity work.velocity
        port map (
            
        clk1hz_i => s_clk1hz,  
        velocity_o => s_velocity,
        sensor_i => s_sensor
        );
        
    gen_clock : process
    begin
        s_clk1hz <= '1';
        wait for 500ms;
        s_clk1hz <= '0';
        wait for 500ms;
        s_clk1hz <= '1';
        wait for 500ms;
        s_clk1hz <= '0';
        wait for 500ms;
        s_clk1hz <= '1';
        wait for 500ms;
        s_clk1hz <= '0';
        wait for 500ms;
        s_clk1hz <= '1';
        wait for 500ms;
        s_clk1hz <= '0';
        wait for 500ms;
        wait;
    end process gen_clock;

    p_stimulus : process
    begin
        s_sensor <= '1';
        wait for 500ms;
        s_sensor <= '0';
        wait for 500ms;
        
        s_sensor <= '1';
        wait for 250ms;
        s_sensor <= '0';
        wait for 250ms;
        s_sensor <= '1';
        wait for 250ms;
        s_sensor <= '0';
        wait for 250ms;
        s_sensor <= '1';
        wait for 250ms;
        s_sensor <= '0';
        wait for 250ms;
        s_sensor <= '1';
        wait for 250ms;
        s_sensor <= '0';
        wait for 250ms;

        s_sensor <= '1';
        wait for 100ms;
        s_sensor <= '0';
        wait for 100ms;
        s_sensor <= '1';
        wait for 100ms;
        s_sensor <= '0';
        wait for 100ms;
        s_sensor <= '1';
        wait for 100ms;
        s_sensor <= '0';
        wait for 100ms;
        s_sensor <= '1';
        wait for 100ms;
        s_sensor <= '0';
        wait for 100ms;
        s_sensor <= '1';
        wait for 100ms;
        s_sensor <= '0';
        wait for 100ms;
        
        wait;
    end process p_stimulus;
end architecture testbench;
```

### simulation p_VELOCITY
![p_VELOCITY simulation 1](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/p_VELOCITY/images/simulation1.jpg "p_VELOCITY simulation 1")
![p_VELOCITY simulation 2](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/p_VELOCITY/images/simulation2.jpg "p_VELOCITY simulation 2")

### p_AVG_VELOCITY
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rajm Jan, Matěj Podaný
-- 
-- Design Name: p_AVG_VELOCITY
-- Module Name: COMPUTATION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library ieee;
use IEEE.math_real.all;                 -- Needed for power
use ieee.std_logic_1164.all;            -- Basic library
use ieee.numeric_std.all;               -- Needed for shifts

entity avg_velocity is
    Port (
        clk1hz_i        : in std_logic;
        areset_i        : in std_logic;
        vel2avg_i       : in std_logic_vector(10-1 downto 0);
        avg_velocity_o  : out std_logic_vector(10-1 downto 0)  := "0000000000"  
    );
end avg_velocity;
 
architecture behave of avg_velocity is

  signal sum_of_velocities     : unsigned(10-1 downto 0) := "0000000000";
  
begin
 
p_avg_velocity : process(clk1hz_i, areset_i)

  variable count_of_shifts     : integer    := 1;
  variable clk_cycles          : integer    := 2; -- states for how many clock cycles does signal sum_of_velocities adds samples of 
                                                  --   velocity and for how long does process wait for division
    begin
    
    if areset_i = '1' then
        avg_velocity_o      <= "0000000000"; -- zeroing value of avarage velocity
        sum_of_velocities   <= "0000000000"; -- zeroing of sum of velocities
        count_of_shifts := 1;
        clk_cycles      := 2; -- shift of one bit correspondents with waiting for two samples os velocity to be summed
    else
        if rising_edge(clk1hz_i) then 
                    
            sum_of_velocities <= sum_of_velocities + unsigned(vel2avg_i);             
                
            if clk_cycles = 0 then
                avg_velocity_o <= std_logic_vector(shift_right(unsigned(sum_of_velocities), count_of_shifts)); -- division of summed velocities 
                count_of_shifts := count_of_shifts + 1;                                    --   in order to compute avarage velocity
                clk_cycles := 2**(count_of_shifts - 1); 
            end if;
        
            clk_cycles := clk_cycles - 1;        
      
    end if;
    end if;
  end process p_avg_velocity;
end architecture behave;
```

### tb_p_AVG_VELOCITY
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rajm Jan
-- 
-- Design Name: p_AVG_VELOCITY
-- Module Name: COMPUTATION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_cnt_up_down is
    -- Entity of testbench is always empty
end entity tb_cnt_up_down; 

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_cnt_up_down is

    -- Number of bits for testbench counter

    --Local signals
    signal s_clk          : std_logic;
    signal reset          : std_logic;
    signal s_velocity     : std_logic_vector(10-1 downto 0);
    signal s_avg_velocity : std_logic_vector(10-1 downto 0);

begin
    -- Connecting testbench signals with cnt_up_down entity
    -- (Unit Under Test)
    uut_avg_vel : entity work.e_avg_velocity
        
        port map(
            clk1hz_i                         => s_clk,
            vel2avg_i                        => s_velocity,
            areset_i                          => reset,
            std_logic_vector(avg_velocity_o) => s_avg_velocity
        );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 750 ns loop         -- 75 periods of 100MHz clock
            s_clk <= '0';
            wait for 5 ns;
            s_clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process p_clk_gen;
    
    --------------------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------------------
    p_reset : process
    begin
        reset <= '0';
        wait for 125 ns;
        reset <= '1';
        wait for 25 ns;
        reset <= '0';
        wait for 220 ns;
        reset <= '0';
        wait for 17ns;
        reset <= '0';
        wait;
    end process p_reset;

    --------------------------------------------------------------------
    -- Velocity generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        s_velocity <= "0000000000";
        wait for 10 ns;
        s_velocity <= "0000001010";
        wait for 10 ns;
        s_velocity <= "0000001100";
        wait for 10 ns;
        s_velocity <= "0000001110";
        wait for 10 ns;
        s_velocity <= "0000011001";
        wait for 10 ns;
        s_velocity <= "0000001000";
        wait for 10 ns;
        s_velocity <= "0000001010";
        wait for 10 ns;
        s_velocity <= "0000001010";
        wait for 10 ns;
        s_velocity <= "0000001100";
        wait for 10 ns;
        s_velocity <= "0000001110";
        wait for 10 ns;
        s_velocity <= "0000000000";
        wait for 10 ns;
        s_velocity <= "0000001000";
        wait for 10 ns;
        s_velocity <= "0000001010";
        wait for 10 ns;
        s_velocity <= "0000001100";
        wait for 10 ns;
        s_velocity <= "0000001010";
        wait for 10 ns;
        s_velocity <= "0000001001";
        wait for 10 ns;
        s_velocity <= "0000001000";
        wait for 10 ns;
        s_velocity <= "0000001010";
        wait for 10 ns;
        s_velocity <= "0000001010";
        wait for 10 ns;
        s_velocity <= "0000001100";
        wait for 10 ns;
        s_velocity <= "0000001110";
        wait for 10 ns;
        s_velocity <= "0000000000";
    end process p_stimulus;

end architecture testbench;
```

### simulation p_AVG_VELOCITY
![p_AVG_VELOCITY simulation 1](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/p_AVG_VELOCITY/images/simulation1.jpg "p_AVG_VELOCITY simulation 1")
![p_AVG_VELOCITY simulation 2](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/p_AVG_VELOCITY/images/simulation2.jpg "p_AVG_VELOCITY simulation 2")
![p_AVG_VELOCITY simulation 3](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/p_AVG_VELOCITY/images/simulation3.jpg "p_AVG_VELOCITY simulation 3")
![p_AVG_VELOCITY simulation 4](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/p_AVG_VELOCITY/images/simulation4.jpg "p_AVG_VELOCITY simulation 4")

### p_DISTANCE
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rajm Jan, Mat?j Podaný
-- 
-- Design Name: p_DISTANCE
-- Module Name: COMPUTATION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity distance is
  Port ( 
    sensor_i     : in std_logic;
    areset_i     : in std_logic;
    distance_o   : out std_logic_vector(10-1 downto 0) := "0000000000"
  );
end distance;

architecture Behavioral of distance is

    signal s_distance : unsigned(10-1 downto 0) := "0000000000"; -- necessary for summing

    begin
        p_distance : process(sensor_i, areset_i)
        
        variable sum : integer := 0; -- counts input signals 
        
        begin
            if areset_i = '1' then
                sum := 0;
                s_distance <= "0000000000";
            else
                if rising_edge(sensor_i) then
                    sum := sum + 1;
                    if sum > 500 then --for simulation purpouse, in application: if sum > 500 then (...). We consider wheel with circuit of 2m thus 1km means 500 revolutions. 
                      sum := 0;
                      s_distance <= s_distance + "0000000001";    
                    end if;
                    --distance_o <= std_logic_vector(s_distance);
                 end if;
                 
                 distance_o <= std_logic_vector(s_distance);
                 
            end if;
        end process p_distance;
        
end Behavioral;
```

### tb_p_DISTANCE
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rajm Jan, Matěj Podaný
-- 
-- Design Name: p_DISTANCE
-- Module Name: COMPUTATION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_distance is
    -- Entity of testbench is always empty
end entity tb_distance;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_distance is

    signal s_signal     :  std_logic;
    signal reset        :  std_logic;
    signal s_distance   :  std_logic_vector(10-1 downto 0);
    
begin
    uut_driver_7_seg: entity work.distance
        port map (
            
            sensor_i     =>  s_signal,
            areset_i    =>  reset,
            distance_o => s_distance
        );
    p_reset_gen : process
    begin
        reset <= '0';
        wait for 500 ns;
        reset <= '1';
        wait for 53 ns;
        reset <= '0';
        wait;
    end process p_reset_gen;
    
    p_stimulus : process
    begin
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';     
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';     
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';     
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        s_signal <= '0';
        wait for 10 ns;
        s_signal <= '1';
        wait for 10 ns;
        
        wait;
    end process p_stimulus;
end architecture testbench;
```

### simulation p_DISTANCE
![p_DISTANCE simulation 1](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/P_DISTANCE/images/simulation1.jpg "p_DISTANCE simulation 1")
![p_DISTANCE simulation 2](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/P_DISTANCE/images/simulation2.jpg "p_DISTANCE simulation 2")

### p_OUTPUT
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rajm Jan, Mat?j Podaný
-- 
-- Design Name: p_OUTPUT
-- Module Name: COMPUTATION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity output is
  Port ( 
    clk1hz_i          : in  std_logic;
    status_i       : in  std_logic_vector(2-1 downto 0);
    distance_i     : in  std_logic_vector(10-1 downto 0);
    avg_velocity_i : in  std_logic_vector(10-1 downto 0);
    velocity_i     : in  std_logic_vector(10-1 downto 0);
    value_o        : out std_logic_vector(10-1 downto 0) := "0000000000"
  );
end output;

architecture Behavioral of output is

begin
p_output : process(status_i, clk1hz_i)
    begin
        if rising_edge(clk1hz_i) then
            case status_i is
                when "00" =>
                    value_o <= velocity_i;
                when "01" =>
                    value_o <= avg_velocity_i;
                when "10" =>
                    value_o <= distance_i;
                when others =>
                    value_o <= velocity_i;
            end case;
        end if;
    end process p_output;

end Behavioral;
```

### tb_p_OUTPUT
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Rajm Jan
-- 
-- Design Name: p_OUTPUT
-- Module Name: COMPUTATION
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clock is
--  Port ( );
end tb_clock;

architecture Behavioral of tb_clock is
    signal s_clk          :  std_logic;
    signal s_status       :  std_logic_vector(2-1 downto 0);
    signal s_distance     :  std_logic_vector(10-1 downto 0);
    signal s_avg_velocity :  std_logic_vector(10-1 downto 0);
    signal s_velocity     :  std_logic_vector(10-1 downto 0);
    signal s_value        :  std_logic_vector(10-1 downto 0);
begin
    uut_clock : entity work.output
        port map(
            clk1hz_i          => s_clk,
            status_i       => s_status,
            distance_i     => s_distance,
            avg_velocity_i => s_avg_velocity,
            velocity_i     => s_velocity,
            value_o        => s_value
                );
                
    p_clk_gen : process
    begin
        while now < 750 ns loop         -- 75 periods of 100MHz clock
            s_clk <= '0';
            wait for 2 ns;
            s_clk <= '1';
            wait for 2 ns;
        end loop;
        wait;
    end process p_clk_gen;
                
    p_status : process
    begin
        s_status <= "00";
        wait for 200 ns;
        s_status <= "01";
        wait for 200 ns;
        s_status <= "10";
        wait for 200 ns;
        s_status <= "11"; -- intentionaly unexpected value    
    end process p_status;
    
    p_distance : process
    begin
        s_distance <= "0000000000";
        wait for 45 ns;
        s_distance <= "0000000001";
        wait for 45 ns;
        s_distance <= "0000000010";
        wait for 45 ns;
        s_distance <= "0000000011";
        wait for 45 ns;
        s_distance <= "0000000100";
        wait for 45 ns;
        s_distance <= "0000000101";
        wait for 45 ns;
        s_distance <= "0000000110";
        wait for 45 ns;
        s_distance <= "0000000111";
        wait for 45 ns;
        s_distance <= "0000001000";
        wait for 45 ns;
        s_distance <= "0000001001";
        wait for 45 ns;
        s_distance <= "0000001010";
        wait for 45 ns;
        s_distance <= "0000001011";
        wait for 45 ns;
        s_distance <= "0000001100";
        wait;
    end process p_distance;
    
    p_avg_velocity : process
    begin
        s_avg_velocity <= "0000000000";
        wait for 60 ns;
        s_avg_velocity <= "0000000010";
        wait for 60 ns;
        s_avg_velocity <= "0000000011";
        wait for 60 ns;
        s_avg_velocity <= "0000000101";
        wait for 60 ns;
        s_avg_velocity <= "0000000110";
        wait for 60 ns;
        s_avg_velocity <= "0000000101";
        wait for 60 ns;
        s_avg_velocity <= "0000000100";
        wait for 60 ns;
        s_avg_velocity <= "0000000110";
        wait for 60 ns;
        s_avg_velocity <= "0000001000";
        wait for 60 ns;
        s_avg_velocity <= "0000000111";
        wait for 60 ns;
        s_avg_velocity <= "0000000100";
        wait for 60 ns;
        s_avg_velocity <= "0000000101";
        wait for 60 ns;
        wait;
    end process p_avg_velocity;
    
    p_velocity : process
    begin
        s_velocity <= "0000000010";
        wait for 60 ns;
        s_velocity <= "0000000100";
        wait for 60 ns;
        s_velocity <= "0000000010";
        wait for 60 ns;
        s_velocity <= "0000000110";
        wait for 60 ns;
        s_velocity <= "0000011000";
        wait for 60 ns;
        s_velocity <= "0000001010";
        wait for 60 ns;
        s_velocity <= "0000001100";
        wait for 60 ns;
        s_velocity <= "0000000011";
        wait for 60 ns;
        s_velocity <= "0000001010";
        wait for 60 ns;
        s_velocity <= "0000000111";
        wait for 60 ns;
        s_velocity <= "0000000100";
        wait for 60 ns;
        s_velocity <= "0000001001";
        wait for 60 ns;
        wait;
    end process p_velocity;
    
end Behavioral;
```

### simulation p_OUTPUT
![p_OUTPUT simulation 1](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/P_OUTPUT/images/simulation1.jpg "p_OUTPUT simulation 1")
![p_OUTPUT simulation 2](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/COMPUTATION/P_OUTPUT/images/simulation2.jpg "p_OUTPUT simulation 2")

## TOP module description and simulations (Arty A7-35)

### Schematic diagram
![TOP schematic](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/TOP/images/schematic.jpg "TOP schematic")

### TOP
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Mat?j Podaný
-- 
-- Design Name: TOP
-- Module Name: TOP
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
  Port ( 
        button1_i     : in std_logic;
        button2_i     : in std_logic;
        hall_i        : in std_logic;
        adress_o      : out std_logic_vector(3-1 downto 0);
        number_o      : out std_logic_vector(4-1 downto 0)
        );
end top;

architecture Behavioral of top is
        signal s_clk125hz        : std_logic;
        signal s_clk1hz          : std_logic;
        signal s_value           : std_logic_vector(10-1 downto 0);
        signal s_status          : std_logic_vector(2-1 downto 0);
begin
OPTION : entity work.option
        port map(
            btn_i    => button1_i,
            choose_o => s_status
        );

CLOCK : entity work.clock 
        port map(
            clk1hz_o   => s_clk1hz,
            clk125hz_o => s_clk125hz
        );
        
COMPUTATION : entity work.computation 
        port map(
            clk1hz_i => s_clk1hz,
            reset_i  => button2_i,
            sensor_i => hall_i,
            status_i => s_status,
            s1_value => s_value
        );
        
DISPLAYER : entity work.displayer 
        port map(
            value_i    => s_value,
            clk125hz_i => s_clk125hz,
            display_o  => adress_o,
            seg_o      => number_o
        );
        
        
end Behavioral;
```

### tb_TOP
```vhdl
----------------------------------------------------------------------------------
-- Company: VUT FEKT
-- Engineer: Mat?j Podaný
-- 
-- Design Name: TOP
-- Module Name: TOP
-- Project Name: Cyclo tachometer
-- Target Devices: Nexys A7-35
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top is
--  Testbench entity is always empty
end tb_top;

architecture Behavioral of tb_top is
    signal s_button1     : std_logic;
    signal s_button2     : std_logic;
    signal s_hall        : std_logic;
    signal s_adress      : std_logic_vector(3-1 downto 0);
    signal s_number      : std_logic_vector(4-1 downto 0);
    
begin
uut_top: entity work.top
        port map (
           button1_i => s_button1,
           button2_i => s_button2,
           hall_i    => s_hall,
           adress_o  => s_adress, 
           number_o  => s_number 
        );

p_reset_gen : process
    begin
        s_button2 <= '0';
        wait for 14000 ms;
        s_button2 <= '1'; -- one push of the reset button
        wait for 500 ms;
        s_button2 <= '0';
        wait;
    end process p_reset_gen;
    
p_status : process
    begin
        s_button1 <= '0'; 
        wait for 4000 ms;
        s_button1 <= '1'; -- first button push
        wait for 500 ms;
        s_button1 <= '0';
        wait for 3500 ms;
        s_button1 <= '1'; -- second button push
        wait for 500 ms;
        s_button1 <= '0';
        wait for 3500 ms;
        s_button1 <= '1'; -- thirt button push
        wait for 500 ms;
        s_button1 <= '0';
        wait;
    end process p_status;
    
p_sensor : process
    begin
        s_hall <= '0'; -- accelerating
        wait for 500 ms;
        s_hall <= '1';
        wait for 10 ms;
        s_hall <= '0';
        wait for 400 ms;
        s_hall <= '1';
        wait for 10 ms;
        s_hall <= '0';
        wait for 300 ms;
        s_hall <= '1';
        wait for 10 ms;
        s_hall <= '0';
        wait for 200 ms;
        s_hall <= '1';
        wait for 10 ms;
        s_hall <= '0';
        wait for 100 ms;
        s_hall <= '1';
        wait for 10 ms;
        s_hall <= '0';
        wait for 100 ms; 
        while now < 16000 ms loop  -- stable     
            s_hall <= '1';
            wait for 10 ms;
            s_hall <= '0';
            wait for 190 ms;
        end loop;
        wait;
    end process p_sensor;


end Behavioral;
```

### c_TOP
```vhdl
## This file is a general .xdc for the Arty A7-35 Rev. D
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
#set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK100MHZ }];

## Switches
#set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]; #IO_L12N_T1_MRCC_16 Sch=sw[0]
#set_property -dict { PACKAGE_PIN C11   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #IO_L13P_T2_MRCC_16 Sch=sw[1]
#set_property -dict { PACKAGE_PIN C10   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }]; #IO_L13N_T2_MRCC_16 Sch=sw[2]
#set_property -dict { PACKAGE_PIN A10   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }]; #IO_L14P_T2_SRCC_16 Sch=sw[3]

## RGB LEDs
#set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { led0_b }]; #IO_L18N_T2_35 Sch=led0_b
#set_property -dict { PACKAGE_PIN F6    IOSTANDARD LVCMOS33 } [get_ports { led0_g }]; #IO_L19N_T3_VREF_35 Sch=led0_g
#set_property -dict { PACKAGE_PIN G6    IOSTANDARD LVCMOS33 } [get_ports { led0_r }]; #IO_L19P_T3_35 Sch=led0_r
#set_property -dict { PACKAGE_PIN G4    IOSTANDARD LVCMOS33 } [get_ports { led1_b }]; #IO_L20P_T3_35 Sch=led1_b
#set_property -dict { PACKAGE_PIN J4    IOSTANDARD LVCMOS33 } [get_ports { led1_g }]; #IO_L21P_T3_DQS_35 Sch=led1_g
#set_property -dict { PACKAGE_PIN G3    IOSTANDARD LVCMOS33 } [get_ports { led1_r }]; #IO_L20N_T3_35 Sch=led1_r
#set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { led2_b }]; #IO_L21N_T3_DQS_35 Sch=led2_b
#set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVCMOS33 } [get_ports { led2_g }]; #IO_L22N_T3_35 Sch=led2_g
#set_property -dict { PACKAGE_PIN J3    IOSTANDARD LVCMOS33 } [get_ports { led2_r }]; #IO_L22P_T3_35 Sch=led2_r
#set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { led3_b }]; #IO_L23P_T3_35 Sch=led3_b
#set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { led3_g }]; #IO_L24P_T3_35 Sch=led3_g
#set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { led3_r }]; #IO_L23N_T3_35 Sch=led3_r

## LEDs
#set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #IO_L24N_T3_35 Sch=led[4]
#set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #IO_25_35 Sch=led[5]
#set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; #IO_L24P_T3_A01_D17_14 Sch=led[6]
#set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; #IO_L24N_T3_A00_D16_14 Sch=led[7]

## Buttons
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports button1_i]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports button2_i]
#set_property -dict { PACKAGE_PIN B9    IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; #IO_L11N_T1_SRCC_16 Sch=btn[2]
#set_property -dict { PACKAGE_PIN B8    IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]; #IO_L12P_T1_MRCC_16 Sch=btn[3]

## Pmod Header JA
#set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { ja[7] }]; #IO_25_15 Sch=ja[10]

## Pmod Header JB
#set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { jb[0] }]; #IO_L11P_T1_SRCC_15 Sch=jb_p[1]
#set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { jb[1] }]; #IO_L11N_T1_SRCC_15 Sch=jb_n[1]
#set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { jb[2] }]; #IO_L12P_T1_MRCC_15 Sch=jb_p[2]
#set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { jb[3] }]; #IO_L12N_T1_MRCC_15 Sch=jb_n[2]
#set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { jb[4] }]; #IO_L23P_T3_FOE_B_15 Sch=jb_p[3]
#set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { jb[5] }]; #IO_L23N_T3_FWE_B_15 Sch=jb_n[3]
#set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { jb[6] }]; #IO_L24P_T3_RS1_15 Sch=jb_p[4]
#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { jb[7] }]; #IO_L24N_T3_RS0_15 Sch=jb_n[4]

## Pmod Header JC
#set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { jc[0] }]; #IO_L20P_T3_A08_D24_14 Sch=jc_p[1]
#set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { jc[1] }]; #IO_L20N_T3_A07_D23_14 Sch=jc_n[1]
#set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { jc[2] }]; #IO_L21P_T3_DQS_14 Sch=jc_p[2]
#set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { jc[3] }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=jc_n[2]
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { jc[4] }]; #IO_L22P_T3_A05_D21_14 Sch=jc_p[3]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { jc[5] }]; #IO_L22N_T3_A04_D20_14 Sch=jc_n[3]
#set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { jc[6] }]; #IO_L23P_T3_A03_D19_14 Sch=jc_p[4]
#set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { jc[7] }]; #IO_L23N_T3_A02_D18_14 Sch=jc_n[4]

## Pmod Header JD
#set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { jd[0] }]; #IO_L11N_T1_SRCC_35 Sch=jd[1]
#set_property -dict { PACKAGE_PIN D3    IOSTANDARD LVCMOS33 } [get_ports { jd[1] }]; #IO_L12N_T1_MRCC_35 Sch=jd[2]
#set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { jd[2] }]; #IO_L13P_T2_MRCC_35 Sch=jd[3]
#set_property -dict { PACKAGE_PIN F3    IOSTANDARD LVCMOS33 } [get_ports { jd[3] }]; #IO_L13N_T2_MRCC_35 Sch=jd[4]
#set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { jd[4] }]; #IO_L14P_T2_SRCC_35 Sch=jd[7]
#set_property -dict { PACKAGE_PIN D2    IOSTANDARD LVCMOS33 } [get_ports { jd[5] }]; #IO_L14N_T2_SRCC_35 Sch=jd[8]
#set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { jd[6] }]; #IO_L15P_T2_DQS_35 Sch=jd[9]
#set_property -dict { PACKAGE_PIN G2    IOSTANDARD LVCMOS33 } [get_ports { jd[7] }]; #IO_L15N_T2_DQS_35 Sch=jd[10]

## USB-UART Interface
#set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out
#set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]; #IO_L14N_T2_SRCC_16 Sch=uart_txd_in

## ChipKit Outer Digital Header
#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { ck_io0  }]; #IO_L16P_T2_CSI_B_14          Sch=ck_io[0]
#set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { ck_io1  }]; #IO_L18P_T2_A12_D28_14        Sch=ck_io[1]
#set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { ck_io2  }]; #IO_L8N_T1_D12_14             Sch=ck_io[2]
#set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { ck_io3  }]; #IO_L19P_T3_A10_D26_14        Sch=ck_io[3]
#set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { ck_io4  }]; #IO_L5P_T0_D06_14             Sch=ck_io[4]
#set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { ck_io5  }]; #IO_L14P_T2_SRCC_14           Sch=ck_io[5]
#set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { ck_io6  }]; #IO_L14N_T2_SRCC_14           Sch=ck_io[6]
#set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { ck_io7  }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=ck_io[7]
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { ck_io8  }]; #IO_L11P_T1_SRCC_14           Sch=ck_io[8]
#set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports { ck_io9  }]; #IO_L10P_T1_D14_14            Sch=ck_io[9]
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { ck_io10 }]; #IO_L18N_T2_A11_D27_14        Sch=ck_io[10]
#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { ck_io11 }]; #IO_L17N_T2_A13_D29_14        Sch=ck_io[11]
#set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { ck_io12 }]; #IO_L12N_T1_MRCC_14           Sch=ck_io[12]
#set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { ck_io13 }]; #IO_L12P_T1_MRCC_14           Sch=ck_io[13]

## ChipKit Inner Digital Header
#set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { ck_io26 }]; #IO_L19N_T3_A09_D25_VREF_14 	Sch=ck_io[26]
#set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { ck_io27 }]; #IO_L16N_T2_A15_D31_14 		Sch=ck_io[27]
#set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { ck_io28 }]; #IO_L6N_T0_D08_VREF_14 		Sch=ck_io[28]
#set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { ck_io29 }]; #IO_25_14 		 			Sch=ck_io[29]
#set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { ck_io30 }]; #IO_0_14  		 			Sch=ck_io[30]
#set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { ck_io31 }]; #IO_L5N_T0_D07_14 			Sch=ck_io[31]
#set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { ck_io32 }]; #IO_L13N_T2_MRCC_14 			Sch=ck_io[32]
#set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { ck_io33 }]; #IO_L13P_T2_MRCC_14 			Sch=ck_io[33]
#set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { ck_io34 }]; #IO_L15P_T2_DQS_RDWR_B_14 	Sch=ck_io[34]
#set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { ck_io35 }]; #IO_L11N_T1_SRCC_14 			Sch=ck_io[35]
#set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { ck_io36 }]; #IO_L8P_T1_D11_14 			Sch=ck_io[36]
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { ck_io37 }]; #IO_L17P_T2_A14_D30_14 		Sch=ck_io[37]
#set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { ck_io38 }]; #IO_L7N_T1_D10_14 			Sch=ck_io[38]
#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { ck_io39 }]; #IO_L7P_T1_D09_14 			Sch=ck_io[39]
#set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { ck_io40 }]; #IO_L9N_T1_DQS_D13_14 		Sch=ck_io[40]
#set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { ck_io41 }]; #IO_L9P_T1_DQS_14 			Sch=ck_io[41]

## ChipKit Outer Analog Header - as Single-Ended Analog Inputs
## NOTE: These ports can be used as single-ended analog inputs with voltages from 0-3.3V (ChipKit analog pins A0-A5) or as digital I/O.
## WARNING: Do not use both sets of constraints at the same time!
## NOTE: The following constraints should be used with the XADC IP core when using these ports as analog inputs.
#set_property -dict { PACKAGE_PIN C5    IOSTANDARD LVCMOS33 } [get_ports { vaux4_n  }]; #IO_L1N_T0_AD4N_35 		Sch=ck_an_n[0]	ChipKit pin=A0
#set_property -dict { PACKAGE_PIN C6    IOSTANDARD LVCMOS33 } [get_ports { vaux4_p  }]; #IO_L1P_T0_AD4P_35 		Sch=ck_an_p[0]	ChipKit pin=A0
#set_property -dict { PACKAGE_PIN A5    IOSTANDARD LVCMOS33 } [get_ports { vaux5_n  }]; #IO_L3N_T0_DQS_AD5N_35 	Sch=ck_an_n[1]	ChipKit pin=A1
#set_property -dict { PACKAGE_PIN A6    IOSTANDARD LVCMOS33 } [get_ports { vaux5_p  }]; #IO_L3P_T0_DQS_AD5P_35 	Sch=ck_an_p[1]	ChipKit pin=A1
#set_property -dict { PACKAGE_PIN B4    IOSTANDARD LVCMOS33 } [get_ports { vaux6_n  }]; #IO_L7N_T1_AD6N_35 		Sch=ck_an_n[2]	ChipKit pin=A2
#set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports { vaux6_p  }]; #IO_L7P_T1_AD6P_35 		Sch=ck_an_p[2]	ChipKit pin=A2
#set_property -dict { PACKAGE_PIN A1    IOSTANDARD LVCMOS33 } [get_ports { vaux7_n  }]; #IO_L9N_T1_DQS_AD7N_35 	Sch=ck_an_n[3]	ChipKit pin=A3
#set_property -dict { PACKAGE_PIN B1    IOSTANDARD LVCMOS33 } [get_ports { vaux7_p  }]; #IO_L9P_T1_DQS_AD7P_35 	Sch=ck_an_p[3]	ChipKit pin=A3
#set_property -dict { PACKAGE_PIN B2    IOSTANDARD LVCMOS33 } [get_ports { vaux15_n }]; #IO_L10N_T1_AD15N_35 	Sch=ck_an_n[4]	ChipKit pin=A4
#set_property -dict { PACKAGE_PIN B3    IOSTANDARD LVCMOS33 } [get_ports { vaux15_p }]; #IO_L10P_T1_AD15P_35 	Sch=ck_an_p[4]	ChipKit pin=A4
#set_property -dict { PACKAGE_PIN C14   IOSTANDARD LVCMOS33 } [get_ports { vaux0_n  }]; #IO_L1N_T0_AD0N_15 		Sch=ck_an_n[5]	ChipKit pin=A5
#set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { vaux0_p  }]; #IO_L1P_T0_AD0P_15 		Sch=ck_an_p[5]	ChipKit pin=A5
## ChipKit Outer Analog Header - as Digital I/O
## NOTE: the following constraints should be used when using these ports as digital I/O.
set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS33} [get_ports hall_i]
#set_property -dict { PACKAGE_PIN D8    IOSTANDARD LVCMOS33 } [get_ports { ck_a1 }]; #IO_L4P_T0_35      	Sch=ck_a[1]		ChipKit pin=A1
#set_property -dict { PACKAGE_PIN C7    IOSTANDARD LVCMOS33 } [get_ports { ck_a2 }]; #IO_L4N_T0_35      	Sch=ck_a[2]		ChipKit pin=A2
#set_property -dict { PACKAGE_PIN E7    IOSTANDARD LVCMOS33 } [get_ports { ck_a3 }]; #IO_L6P_T0_35      	Sch=ck_a[3]		ChipKit pin=A3
#set_property -dict { PACKAGE_PIN D7    IOSTANDARD LVCMOS33 } [get_ports { ck_a4 }]; #IO_L6N_T0_VREF_35 	Sch=ck_a[4]		ChipKit pin=A4
#set_property -dict { PACKAGE_PIN D5    IOSTANDARD LVCMOS33 } [get_ports { ck_a5 }]; #IO_L11P_T1_SRCC_35	Sch=ck_a[5]		ChipKit pin=A5

## ChipKit Inner Analog Header - as Differential Analog Inputs
## NOTE: These ports can be used as differential analog inputs with voltages from 0-1.0V (ChipKit Analog pins A6-A11) or as digital I/O.
## WARNING: Do not use both sets of constraints at the same time!
## NOTE: The following constraints should be used with the XADC core when using these ports as analog inputs.
#set_property -dict { PACKAGE_PIN B7    IOSTANDARD LVCMOS33 } [get_ports { vaux12_p }]; #IO_L2P_T0_AD12P_35	Sch=ad_p[12]	ChipKit pin=A6
#set_property -dict { PACKAGE_PIN B6    IOSTANDARD LVCMOS33 } [get_ports { vaux12_n }]; #IO_L2N_T0_AD12N_35	Sch=ad_n[12]	ChipKit pin=A7
#set_property -dict { PACKAGE_PIN E6    IOSTANDARD LVCMOS33 } [get_ports { vaux13_p }]; #IO_L5P_T0_AD13P_35	Sch=ad_p[13]	ChipKit pin=A8
#set_property -dict { PACKAGE_PIN E5    IOSTANDARD LVCMOS33 } [get_ports { vaux13_n }]; #IO_L5N_T0_AD13N_35	Sch=ad_n[13]	ChipKit pin=A9
#set_property -dict { PACKAGE_PIN A4    IOSTANDARD LVCMOS33 } [get_ports { vaux14_p }]; #IO_L8P_T1_AD14P_35	Sch=ad_p[14]	ChipKit pin=A10
#set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { vaux14_n }]; #IO_L8N_T1_AD14N_35	Sch=ad_n[14]	ChipKit pin=A11
## ChipKit Inner Analog Header - as Digital I/O
## NOTE: the following constraints should be used when using the inner analog header ports as digital I/O.
#set_property -dict { PACKAGE_PIN B7    IOSTANDARD LVCMOS33 } [get_ports { ck_io20 }]; #IO_L2P_T0_AD12P_35	Sch=ad_p[12]	ChipKit pin=A6
#set_property -dict { PACKAGE_PIN B6    IOSTANDARD LVCMOS33 } [get_ports { ck_io21 }]; #IO_L2N_T0_AD12N_35	Sch=ad_n[12]	ChipKit pin=A7
#set_property -dict { PACKAGE_PIN E6    IOSTANDARD LVCMOS33 } [get_ports { ck_io22 }]; #IO_L5P_T0_AD13P_35	Sch=ad_p[13]	ChipKit pin=A8
#set_property -dict { PACKAGE_PIN E5    IOSTANDARD LVCMOS33 } [get_ports { ck_io23 }]; #IO_L5N_T0_AD13N_35	Sch=ad_n[13]	ChipKit pin=A9
#set_property -dict { PACKAGE_PIN A4    IOSTANDARD LVCMOS33 } [get_ports { ck_io24 }]; #IO_L8P_T1_AD14P_35	Sch=ad_p[14]	ChipKit pin=A10
#set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { ck_io25 }]; #IO_L8N_T1_AD14N_35	Sch=ad_n[14]	ChipKit pin=A11

## ChipKit SPI
#set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports { ck_miso }]; #IO_L17N_T2_35 Sch=ck_miso
#set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports { ck_mosi }]; #IO_L17P_T2_35 Sch=ck_mosi
#set_property -dict { PACKAGE_PIN F1    IOSTANDARD LVCMOS33 } [get_ports { ck_sck }]; #IO_L18P_T2_35 Sch=ck_sck
#set_property -dict { PACKAGE_PIN C1    IOSTANDARD LVCMOS33 } [get_ports { ck_ss }]; #IO_L16N_T2_35 Sch=ck_ss

## ChipKit I2C
#set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { ck_scl }]; #IO_L4P_T0_D04_14 Sch=ck_scl
#set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { ck_sda }]; #IO_L4N_T0_D05_14 Sch=ck_sda
#set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { scl_pup }]; #IO_L9N_T1_DQS_AD3N_15 Sch=scl_pup
#set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { sda_pup }]; #IO_L9P_T1_DQS_AD3P_15 Sch=sda_pup

## Misc. ChipKit Ports
#set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { ck_ioa }]; #IO_L10N_T1_D15_14 Sch=ck_ioa
#set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { ck_rst }]; #IO_L16P_T2_35 Sch=ck_rst

## SMSC Ethernet PHY
#set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports { eth_col }]; #IO_L16N_T2_A27_15 Sch=eth_col
#set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { eth_crs }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=eth_crs
#set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { eth_mdc }]; #IO_L14N_T2_SRCC_15 Sch=eth_mdc
#set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { eth_mdio }]; #IO_L17P_T2_A26_15 Sch=eth_mdio
#set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { eth_ref_clk }]; #IO_L22P_T3_A17_15 Sch=eth_ref_clk
#set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports { eth_rstn }]; #IO_L20P_T3_A20_15 Sch=eth_rstn
#set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVCMOS33 } [get_ports { eth_rx_clk }]; #IO_L14P_T2_SRCC_15 Sch=eth_rx_clk
#set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { eth_rx_dv }]; #IO_L13N_T2_MRCC_15 Sch=eth_rx_dv
#set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[0] }]; #IO_L21N_T3_DQS_A18_15 Sch=eth_rxd[0]
#set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[1] }]; #IO_L16P_T2_A28_15 Sch=eth_rxd[1]
#set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[2] }]; #IO_L21P_T3_DQS_15 Sch=eth_rxd[2]
#set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[3] }]; #IO_L18N_T2_A23_15 Sch=eth_rxd[3]
#set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { eth_rxerr }]; #IO_L20N_T3_A19_15 Sch=eth_rxerr
#set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { eth_tx_clk }]; #IO_L13P_T2_MRCC_15 Sch=eth_tx_clk
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { eth_tx_en }]; #IO_L19N_T3_A21_VREF_15 Sch=eth_tx_en
#set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[0] }]; #IO_L15P_T2_DQS_15 Sch=eth_txd[0]
#set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[1] }]; #IO_L19P_T3_A22_15 Sch=eth_txd[1]
#set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[2] }]; #IO_L17N_T2_A25_15 Sch=eth_txd[2]
#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[3] }]; #IO_L18P_T2_A24_15 Sch=eth_txd[3]

## Quad SPI Flash
#set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS33 } [get_ports { qspi_cs }]; #IO_L6P_T0_FCS_B_14 Sch=qspi_cs
#set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[0] }]; #IO_L1P_T0_D00_MOSI_14 Sch=qspi_dq[0]
#set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[1] }]; #IO_L1N_T0_D01_DIN_14 Sch=qspi_dq[1]
#set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[2] }]; #IO_L2P_T0_D02_14 Sch=qspi_dq[2]
#set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[3] }]; #IO_L2N_T0_D03_14 Sch=qspi_dq[3]

## Power Measurements
#set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33     } [get_ports { vsnsvu_n }]; #IO_L7N_T1_AD2N_15 Sch=ad_n[2]
#set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33     } [get_ports { vsnsvu_p }]; #IO_L7P_T1_AD2P_15 Sch=ad_p[2]
#set_property -dict { PACKAGE_PIN B12   IOSTANDARD LVCMOS33     } [get_ports { vsns5v0_n }]; #IO_L3N_T0_DQS_AD1N_15 Sch=ad_n[1]
#set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33     } [get_ports { vsns5v0_p }]; #IO_L3P_T0_DQS_AD1P_15 Sch=ad_p[1]
#set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS33     } [get_ports { isns5v0_n }]; #IO_L5N_T0_AD9N_15 Sch=ad_n[9]
#set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33     } [get_ports { isns5v0_p }]; #IO_L5P_T0_AD9P_15 Sch=ad_p[9]
#set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS33     } [get_ports { isns0v95_n }]; #IO_L8N_T1_AD10N_15 Sch=ad_n[10]
#set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS33     } [get_ports { isns0v95_p }]; #IO_L8P_T1_AD10P_15 Sch=ad_p[10]

set_property PACKAGE_PIN D13 [get_ports {number_o[0]}]
set_property PACKAGE_PIN B18 [get_ports {number_o[1]}]
set_property PACKAGE_PIN A18 [get_ports {number_o[2]}]
set_property PACKAGE_PIN G13 [get_ports {adress_o[0]}]
set_property PACKAGE_PIN B11 [get_ports {adress_o[1]}]
set_property PACKAGE_PIN A11 [get_ports {adress_o[2]}]
set_property PACKAGE_PIN D12 [get_ports {number_o[3]}]

set_property IOSTANDARD LVCMOS18 [get_ports {adress_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {adress_o[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {adress_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {number_o[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {number_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {number_o[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {number_o[0]}]
```

### simulation TOP
![TOP simulation 1](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/TOP/images/simulation1.jpg "TOP simulation 1")
![TOP simulation 2](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/TOP/images/simulation2.jpg "TOP simulation 2")
![TOP simulation 3](https://github.com/Matej-Podany/Digital-electronics-1/blob/main/Labs/project/TOP/images/simulation3.jpg "TOP simulation 3")
**Je potřeba si uvědomit, že distance bude v takovýchto simulacích vždy 0, jelikož je jeho jednotka v km a nikdo neujede za pár vteřin kilometr.**

## Video
[**Prezentace projektu videem**](https://youtu.be/edOG29XobNQ)

## Project valorization
Stanovené cíle v sekci "project objectives" se nám podařilo z většiny splnit. Navržená deska se třemi sedmi segmentovými displeji funguje dobře počet displejů pro cyklo tachometr je dostačující.
Podařilo se nám naprogramovat bezchybně počítání uražené vzdálenosti za ideální situace. To znamená, že poloměr kola, a tedy i jeho obvod je konstantní a kolo je nepřetržitě v kontaktu s cestou, přičemž nikdy neprokluzuje.
Také jsme úspěšně vytvořili modul pro počítání průměrné rychlosti, který pomocí informace o aktuální rychlosti počítá váženým průměrem průměrnou rychlost. Jeho přesnost je vysoká, avšak dochází k zanedbatelnému zaokroluhlování
na celá čísla, což ale způsobí přesnost na +- 1 km/h. Modul aktuální rychlosti je bohužel v nedostatečné kvalitě a jeho jednoduchý princip umožňuje ukázat rychlost pouze s přesností +- 3,5 km/h. Hodnoty, které dokáže
zobrazit jsou 0 a násobky 7. Ostatní prvky jako tlačítka pro přepínání zobrazované informace a pro reset fungují bezchybně. Úspěšně probehla syntéza, implementace a vygenerování bitstreamu. Do budoucna by se tedy dalo rozhodně zlepšit modul aktuální rychlosti, který nevyhovuje
našim stanoveným parametrům. Dále by se dalo vytvořit nastavení obvodu kola, které by mnohonásobně rozšířilo použitelnost tohoto cyklo tachometru. Závěrem tedy bych považoval projekt za úspěšný, který nám dal hodně
zkušeností. Jsou tu nedostatky, avšak velmi dobře fungujících věcí je tu převaha.
 
## References

   1. Digilent - [**Arty A7-35 schematic**](https://reference.digilentinc.com/_media/reference/programmable-logic/arty-a7/arty_a7_sch.pdf)
   2. Digilent - [**Arty A7-35 reference manual**](https://reference.digilentinc.com/reference/programmable-logic/arty-a7/reference-manual)
   3. nandland - [**YouTube**](https://www.youtube.com/watch?v=ys1ftk5a2A4)
   4. nandland - [**NANDLAND website**](https://www.nandland.com/vhdl/examples/example-shifts.html)
   5. BITweenie - [**BITweenie website**](https://www.bitweenie.com/listings/vhdl-type-conversion/)
