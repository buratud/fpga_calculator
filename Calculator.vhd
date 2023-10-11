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
		o5, o4, o3, o2, o1, o0 : OUT STD_LOGIC_VECTOR(0 TO 6);
		done : OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE flow OF Calculator IS
	SIGNAL oper_in, oper : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL state : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL a_n, b_n : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
	SIGNAL mul_res : STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0);
	SIGNAL d, e, mdb : bcds(5 DOWNTO 0);
	SIGNAL s, t, u, v, md : digits(5 DOWNTO 0);
	SIGNAL isSubtract, mul_done ,temp_v,temp_e: STD_LOGIC;
	signal temp_quotient : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	signal temp_remainder :STD_LOGIC_VECTOR(2*N-1 downto 0);
BEGIN
	oper_in <= b(1) & b(0);
	main_state : ENTITY work.MainState(behaivioral)
		PORT MAP(
			clk => clk,
			rst => NOT rst,
			i => NOT trig,
			o => state
		);
	num_register : ENTITY work.SelectNum(flow)
		GENERIC MAP(N)
		PORT MAP(
			clk => clk,
			a_i => a,
			b_i => b,
			a_o => a_n,
			b_o => b_n,
			state => state
		);
	convertor_a : ENTITY work.BcdTo7SegmentDigits(flow)
		GENERIC MAP(N)
		PORT MAP(
			i => a_n,
			o_0 => d(3),
			o_1 => d(4),
			o_sign => d(5));
	convertor_b : ENTITY work.BcdTo7SegmentDigits(flow)
		GENERIC MAP(N)
		PORT MAP(
			i => b_n,
			o_0 => d(0),
			o_1 => d(1),
			o_sign => d(2)
		);
	operator_register : ENTITY work.SelectOper(selector)
		PORT MAP(
			clk => clk,
			mode => state,
			oper_i => oper_in,
			oper_o => oper
		);
	operator_conv : ENTITY work.OperatorTo7SegmentDigits(flow)
		PORT MAP(
			i => oper,
			o5 => e(5),
			o4 => e(4),
			o3 => e(3),
			o2 => e(2),
			o1 => e(1),
			o0 => e(0)
		);
	isSubtract <= '1' WHEN oper = "10" ELSE
		'0';
	adder : ENTITY work.AdderSubtractor(structural) GENERIC MAP (N)
		PORT MAP(a => a_n, b => b_n, m => isSubtract, clk => clk, dsign => u(2), d1 => u(1), d0 => u(0));
	multiplicator : ENTITY work.Multiplicator(behavioral) GENERIC MAP (N) PORT MAP (
		clk => clk, rst => rst, trig => (NOT state(1)) AND state(0),
		a => a_n,
		b => b_n,
		o => mul_res,
		done => mul_done
		);
	

	mul_res_conv : ENTITY work.BcdTo7Segment3D1S(flow) GENERIC MAP(2 * N) PORT MAP(i => mul_res, v => '0', o_sign => mdb(3), o_2 => mdb(2), o_1 => mdb(1), o_0 => mdb(0));
	u(3) <= "1111111";
	u(4) <= "1111111";
	u(5) <= "1111111";
	md(4) <= "1111111";
	md(5) <= "1111111";
	mul_digit_conv : FOR i IN 0 TO 3 GENERATE
		conv : ENTITY work.BcdTo7Segment(number) PORT MAP(clk, mdb(i), md(i));
	END GENERATE;
	multiplexer_operater : FOR i IN 0 TO 5 GENERATE
		multiplexer_operater : ENTITY work.SevenSegmentMultiplexer4To1(selector) PORT MAP(oper, "0000000", md(i), u(i), u(i), v(i));
	END GENERATE;
	digit : FOR i IN 0 TO 5 GENERATE
		digit : ENTITY work.BcdTo7Segment(number) PORT MAP(clk, d(i), s(i));
	END GENERATE;
	letter : FOR i IN 0 TO 5 GENERATE
		letter : ENTITY work.BcdTo7Segment(letter) PORT MAP(clk, e(i), t(i));
	END GENERATE;
		multiplexer_0 : ENTITY work.SevenSegmentMultiplexer4To1(selector) PORT MAP(state, s(0), t(0), v(0), "1111111", o0);
		multiplexer_1 : ENTITY work.SevenSegmentMultiplexer4To1(selector) PORT MAP(state, s(1), t(1), v(1), "1111111", o1);
		multiplexer_2 : ENTITY work.SevenSegmentMultiplexer4To1(selector) PORT MAP(state, s(2), t(2), v(2), "1111111", o2);
		multiplexer_3 : ENTITY work.SevenSegmentMultiplexer4To1(selector) PORT MAP(state, s(3), t(3), v(3), "1111111", o3);
		multiplexer_4 : ENTITY work.SevenSegmentMultiplexer4To1(selector) PORT MAP(state, s(4), t(4), v(4), "1111111", o4);
		multiplexer_5 : ENTITY work.SevenSegmentMultiplexer4To1(selector) PORT MAP(state, s(5), t(5), v(5), "1111111", o5);
	done <= '1' WHEN state = "10" ELSE
		'0';
END ARCHITECTURE;