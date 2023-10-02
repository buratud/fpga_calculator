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
	PROCESS (clk, rst)
	BEGIN
		IF rst = '0' THEN
			state <= S_N;
		ELSIF rising_edge(clk) THEN
			CASE state IS
				WHEN S_N =>
					IF (i = '0') THEN
						o <= "00";
					ELSE
						state <= S_O;
					END IF;
				WHEN S_O =>
					IF (i = '0') THEN
						o <= "01";
					ELSE
						state <= S_F;
					END IF;
				WHEN S_F =>
					IF (i = '0') THEN
						o <= "10";
					ELSE
						state <= S_F;
					END IF;
			END CASE;
		END IF;
	END PROCESS;
END ARCHITECTURE;