LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY AdderSubtractor IS
    GENERIC (N : INTEGER := 5);
    PORT (
        a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        m, clk : IN STD_LOGIC;
        d5, d4, d3, d2, d1, d0 : OUT STD_LOGIC_VECTOR(0 TO 6));
END AdderSubtractor;

ARCHITECTURE structural OF AdderSubtractor IS
    SIGNAL overflow : STD_LOGIC;
    SIGNAL sum : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL bcd_digit_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL bcd_digit_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL bcd_sign : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
    d5 <= "1111111";
    d4 <= "1111111";
    d3 <= "1111111";
    adder : ENTITY work.FullAdderGenerator(structural)
        GENERIC MAP(N => N)
        PORT MAP(a => a, b => b, m => m, s => sum, v => overflow);

    convertor : ENTITY work.BcdTo7SegmentDigits(flow)
        GENERIC MAP(N)
        PORT MAP(
            i => sum,
            v => overflow,
            o_sign => bcd_sign,
            o_1 => bcd_digit_1,
            o_0 => bcd_digit_0);
    led_digit_1 : ENTITY work.BcdTo7Segment(number) PORT MAP (
        i => bcd_digit_1,
        clk => clk,
        o => d1);
    led_digit_0 : ENTITY work.BcdTo7Segment(number) PORT MAP (
        i => bcd_digit_0,
        clk => clk,
        o => d0);
    led_sign : ENTITY work.BcdTo7Segment(number) PORT MAP (
        i => bcd_sign,
        clk => clk,
        o => d2);
END structural;