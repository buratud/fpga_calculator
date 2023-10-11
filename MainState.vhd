LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MainState IS
	PORT (
		clk, rst, i : IN STD_LOGIC;
		o : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END ENTITY;

ARCHITECTURE behaivioral OF MainState IS
	TYPE state_type IS (SN, SO, SF);
	SIGNAL state : state_type := SN;
	SIGNAL last : STD_LOGIC := i;
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			state <= SN;
		ELSIF rising_edge(clk) THEN
			CASE state IS
				WHEN SN =>
					IF i = '0' AND last = '1' THEN
						state <= SO;
					ELSE
						o <= "00";
					END IF;
				WHEN SO =>
					IF i = '0' AND last = '1' THEN
						state <= SF;
					ELSE
						o <= "01";
					END IF;
				WHEN SF =>
					IF i = '0' AND last = '1' THEN
						state <= SF;
					ELSE
						o <= "10";
					END IF;
			END CASE;
			last <= i;
		END IF;
	END PROCESS;
END ARCHITECTURE;