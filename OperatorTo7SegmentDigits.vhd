LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY OperatorTo7SegmentDigits IS
    PORT (
        i : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        o5, o4, o3, o2, o1, o0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE flow OF OperatorTo7SegmentDigits IS
BEGIN
    o5 <= "1111";
    o4 <= "1111";
    o3 <= "1111";
    WITH i SELECT o2 <=
        "0000" WHEN "11",
        "0110" WHEN "10",
        "0101" WHEN "01",
        "0010" WHEN "00";
    WITH i SELECT o1 <=
        "0010" WHEN "11",
        "0111" WHEN "10",
        "0111" WHEN "01",
        "0011" WHEN "00";
    WITH i SELECT o0 <=
        "0010" WHEN "11",
        "0001" WHEN "10",
        "0100" WHEN "01",
        "1000" WHEN "00";
END ARCHITECTURE;