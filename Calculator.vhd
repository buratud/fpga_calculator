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
		o : OUT digit
	);
END ENTITY;

ARCHITECTURE flow OF Calculator IS
	SIGNAL state : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL aa, bb : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
	SIGNAL d0, d1, d2, d3, d4, d5 : STD_LOGIC_VECTOR(3 DOWNTO 0);
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
			a_o => aa,
			b_o => bb,
			state => state
		);
	convertor_a : ENTITY work.NumberConvertor(flow)
		GENERIC MAP(N)
		PORT MAP(
			i => aa,
			o_0 => d3,
			o_1 => d4,
			o_sign => d5);
	convertor_b : ENTITY work.NumberConvertor(flow)
		GENERIC MAP(N)
		PORT MAP(
			i => bb,
			o_0 => d0,
			o_1 => d1,
			o_sign => d2
		);
	digit_0 : ENTITY work.BcdTo7SegmentNumber(letter) PORT MAP(clk, d0, o(0));
	digit_1 : ENTITY work.BcdTo7SegmentNumber(number) PORT MAP(clk, d1, o(1));
	digit_2 : ENTITY work.BcdTo7SegmentNumber(number) PORT MAP(clk, d2, o(2));
	digit_3 : ENTITY work.BcdTo7SegmentNumber(number) PORT MAP(clk, d3, o(3));
	digit_4 : ENTITY work.BcdTo7SegmentNumber(number) PORT MAP(clk, d4, o(4));
	digit_5 : ENTITY work.BcdTo7SegmentNumber(number) PORT MAP(clk, d5, o(5));
END ARCHITECTURE;