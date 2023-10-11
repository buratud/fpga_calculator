LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
entity change2NToNbit is
    generic (
        N : INTEGER := 5
    );
    port (
        i  :in std_logic_vector(2* N - 1 downto 0);
        o : out std_logic_vector(N - 1 downto 0)
    );
end entity;

architecture bhv of change2NToNbit is
begin
    o <= std_logic_vector(resize(signed(i), o'length));
end architecture;