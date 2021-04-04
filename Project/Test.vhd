library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity sub_module is
port(x,y : in STD_LOGIC;
s: in STD_LOGIC;
z: out STD_LOGIC);
end sub_module ;
 
architecture Behavioral of sub_module is
 
begin
 
process (x,y,s) is
begin
if (s ='0') then
z <= x;
else
z <= y;
end if;
end process;
 
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity top_module is
port(
 
A,B,C,D : in STD_LOGIC;
S0,S1: in STD_LOGIC;
Z: out STD_LOGIC
);
end top_module ;
 
architecture Behavioral of top_module is
component sub_module
port(x,y : in STD_LOGIC;
s: in STD_LOGIC;
z: out STD_LOGIC);
end component;
signal m1, m2: std_logic;
 
begin
c1: sub_module port map(A,B,S0,m1);
c2: sub_module port map(C,D,S0,m2);
c3: sub_module port map(m1,m2,S1,Z);
 
end Behavioral;

