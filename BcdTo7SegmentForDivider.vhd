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
        o : OUT digits(5 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behaivioral OF BcdTo7SegmentForDivider IS
    SIGNAL xdd : bcds(5 DOWNTO 0);
    SIGNAL xdddd : digits(5 DOWNTO 0);
BEGIN
    dsq : ENTITY work.BcdTo7SegmentDigits(flow) GENERIC MAP(N) PORT MAP(i => q, v => '0', o_sign => xdd(5), o_1 => xdd(4), o_0 => xdd(3));
    dsr : ENTITY work.BcdTo7SegmentDigits(flow) GENERIC MAP(N) PORT MAP(i => r, v => '0', o_sign => xdd(2), o_1 => xdd(1), o_0 => xdd(0));
    ddx: FOR i IN 0 TO 5 GENERATE
        xddd : ENTITY work.BcdTo7Segment(number) PORT MAP(clk, xdd(i), xdddd(i));
    END GENERATE;
    PROCESS (clk)
    BEGIN
        IF e = '1' THEN
            o(5) <= "1111111";
            o(4) <= "1111111";
            o(3) <= "1111111";
            o(2) <= "0110000";
            o(1) <= "0011001";
            o(0) <= "0011001";
        ELSIF v = '1' THEN
            o(5) <= "1111111";
            o(4) <= "1111111";
            o(3) <= "1111111";
            o(2) <= "0111000";
            o(1) <= "0111000";
            o(0) <= "0111000";
        ELSE
            o(5) <= xdddd(5);
            o(4) <= xdddd(4);
            o(3) <= xdddd(3);
            o(2) <= xdddd(2);
            o(1) <= xdddd(1);
            o(0) <= xdddd(0);
        END IF;
    END PROCESS;
END ARCHITECTURE;