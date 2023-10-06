LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Multiplexer4To1 IS
    PORT (
        mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        i : IN STD_LOGIC_VECTOR(0 TO 3);
        o : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE selector OF Multiplexer4To1 IS
BEGIN
    WITH mode SELECT
        o <= i(0) WHEN "00",
        i(1) WHEN "01",
        i(2) WHEN "10",
        i(3) WHEN OTHERS;
END ARCHITECTURE;