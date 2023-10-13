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
        o5, o4, o3, o2, o1, o0 : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
END ENTITY;

ARCHITECTURE behaivioral OF BcdTo7SegmentForDivider IS
    SIGNAL temp7SegBcd : bcds(5 DOWNTO 0);
BEGIN
    digit_quotient : ENTITY work.BcdTo7SegmentDigits(flow) GENERIC MAP(N) PORT MAP(i => q, v => '0', o_sign => temp7SegBcd(5), o_1 => temp7SegBcd(4), o_0 => temp7SegBcd(3));
    digit_remainder : ENTITY work.BcdTo7SegmentDigits(flow) GENERIC MAP(N) PORT MAP(i => r, v => '0', o_sign => temp7SegBcd(2), o_1 => temp7SegBcd(1), o_0 => temp7SegBcd(0));
    PROCESS (clk)
    BEGIN
        IF e = '1' THEN
            o5 <= "1111";
            o4 <= "1111";
            o3 <= "1111";
            o2 <= "1111";
            o1 <= "1111";
            o0 <= "1111";
        ELSIF v = '1' THEN
            o5 <= "1111";
            o4 <= "1111";
            o3 <= "1111";
            o2 <= "1111";
            o1 <= "1111";
            o0 <= "1111";
        ELSE
            o5 <= temp7SegBcd(5);
            o4 <= temp7SegBcd(4);
            o3 <= temp7SegBcd(3);
            o2 <= temp7SegBcd(2);
            o1 <= temp7SegBcd(1);
            o0 <= temp7SegBcd(0);
        END IF;
    END PROCESS;
END ARCHITECTURE;