LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY BcdTo7Segment IS
    PORT (
        clk : IN STD_LOGIC;
        i : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        o : OUT STD_LOGIC_VECTOR (0 TO 6));
END ENTITY;

ARCHITECTURE number OF BcdTo7Segment IS
BEGIN
    PROCESS (clk) -- sensitivity list
    BEGIN
        IF clk'event AND clk = '1' THEN
            CASE i IS --abcdefg "1" common-anode
                WHEN "0000" => o <= "0000001"; -- 0
                WHEN "0001" => o <= "1001111"; -- 1
                WHEN "0010" => o <= "0010010"; -- 2
                WHEN "0011" => o <= "0000110"; -- 3
                WHEN "0100" => o <= "1001100"; -- 4 
                WHEN "0101" => o <= "0100100"; -- 5
                WHEN "0110" => o <= "0100000"; -- 6
                WHEN "0111" => o <= "0001111"; -- 7
                WHEN "1000" => o <= "0000000"; -- 8
                WHEN "1001" => o <= "0000100"; -- 9
                WHEN "1010" => o <= "1111111"; -- none
                WHEN "1011" => o <= "1111110"; -- - (negative)
                WHEN OTHERS => o <= "0111000"; -- F     
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE;

ARCHITECTURE letter OF BcdTo7Segment IS
BEGIN
    PROCESS (clk) -- sensitivity list
    BEGIN
        IF clk'event AND clk = '1' THEN
            -- ADD, SUB, MUL, DIV
            -- 'A', 'B', 'D', 'I', 'L', 'M', 'S', 'U', 'V'
            CASE i IS --abcdefg "1" common-anode
                WHEN "0000" => o <= "0001000"; -- A
                WHEN "0001" => o <= "1100000"; -- B
                WHEN "0010" => o <= "1000010"; -- D
                WHEN "0011" => o <= "1111001"; -- I
                WHEN "0100" => o <= "1110001"; -- L 
                WHEN "0101" => o <= "0101011"; -- M
                WHEN "0110" => o <= "0100100"; -- S
                WHEN "0111" => o <= "1000001"; -- U
                WHEN "1000" => o <= "1000101"; -- V
                WHEN "1001" => o <= "0011001"; -- R
                WHEN "1010" => o <= "0111000"; -- F
                WHEN OTHERS => o <= "1111111"; -- none
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE;