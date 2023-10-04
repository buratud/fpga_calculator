LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FullAdder IS
	PORT (
		x, y, cin : IN STD_LOGIC;
		s, cout : OUT STD_LOGIC);
END FullAdder;

ARCHITECTURE flow OF FullAdder IS
BEGIN
	s <= (x XOR y) XOR cin;
	cout <= (x AND y) OR (cin AND (x XOR y));
END flow;