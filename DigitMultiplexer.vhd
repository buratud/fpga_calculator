LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.YAY.ALL;

ENTITY DigitMultiplexer IS
    PORT (
        mode : STD_LOGIC_VECTOR(1 DOWNTO 0);
        i0, i1, i2, i3 : IN digit;
        o : OUT digit
    );
END ENTITY;

ARCHITECTURE selector OF DigitMultiplexer IS
BEGIN
    multiplexer_4_to_1 : FOR i IN 0 TO 6 GENERATE
        multiplexer_4_to_1 : ENTITY work.Multiplexer4To1(selector) PORT MAP(mode, i0(i) & i1(i) & i2(i) & i3(i), o(i));
    END GENERATE;
END ARCHITECTURE;