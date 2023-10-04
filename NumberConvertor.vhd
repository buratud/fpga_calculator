LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY NumberConvertor IS
    GENERIC (N : INTEGER);
    PORT (
        i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        o_1, o_0, o_sign : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE flow OF NumberConvertor IS
    SIGNAL d1, d0 : INTEGER;
BEGIN
    d1 <= to_integer(unsigned(i(N - 2 DOWNTO 0))) / 10;
    d0 <= to_integer(unsigned(i(N - 2 DOWNTO 0))) MOD 10;
    o_1 <= STD_LOGIC_VECTOR(to_unsigned(d1, o_1'length));
    o_0 <= STD_LOGIC_VECTOR(to_unsigned(d0, o_0'length));
    o_sign <= "1011" WHEN i(N - 1) = '0' ELSE
        "1010";
END ARCHITECTURE;