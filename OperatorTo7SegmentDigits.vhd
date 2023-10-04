LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.YAY.ALL;

ENTITY OperatorTo7SegmentDigits IS
    PORT (
        i : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        o : OUT bcds(5 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE flow OF OperatorTo7SegmentDigits IS
BEGIN
    blank: FOR j IN 5 DOWNTO 3 GENERATE
        o(j) <= "1111";
    END GENERATE;
    WITH i SELECT o(2) <=
        "0000" WHEN "11",
        "0110" WHEN "10",
        "0101" WHEN "01",
        "0010" WHEN "00";
    WITH i SELECT o(1) <=
        "0010" WHEN "11",
        "0111" WHEN "10",
        "0111" WHEN "01",
        "0011" WHEN "00";
    WITH i SELECT o(0) <=
        "0010" WHEN "11",
        "0001" WHEN "10",
        "0100" WHEN "01",
        "1000" WHEN "00";
END ARCHITECTURE;