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
BEGIN
	PROCESS (rst, i)
	BEGIN
		IF rst = '1' THEN
			state <= S_N;
		ELSIF falling_edge(i) THEN
			CASE state IS
				WHEN S_N =>
					state <= S_O;
				WHEN S_O =>
					state <= S_F;
				WHEN S_F =>
					state <= S_F;
			END CASE;
		END IF;
	END PROCESS;
	WITH state SELECT
		o <= "00" WHEN S_N,
		"01" WHEN S_O,
		"10" WHEN OTHERS;
END ARCHITECTURE;