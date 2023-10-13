LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY AdderSubtractor IS
    GENERIC (N : INTEGER := 5);
    PORT (
        a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        m, clk : IN STD_LOGIC;
        d5, d4, d3, d2, d1, d0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_mode : OUT STD_LOGIC);
END AdderSubtractor;

ARCHITECTURE structural OF AdderSubtractor IS
    SIGNAL overflow : STD_LOGIC;
    SIGNAL sum : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL bcd_digit_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL bcd_digit_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL bcd_sign : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
    d5 <= "1111";
    d4 <= "1111";
    d3 <= "1111";
    adder : ENTITY work.FullAdderGenerator(structural)
        GENERIC MAP(N => N)
        PORT MAP(a => a, b => b, m => m, s => sum, v => overflow);
    convertor : ENTITY work.BcdTo7SegmentDigits(flow)
        GENERIC MAP(N)
        PORT MAP(i => sum, v => overflow, o_sign => d2, o_1 => d1, o_0 => d0);
    s_mode <= overflow;
END structural;