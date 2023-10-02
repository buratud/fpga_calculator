LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY NumberConvertor IS
    GENERIC (N : INTEGER);
    PORT (
        i : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        o_1, o_0, o_sign : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
END ENTITY;

architecture flow of NumberConvertor is
signal d1, d0 : INTEGER;

begin
    d1 <= to_integer(unsigned(i(N-2 downto 0))) / 10;
    d0 <= to_integer(unsigned(i(N-2 downto 0))) mod 10;
    o_1 <= std_logic_vector(to_unsigned(d1, o_1'length));
    o_0 <= std_logic_vector(to_unsigned(d0, o_0'length));
    o_sign <= "1011" when i(N-1) = '0' else "1010";
end architecture;