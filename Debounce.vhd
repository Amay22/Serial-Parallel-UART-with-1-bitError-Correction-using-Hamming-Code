----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:24:11 12/10/2014 
-- Design Name: 
-- Module Name:    Debounce - DebounceBehavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; --use CONV_INTEGER

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Debounce is
	port(
		clr: in std_logic;
		clock:  in std_logic;
		clk_out: out std_logic
		);
end Debounce;

architecture DebounceBehavioral of Debounce is

signal clk_divider : std_logic_vector (25 downto 0);

begin

 --i counter
 PROCESS(clk_divider,clock)
 BEGIN
	IF(clr ='0') THEN
	clk_out <= '0';
	clk_divider <= X"000000" & "00";
	ELSIF(clock'EVENT AND clock='1') THEN					
				clk_divider <= clk_divider + '1';
	END IF;
	clk_out <= clk_divider(25);
 END PROCESS;
 
----i counter
-- PROCESS(clr,tmpclk)
-- BEGIN
--		IF(clr = '0') THEN
--			temp <= X"00000000";
--		ELSIF(tmpclk'EVENT AND tmpclk='1') THEN
--		
--			temp(0) <= temp(1);
--			temp(1) <= temp(2);
--			temp(2) <= temp(3);
--			temp(3) <= temp(4);
--			temp(4) <= temp(5);
--			temp(5) <= temp(6);
--			temp(6) <= temp(7);
--			temp(7) <= temp(8);
--			temp(8) <= temp(9);
--			temp(9) <= temp(10);
--			temp(10) <= temp(11);
--			temp(11) <= temp(12);
--			temp(12) <= temp(13);
--			temp(13) <= temp(14);
--			temp(14) <= temp(15);
--			temp(15) <= temp(16);
--			temp(16) <= temp(17);
--			temp(17) <= temp(18);
--			temp(18) <= temp(19);
--			temp(19) <= temp(20);
--			temp(20) <= temp(21);
--			temp(21) <= temp(22);
--			temp(22) <= temp(23);
--			temp(23) <= temp(24);
--			temp(24) <= temp(25);
--			temp(25) <= temp(26);
--			temp(26) <= temp(27);
--			temp(27) <= temp(28);
--			temp(28) <= temp(29);
--			temp(29) <= temp(30);
--			temp(30) <= temp(31);
--			temp(31) <= clk_in;
--
--		END IF;
-- END PROCESS;
--
-- --i counter
-- PROCESS(clr,tmpclk)
-- BEGIN
-- 		IF(clr = '0') THEN
--			clk_out <= '0';
--		ELSIF(tmpclk'EVENT AND tmpclk='1') THEN					
--			IF(temp = X"FFFFFFFF") THEN
--			clk_out <= '1';
--			ELSIF(temp = X"00000000") THEN
--			clk_out <= '0';
--			END IF;
--		END IF;
-- END PROCESS;
 
end DebounceBehavioral;

