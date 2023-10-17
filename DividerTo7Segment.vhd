LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DividerTo7Segment IS
    GENERIC (N : INTEGER := 5);
    PORT (
        clk, rst, trig : IN STD_LOGIC;
        a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        done, s_mode : OUT STD_LOGIC;
        d5, d4, d3, d2, d1, d0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE structural OF DividerTo7Segment IS
    SIGNAL quotient, remainder : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL err, overflow : STD_LOGIC;
    SIGNAL td5, td4, td3, td2, td1, td0 : STD_LOGIC_VECTOR(0 TO 6);
BEGIN
    divider : ENTITY work.Divider(behavioral) GENERIC MAP(N) PORT MAP(clk => clk, rst => rst, trig => trig,
        dividend => a, divisor => b, quotient => quotient, remainder_v2 => remainder,
        done => done, e => err, v => overflow);
    div_conv : ENTITY work.BcdTo7SegmentForDivider(behaivioral) GENERIC MAP(N) PORT MAP(clk => clk, q => quotient, r => remainder, e => err, v => overflow,
        o5 => d5, o4 => d4, o3 => d3, o2 => d2, o1 => d1, o0 => d0);
    s_mode <= err OR overflow;
END ARCHITECTURE;