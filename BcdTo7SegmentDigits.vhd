LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY BcdTo7SegmentDigits IS
    GENERIC (N : INTEGER);
    PORT (
        i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        v : IN STD_LOGIC := '0';
        o_1, o_0, o_sign : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE flow OF BcdTo7SegmentDigits IS
    SIGNAL d1, d0 : INTEGER;
    SIGNAL neutralized : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN
    complementer : ENTITY work.SignDetecter(structural) GENERIC MAP(N) PORT MAP(i, neutralized);
    d1 <= to_integer(unsigned(neutralized)) / 10;
    d0 <= to_integer(unsigned(neutralized)) MOD 10;
    o_1 <= STD_LOGIC_VECTOR(to_unsigned(d1, 4)) WHEN v = '0' ELSE
        "1010";
    o_0 <= STD_LOGIC_VECTOR(to_unsigned(d0, 4)) WHEN v = '0' ELSE
        "1010";
    o_sign <= "1010" WHEN v = '1' ELSE
        "1010" WHEN i(N - 1) = '0' ELSE
        "1011";
END ARCHITECTURE;