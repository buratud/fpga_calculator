LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.YAY.ALL;

ENTITY Calculator IS
	GENERIC (N : INTEGER := 5);
	PORT (
		clk, rst, trig : IN STD_LOGIC;
		a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		o : OUT digits(5 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE flow OF Calculator IS
	SIGNAL state : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL a_n, b_n : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
	SIGNAL d, s : bcds(5 DOWNTO 0);
BEGIN
	main_state : ENTITY work.MainState(behaivioral)
		PORT MAP(
			clk => clk,
			rst => NOT rst,
			i => NOT trig,
			o => state
		);
	num_register : ENTITY work.SelectNum(flow)
		PORT MAP(
			a_i => a,
			b_i => b,
			a_o => a_n,
			b_o => b_n,
			state => state
		);
	convertor_a : ENTITY work.NumberConvertor(flow)
		GENERIC MAP(N)
		PORT MAP(
			i => a_n,
			o_0 => d(3),
			o_1 => d(4),
			o_sign => d(5));
	convertor_b : ENTITY work.NumberConvertor(flow)
		GENERIC MAP(N)
		PORT MAP(
			i => b_n,
			o_0 => d(0),
			o_1 => d(1),
			o_sign => d(2)
		);
	multiplexer : FOR i IN 0 TO 5 GENERATE
		multiplexer : ENTITY work.BcdMultiplexer4To1(selector) PORT MAP(state, d(i), "0000", "0000", "0000", s(i));
	END GENERATE;
	digit : FOR i IN 0 TO 5 GENERATE
		digit : ENTITY work.BcdTo7SegmentNumber(letter) PORT MAP(clk, s(i), o(i));
	END GENERATE;
END ARCHITECTURE;