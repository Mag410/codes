-------------------------------------------------
-- Accumulator design
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--begin entity
entity accumulator16 is
port
( C :         in std_logic_vector (15 downto 0);
clk , load, reset : in std_logic;
D :        out std_logic_vector(24 downto 0)

);
end accumulator16;

architecture accumulator16_arch of accumulator16 is

component Madder25
port
( A , B :in std_logic_vector (24 downto 0);
cin : in std_logic;
cout : out  std_logic;
sum : out std_logic_vector (24 downto 0)
);
end component;

component bitreg25_Ro
port
(A: in std_logic_vector(24 downto 0);
Q: out std_logic_vector(24 downto 0);
clk,reset : in std_logic;
load : in std_logic
);
end component;

signal Q , sum : std_logic_vector(24 downto 0);
signal x : std_logic_vector(24 downto 0);
signal cout :std_logic;
begin

x <= "000000000" & c;
Madder_25    : madder25       port map   ( x , Q , '0' , cout , sum );

bitreg25RO   : bitreg25_RO    port map   ( sum , Q , clk ,reset ,load) ;
d<= Q ;

end accumulator16_arch;

-----------------------------------------------------------------
-- Multiplier accumulator
-----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--begin entity
entity MultiAcc is
port
( A , B :         in std_logic_vector (7 downto 0);
clk  ,reset : in std_logic;
D :        out std_logic_vector(24 downto 0)

);
end MultiAcc;

architecture multiacc_arch of MultiAcc is

component bitreg8_RA
port
(A: in std_logic_vector(7 downto 0);
Q: out std_logic_vector(7 downto 0);
clk,reset : in std_logic;
load : in std_logic
);
end component;

component counter is
port (clk,reset:in std_logic;
load: out std_logic);
end component;
signal load: std_logic;
component bitreg8_RB
port
(A: in std_logic_vector(7 downto 0);
Q: out std_logic_vector(7 downto 0);
clk,reset : in std_logic;
load : in std_logic
);
end component;

component Amultiplier16
port
( A , B :in std_logic_vector (7 downto 0);
P : out std_logic_vector   (15 downto 0)
);
end component;

component bitreg16_RC
port
(A: in std_logic_vector(15 downto 0);
Q: out std_logic_vector(15 downto 0);
clk,reset : in std_logic;
load : in std_logic
);
end component;

component accumulator16
port
( C :         in std_logic_vector (15 downto 0);
clk , load,reset : in std_logic;
D :        out std_logic_vector(24 downto 0)

);
end component;

signal QA ,QB :std_logic_vector(7 downto 0);
signal QC ,p:std_logic_vector(15 downto 0);
signal QD : std_logic_vector(24 downto 0);

begin
counterw: counter port map (clk,reset,load);
bitreg8RA :bitreg8_RA  port map ( A , QA , clk,reset ,load );
bitreg8RB :bitreg8_RB  port map  (B , QB ,Clk,reset ,load);
Amultiplier_16 :Amultiplier16 port map ( QA , QB , p);
bitreg16RC :bitreg16_RC port map (P , QC , clk, reset , load);
accumulator_16 :accumulator16 port map ( QC , clk , Load,reset , QD);
D <= QD;
end multiacc_arch;
