LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Multiplicator IS
    GENERIC (N : INTEGER := 5);
    PORT (
        clk, rst, trig : IN STD_LOGIC;
        a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
        o : OUT STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0) := (OTHERS => '0');
        done : OUT STD_LOGIC := '0');
END ENTITY;

ARCHITECTURE behavioral OF Multiplicator IS
    TYPE state_type IS (s0, s1, s2);
    SIGNAL da, cp : STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL db : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dp : STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL bit_counter : INTEGER := 0;
    SIGNAL state : state_type := S0;
    SIGNAL ca, cb : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL isNegative : STD_LOGIC;
BEGIN
    neutralized_a : ENTITY work.SignDetecter(structural) GENERIC MAP(N) PORT MAP (a, ca);
    neutralized_b : ENTITY work.SignDetecter(structural) GENERIC MAP(N) PORT MAP (b, cb);
    complemented_p : ENTITY work.Complementer(structural) GENERIC MAP(2 * N) PORT MAP (dp, cp);
    isNegative <= a(a'high) XOR b(b'high);
    PROCESS (clk)
    BEGIN
        IF rst = '1' THEN
            state <= s0;
        ELSIF rising_edge(clk) THEN
            CASE state IS
                WHEN s0 =>
                    IF trig = '1' THEN
                        da (N - 1 DOWNTO 0) <= ca;
                        db <= cb;
                        state <= S1;
                    ELSE
                        da <= (OTHERS => '0');
                        db <= (OTHERS => '0');
                        dp <= (OTHERS => '0');
                        done <= '0';
                        state <= S0;
                        done <= '0';
                        bit_counter <= 0;
                    END IF;
                WHEN S1 =>
                    IF bit_counter <= N THEN
                        state <= S1;
                        IF db(bit_counter) = '1' THEN
                            dp <= dp + da;
                        END IF;
                        da <= STD_LOGIC_VECTOR(shift_left(unsigned(da), 1));
                        IF isNegative = '0' THEN
                            o <= dp;
                        ELSE
                            o <= cp;
                        END IF;
                        bit_counter <= (bit_counter + 1);
                    ELSE
                        state <= S2;
                        done <= '1';
                    END IF;
                WHEN OTHERS =>
                    done <= '1';
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE;