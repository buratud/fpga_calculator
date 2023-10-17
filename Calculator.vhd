LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.UtilType.ALL;

ENTITY Calculator IS
	GENERIC (N : INTEGER := 2);
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
	SIGNAL sd, ob, mdb : bcds(5 DOWNTO 0);
	SIGNAL de, dv, div_done, sa, sdd, sr, s_mode, rdone : STD_LOGIC;
	SIGNAL s, t, ad, v, md, dd, xdd, xddd : bcds(5 DOWNTO 0);
	SIGNAL isSubtract, mul_done, temp_v, temp_e : STD_LOGIC;
	SIGNAL temp_quotient : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
	SIGNAL temp_remainder : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
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
			o_0 => sd(3),
			o_1 => sd(4),
			o_sign => sd(5));
	convertor_b : ENTITY work.BcdTo7SegmentDigits(flow)
		GENERIC MAP(N)
		PORT MAP(
			i => b_n,
			o_0 => sd(0),
			o_1 => sd(1),
			o_sign => sd(2)
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
			o5 => ob(5),
			o4 => ob(4),
			o3 => ob(3),
			o2 => ob(2),
			o1 => ob(1),
			o0 => ob(0)
		);
	isSubtract <= '1' WHEN oper = "10" ELSE
		'0';
	adder : ENTITY work.AdderSubtractor(structural) GENERIC MAP (N)
		PORT MAP(
			a => a_n, b => b_n, m => isSubtract, clk => clk,
			d5 => ad(5), d4 => ad(4), d3 => ad(3), d2 => ad(2), d1 => ad(1), d0 => ad(0), s_mode => sa);
	multiplicator : ENTITY work.Multiplier(structural) GENERIC MAP (N) PORT MAP (
		clk => clk, rst => NOT rst, trig => (NOT state(1)) AND state(0),
		a => a_n,
		b => b_n,
		done => mul_done,
		d5 => md(5), d4 => md(4), d3 => md(3), d2 => md(2), d1 => md(1), d0 => md(0)
		);
	divider : ENTITY work.DividerTo7Segment(structural) GENERIC MAP (N) PORT MAP (
		clk => clk, rst => NOT rst, trig => (NOT state(1)) AND state(0),
		a => a_n,
		b => b_n,
		done => div_done,
		d5 => dd(5),
		d4 => dd(4),
		d3 => dd(3),
		d2 => dd(2),
		d1 => dd(1),
		d0 => dd(0),
		s_mode => sdd
		);
	result_selector : FOR i IN 0 TO 5 GENERATE
		result_selector : ENTITY work.BcdMultiplexer4To1(selector) PORT MAP (oper, dd(i), md(i), ad(i), ad(i), xddd(i));
	END GENERATE;
	main_selector : FOR i IN 0 TO 5 GENERATE
		main_selector : ENTITY work.BcdMultiplexer4To1(selector) PORT MAP (state, sd(i), ob(i), xddd(i), "1111", xdd(i));
	END GENERATE;
	operator_seven_segment_mode : ENTITY work.Multiplexer4To1(selector) PORT MAP (oper, sdd & '0' & sa & sa, sr);
	seven_segment_mode : ENTITY work.SevenSegmentMode(selector) PORT MAP(state, sr, s_mode);
	operator_done : ENTITY work.Multiplexer4To1(selector) PORT MAP (oper, div_done & mul_done & '1' & '1', rdone);
	main_state_done : ENTITY work.Multiplexer4To1(selector) PORT MAP (state, '0' & '0' & rdone & '0', done);
	bcd_to_seven_segment_converter_5 : ENTITY work.BcdTo7Segment(behavioral) PORT MAP (clk, s_mode, xdd(5), o5);
	bcd_to_seven_segment_converter_4 : ENTITY work.BcdTo7Segment(behavioral) PORT MAP (clk, s_mode, xdd(4), o4);
	bcd_to_seven_segment_converter_3 : ENTITY work.BcdTo7Segment(behavioral) PORT MAP (clk, s_mode, xdd(3), o3);
	bcd_to_seven_segment_converter_2 : ENTITY work.BcdTo7Segment(behavioral) PORT MAP (clk, s_mode, xdd(2), o2);
	bcd_to_seven_segment_converter_1 : ENTITY work.BcdTo7Segment(behavioral) PORT MAP (clk, s_mode, xdd(1), o1);
	bcd_to_seven_segment_converter_0 : ENTITY work.BcdTo7Segment(behavioral) PORT MAP (clk, s_mode, xdd(0), o0);
END ARCHITECTURE;