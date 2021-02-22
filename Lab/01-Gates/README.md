# Digital-electronics-1

## Github link:
https://github.com/221066/Digital-electronics-1.git


## Verification of De Morgan's laws of function f(c,b,a)
### Testbench.vhd
```
library ieee;
use ieee.std_logic_1164.all;

entity tb_gates is
end entity tb_gates;

architecture testbench of tb_gates is

    signal s_a    : std_logic;
    signal s_b    : std_logic;
    signal s_c    : std_logic;
    signal s_f  : std_logic;
    signal s_fnand : std_logic;
    signal s_fnor : std_logic;

begin
    uut_gates : entity work.gates
        port map(
            a_i    => s_a,
            b_i    => s_b,
            c_i    => s_c,
            f_o  => s_f,
            fnand_o => s_fnand,
            fnor_o => s_fnor
        );

    p_stimulus : process
    begin
        s_a <= '0';             
        s_b <= '0';
        s_c <= '0';
        wait for 100 ns;
        s_a <= '1';
        s_b <= '0';
        s_c <= '0';
        wait for 100 ns;
        s_a <= '0';
        s_b <= '1';
        s_c <= '0';
        wait for 100 ns;
        s_a <= '1';
        s_b <= '1';
        s_c <= '0';
        wait for 100 ns;
        s_a <= '0';             
        s_b <= '0';
        s_c <= '1';
        wait for 100 ns;
        s_a <= '1';
        s_b <= '0';
        s_c <= '1';
        wait for 100 ns;
        s_a <= '0';
        s_b <= '1';
        s_c <= '1';
        wait for 100 ns;
        s_a <= '1';
        s_b <= '1';
        s_c <= '1';
        wait for 100 ns;
        
        wait;                   
    end process p_stimulus;

end architecture testbench;
```
### Design.vhd
```
library ieee;              
use ieee.std_logic_1164.all;

entity gates is
    port(
        a_i    : in  std_logic;         -- Data input
        b_i    : in  std_logic;         -- Data input
        c_i    : in  std_logic;         -- Data input
        f_o  : out std_logic;         -- OR output function
        fnand_o : out std_logic;         -- AND output function
        fnor_o : out std_logic          -- XOR output function
    );
end entity gates;

architecture dataflow of gates is
begin
    f_o  <= (not(b_i) and a_i) or (not(c_i) and not(b_i));
    fnand_o <= ((b_i nand b_i) nand a_i) nand ((b_i nand b_i) nand (c_i nand c_i));
    fnor_o <= (((a_i nor a_i) nor b_i) nor (c_i nor b_i)) nor '0';

end architecture dataflow;
```
### Waveforms
![Alt text](https://github.com/221066/Digital-electronics-1/blob/main/Wave1.png)
### EDA Playground link
https://www.edaplayground.com/x/bjnp


## Verification of Distributive laws
### Testbench.vhd
```
library ieee;
use ieee.std_logic_1164.all;

entity tb_gates is
end entity tb_gates;

architecture testbench of tb_gates is

    signal s_a    : std_logic;
    signal s_b    : std_logic;
    signal s_c    : std_logic;
    signal s_aleft  : std_logic;
    signal s_bleft : std_logic;
    signal s_aright : std_logic;
    signal s_bright : std_logic;

begin
    uut_gates : entity work.gates
        port map(
            a_i    => s_a,
            b_i    => s_b,
            c_i    => s_c,
            aleft_o  => s_aleft,
            bleft_o => s_bleft,
            aright_o => s_aright,
            bright_o => s_bright
        );

    p_stimulus : process
    begin
        s_a <= '0';             
        s_b <= '0';
        s_c <= '0';
        wait for 100 ns;
        s_a <= '1';
        s_b <= '0';
        s_c <= '0';
        wait for 100 ns;
        s_a <= '0';
        s_b <= '1';
        s_c <= '0';
        wait for 100 ns;
        s_a <= '1';
        s_b <= '1';
        s_c <= '0';
        wait for 100 ns;
        s_a <= '0';             
        s_b <= '0';
        s_c <= '1';
        wait for 100 ns;
        s_a <= '1';
        s_b <= '0';
        s_c <= '1';
        wait for 100 ns;
        s_a <= '0';
        s_b <= '1';
        s_c <= '1';
        wait for 100 ns;
        s_a <= '1';
        s_b <= '1';
        s_c <= '1';
        wait for 100 ns;
        
        wait;                  
    end process p_stimulus;

end architecture testbench;
```
### Design.vhd
```
library ieee;         
use ieee.std_logic_1164.all;

entity gates is
    port(
        a_i    : in  std_logic;         -- Data input
        b_i    : in  std_logic;         -- Data input
        c_i    : in  std_logic;         -- Data input
        aleft_o  : out std_logic;         -- OR output function
        bleft_o : out std_logic;         -- AND output function
        aright_o : out std_logic;          -- XOR output function
		bright_o : out std_logic    
    );
end entity gates;

architecture dataflow of gates is
begin
  	aleft_o   <= (a_i and b_i) or (a_i and c_i);
  	aright_o  <= a_i and (b_i or c_i);
        bleft_o   <= (a_i or b_i) and (a_i or c_i);
        bright_o  <= a_i or (b_i and c_i);
  
end architecture dataflow;
```
### Waveforms
![Alt text](https://github.com/221066/Digital-electronics-1/blob/main/Wave2.png)
### EDA Playground link
https://www.edaplayground.com/x/MAmP
