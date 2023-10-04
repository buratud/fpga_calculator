LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SignDetecter IS
    GENERIC (
        N : INTEGER := 5
    );
    PORT (
        i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        o : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE structural OF SignDetecter IS
    SIGNAL zeros : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL complemented : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN
    adder : ENTITY work.FullAdderGenerator(structural) GENERIC MAP (N)
        PORT MAP(
            a => zeros,
            b => i,
            m => '1',
            s => complemented
        );
    WITH i(N - 1) SELECT
    o <= i WHEN '0',
        complemented WHEN OTHERS;
END ARCHITECTURE;