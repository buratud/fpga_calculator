LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MainState IS
	PORT (
		clk, rst, i : IN STD_LOGIC;
		o : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END ENTITY;

ARCHITECTURE behaivioral OF MainState IS
	TYPE state_type IS (S_N, S_O, S_F);
	SIGNAL state : state_type := S_N;
	SIGNAL last : STD_LOGIC := i;
	SIGNAL lastRst : STD_LOGIC := rst;
BEGIN
	PROCESS (clk)
	BEGIN
		IF rst = '0' AND lastRst = '1' THEN
			state <= S_N;
		ELSIF rising_edge(clk) THEN
			CASE state IS
				WHEN S_N =>
					IF i = '0' AND last = '1' THEN
						state <= S_O;
					END IF;
				WHEN S_O =>
					IF i = '0' AND last = '1' THEN
						state <= S_F;
					END IF;
				WHEN S_F =>
					IF i = '0' AND last = '1' THEN
						state <= S_F;
					END IF;
			END CASE;
		END IF;
		lastRst <= rst;
		last <= i;
	END PROCESS;
	WITH state SELECT
		o <= "00" WHEN S_N,
		"01" WHEN S_O,
		"10" WHEN OTHERS;
END ARCHITECTURE;