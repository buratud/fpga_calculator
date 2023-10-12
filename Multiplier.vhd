LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Multiplier IS

    GENERIC (N : INTEGER := 5);
    PORT (
        clk, rst, trig : IN STD_LOGIC;
        a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
        done : OUT STD_LOGIC;
        d5, d4, d3, d2, d1, d0 : OUT STD_LOGIC_VECTOR(0 TO 6)
    );
END ENTITY;

ARCHITECTURE structural OF Multiplier IS
    SIGNAL result : STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0);
    SIGNAL td3, td2, td1, td0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
    d5 <= "1111111";
    d4 <= "1111111";
    multiplicator : ENTITY work.Multiplicator(behavioral) GENERIC MAP (N)
        PORT MAP(clk => clk, rst => rst, trig => trig, a => a, b => b, o => result, done => done);
    converter : ENTITY work.BcdTo7Segment3D1S(flow) GENERIC MAP(2 * N)
        PORT MAP(i => result, o_sign => td3, o_2 => td2, o_1 => td1, o_0 => td0);
    cd3 : ENTITY work.BcdTo7Segment(number) PORT MAP(clk => clk, i => td3, o => d3);
    cd2 : ENTITY work.BcdTo7Segment(number) PORT MAP(clk => clk, i => td2, o => d2);
    cd1 : ENTITY work.BcdTo7Segment(number) PORT MAP(clk => clk, i => td1, o => d1);
    cd0 : ENTITY work.BcdTo7Segment(number) PORT MAP(clk => clk, i => td0, o => d0);
END ARCHITECTURE;