LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SevenSegmentMultiplexer4To1 IS
    PORT (
        mode : STD_LOGIC_VECTOR(1 DOWNTO 0);
        i0, i1, i2, i3 : IN STD_LOGIC_VECTOR(0 TO 6);
        o : OUT STD_LOGIC_VECTOR(0 TO 6)
    );
END ENTITY;

ARCHITECTURE selector OF SevenSegmentMultiplexer4To1 IS
BEGIN
    multiplexer_4_to_1 : FOR i IN 0 TO 6 GENERATE
        multiplexer_4_to_1 : ENTITY work.Multiplexer4To1(selector) PORT MAP(mode, i0(i) & i1(i) & i2(i) & i3(i), o(i));
    END GENERATE;
END ARCHITECTURE;