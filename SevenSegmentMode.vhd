LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SevenSegmentMode IS
    PORT (
        mainState : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        resultMode : IN STD_LOGIC;
        o : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE selector OF SevenSegmentMode IS
BEGIN
    o <= '0' WHEN mainState = "00" ELSE
        '1' WHEN mainState = "01" ELSE
        resultMode;
END ARCHITECTURE;