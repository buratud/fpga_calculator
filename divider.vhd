LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY Divider IS
    GENERIC (N : INTEGER := 5);
    PORT (
        clk, rst, trig : IN STD_LOGIC;
        dividend, divisor : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        quotient : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
        remainder : OUT STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0) := (OTHERS => '0'); -- not send 
        done, e, v : OUT STD_LOGIC;
        remainder_v2 : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0'));

END ENTITY;

ARCHITECTURE behavioral OF Divider IS
    TYPE state_type IS (SI, SO, SD);
    SIGNAL state : state_type := SI;
    SIGNAL ndd, ndv : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tr, td, trr : STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0);
    SIGNAL tz : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tq, tqq, cq : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ts : STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL bit_counter : INTEGER := 0;
    SIGNAL max_neg : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (N - 1 => '1', OTHERS => '0');
    SIGNAL ones : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '1');
    SIGNAL one : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (0 => '1', OTHERS => '0');
    SIGNAL isNeg : STD_LOGIC;
BEGIN
    subtractor : ENTITY work.FullAdderGenerator(structural) GENERIC MAP (2 * N) PORT MAP(tr, td, '1', ts);
    n1 : ENTITY work.SignDetecter(structural) GENERIC MAP(N) PORT MAP(dividend, ndd);
    n2 : ENTITY work.SignDetecter(structural) GENERIC MAP(N) PORT MAP(divisor, ndv);
    n3 : ENTITY work.FullAdderGenerator(structural) GENERIC MAP (N) PORT MAP(tq, one, '0', tqq);
    n4 : ENTITY work.FullAdderGenerator(structural) GENERIC MAP (2 * N) PORT MAP(tz & divisor, tr, '1', trr);
    n5 : ENTITY work.Complementer(structural) GENERIC MAP(N) PORT MAP(tqq, cq);
    isNeg <= dividend(dividend'high) XOR divisor(divisor'high);
    PROCESS (clk)
    BEGIN
        IF rst = '1' THEN
            state <= SI;
        ELSIF rising_edge(clk) THEN
            CASE state IS
                WHEN SI =>
                    IF trig = '1' THEN
                        tr <= tz & ndd;
                        td <= ndv & tz;
                        state <= SO;
                    ELSE
                        state <= SI;
                        tq <= (OTHERS => '0');
                        done <= '0';
                        e <= '0';
                        v <= '0';
                        bit_counter <= 0;
                    END IF;
                WHEN SO =>
                    IF dividend = max_neg AND divisor = ones THEN
                        v <= '1';
                        state <= SD;
                    ELSIF divisor = tz THEN
                        e <= '1';
                        state <= SD;
                    ELSE
                        IF bit_counter <= N THEN
                            state <= SO;
                            IF ts(ts'high) = '1' THEN
                                tq <= tq(tq'high - 1 DOWNTO 0) & '0';
                            ELSE
                                tr <= ts;
                                tq <= tq(tq'high - 1 DOWNTO 0) & '1';
                            END IF;
                            td <= '0' & td(td'high DOWNTO 1);
                            quotient <= tq;
                            remainder <= tr;
                        ELSE
                            IF isNeg = '1' THEN
                                IF tr /= tz & tz THEN
                                    tq <= NOT(tq);
                                    IF divisor(divisor'high) = '1' THEN
                                        tr <= NOT((tz & ndv) - tr) + '1';
                                    ELSE
                                        tr <= (tz & ndv) - tr;
                                    END IF;
                                ELSE
                                    tq <= NOT(tq) + '1';
                                END IF;
                            ELSIF divisor(divisor'high) = '1' THEN
                                tr <= NOT(tr) + '1';
                            END IF;
                            state <= SD;
                        END IF;
                        bit_counter <= bit_counter + 1;
                    END IF;
                WHEN SD =>
                    quotient <= tq;
                    remainder <= tr;
                    done <= '1';
                    state <= SD;
            END CASE;
        END IF;
    END PROCESS;
    chnage_bit : ENTITY work.change2NToNbit(bhv) GENERIC MAP(N) PORT MAP(i => tr, o => remainder_v2);
END ARCHITECTURE;