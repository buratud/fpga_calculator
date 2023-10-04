LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SelectNum IS
    GENERIC (N : INTEGER := 5);
    PORT (
        clk : IN STD_LOGIC;
        state : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        a_i, b_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        a_o, b_o : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE flow OF SelectNum IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF (state = "00") THEN
            a_o <= a_i;
            b_o <= b_i;
        END IF;
    END PROCESS;
END ARCHITECTURE;