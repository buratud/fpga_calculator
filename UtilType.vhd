LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE UtilType IS
        SUBTYPE digit IS STD_LOGIC_VECTOR(0 TO 6);
        TYPE digits IS ARRAY (NATURAL RANGE <>) OF digit;
        SUBTYPE bcd IS STD_LOGIC_VECTOR(3 downto 0);
        TYPE bcds IS ARRAY (NATURAL RANGE <>) of bcd;
END PACKAGE;