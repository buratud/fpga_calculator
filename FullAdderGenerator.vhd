LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FullAdderGenerator IS
    GENERIC (N : INTEGER := 5);
    PORT (
        a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        m : IN STD_LOGIC;
        s : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        v : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE structural OF FullAdderGenerator IS
    SIGNAL c : STD_LOGIC_VECTOR(N DOWNTO 0);
BEGIN
    c(0) <= m;
    adder : FOR i IN 0 TO N - 1 GENERATE
        adder : ENTITY work.FullAdder(flow)
            PORT MAP(
                x => a(i),
                y => b(i) XOR m,
                cin => c(i),
                s => s(i),
                cout => c(i + 1)
            );
    END GENERATE;
    v <= c(N) XOR c(N - 1);
END ARCHITECTURE;