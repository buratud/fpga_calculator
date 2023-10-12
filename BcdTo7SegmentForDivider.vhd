LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.YAY.ALL;

ENTITY BcdTo7SegmentForDivider IS
    GENERIC (
        N : INTEGER := 5
    );
    PORT (
        clk : IN STD_LOGIC;
        q, r : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        e, v : IN STD_LOGIC;
        o5, o4, o3, o2, o1, o0 : OUT STD_LOGIC_VECTOR(0 TO 6)
    );
END ENTITY;

ARCHITECTURE behaivioral OF BcdTo7SegmentForDivider IS
    SIGNAL temp7SegBcd : bcds(5 DOWNTO 0);
    SIGNAL temp7SegDigit : digits(5 DOWNTO 0);
BEGIN
    digit_quotient : ENTITY work.BcdTo7SegmentDigits(flow) GENERIC MAP(N) PORT MAP(i => q, v => '0', o_sign => temp7SegBcd(5), o_1 => temp7SegBcd(4), o_0 => temp7SegBcd(3));
    digit_remainder : ENTITY work.BcdTo7SegmentDigits(flow) GENERIC MAP(N) PORT MAP(i => r, v => '0', o_sign => temp7SegBcd(2), o_1 => temp7SegBcd(1), o_0 => temp7SegBcd(0));
    bcd_to_7_segment_converter : FOR i IN 0 TO 5 GENERATE
        converter : ENTITY work.BcdTo7Segment(number) PORT MAP(clk, temp7SegBcd(i), temp7SegDigit(i));
    END GENERATE;
    PROCESS (clk)
    BEGIN
        IF e = '1' THEN
            o5 <= "1111111";
            o4 <= "1111111";
            o3 <= "1111111";
            o2 <= "0110000";
            o1 <= "0011001";
            o0 <= "0011001";
        ELSIF v = '1' THEN
            o5 <= "1111111";
            o4 <= "1111111";
            o3 <= "1111111";
            o2 <= "0111000";
            o1 <= "0111000";
            o0 <= "0111000";
        ELSE
            o5 <= temp7SegDigit(5);
            o4 <= temp7SegDigit(4);
            o3 <= temp7SegDigit(3);
            o2 <= temp7SegDigit(2);
            o1 <= temp7SegDigit(1);
            o0 <= temp7SegDigit(0);
        END IF;
    END PROCESS;
END ARCHITECTURE;