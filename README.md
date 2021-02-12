# Digital-electronics-1

## Github link:
https://github.com/221066/Digital-electronics-1.git


## Verification of De Morgan's laws of function f(c,b,a)
### Testbench.vhd
```
library ieee;
use ieee.std_logic_1164.all;

entity tb_gates is
    -- Entity of testbench is always empty
end entity tb_gates;

architecture testbench of tb_gates is

    -- Local signals
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
library ieee;               -- Standard library
use ieee.std_logic_1164.all;-- Package for data types and logic operations

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
![Alt text](relative/path/to/img.jpg?raw=true "Title")
