LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Multiplier IS

    GENERIC (N : INTEGER := 5);
    PORT (
        clk, rst, trig : IN STD_LOGIC;
        a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
        done : OUT STD_LOGIC;
        d5, d4, d3, d2, d1, d0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE structural OF Multiplier IS
    SIGNAL result : STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0);
BEGIN
    d5 <= "1010";
    d4 <= "1010";
    multiplicator : ENTITY work.Multiplicator(behavioral) GENERIC MAP (N)
        PORT MAP(clk => clk, rst => rst, trig => trig, a => a, b => b, o => result, done => done);
    converter : ENTITY work.BcdTo7Segment3D1S(flow) GENERIC MAP(2 * N)
        PORT MAP(i => result, o_sign => d3, o_2 => d2, o_1 => d1, o_0 => d0);
END ARCHITECTURE;