LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SelectOper IS
    PORT (
        clk : IN STD_LOGIC;
        mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        oper_i : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        oper_o : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE selector OF SelectOper IS

BEGIN
    PROCESS (clk)
    BEGIN
        IF mode = "01" THEN
            oper_o <= oper_i;
        END IF;
    END PROCESS;
END ARCHITECTURE;