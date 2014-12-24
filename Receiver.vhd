----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:58:23 12/02/2014 
-- Design Name: 
-- Module Name:    Receiver - ReceiverBehavioral 
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

entity Receiver is
	port(data_in: 	in std_logic;
		clr:	in std_logic;
		clk: 	in std_logic;
		do_rdy: 	out std_logic;
		data_out: out std_logic_vector (11 downto 0));
end Receiver;

architecture ReceiverBehavioral of Receiver is
TYPE     StateType IS (ST_IDLE, ST_DATA_IN, ST_FLUSH);
SIGNAL	state : StateType;

SIGNAL temp_data: STD_LOGIC_VECTOR(13 DOWNTO 0);
--SIGNAL i_cnt: STD_LOGIC_VECTOR(3 DOWNTO 0);

begin

--state
process(clr, clk)
begin
	if (clr = '0') then
		state <= st_idle;
	elsif (clk'event and clk = '1') then
		case state is
			when st_idle =>
				if(temp_data(13) = '0' AND temp_data(0) = '1') then
					state <= st_data_in;
				end if;
			when st_data_in =>
					state <= st_flush;
			when st_flush =>
				state <= st_idle;
		end case;
	end if;
end process;

----i counter
-- PROCESS(clr, clk)
-- BEGIN
--    IF(clr='0') THEN  i_cnt<="0000";
--    ELSIF(clk'EVENT AND clk='1') THEN
--       IF(state=st_data_in) THEN
--         IF(i_cnt="1100") THEN   i_cnt<="0000";
--         ELSE   i_cnt<=i_cnt+1;
--         END IF;
--       END IF;
--    END IF;
-- END PROCESS;
 
--Listening
 PROCESS(clr, clk)
 BEGIN
    IF(clr='0') THEN  
		temp_data <= "11111111111111";
    ELSIF(clk'EVENT AND clk='1') THEN 
		IF (state = st_idle) THEN 
		temp_data(0) <= data_in;
		temp_data(1) <= temp_data(0);
		temp_data(2) <= temp_data(1);
		temp_data(3) <= temp_data(2);
		temp_data(4) <= temp_data(3);
		temp_data(5) <= temp_data(4);
		temp_data(6) <= temp_data(5);
		temp_data(7) <= temp_data(6);
		temp_data(8) <= temp_data(7);
		temp_data(9) <= temp_data(8);
		temp_data(10) <= temp_data(9);
		temp_data(11) <= temp_data(10);
		temp_data(12) <= temp_data(11);
		temp_data(13) <= temp_data(12);
		ELSIF (state = st_flush) THEN 
		temp_data <= "11111111111111";
		END IF;
	 END IF;
 END PROCESS;
 
 --Valid Packet
 PROCESS(clr, clk)
 BEGIN
    IF(clr='0') THEN  
		data_out <= "000000000000";
    ELSIF(clk'EVENT AND clk='1') THEN 

		IF(state = st_data_in) THEN 
		data_out(0) <= temp_data(13);
		data_out(1) <= temp_data(12);
		data_out(2) <= temp_data(11);
		data_out(3) <= temp_data(10);
		data_out(4) <= temp_data(9);
		data_out(5) <= temp_data(8);
		data_out(6) <= temp_data(7);
		data_out(7) <= temp_data(6);
		data_out(8) <= temp_data(5);
		data_out(9) <= temp_data(4);
		data_out(10) <= temp_data(3);
		data_out(11) <= temp_data(2);
		
		END IF;
	 END IF;
 END PROCESS;
 
 --Data out ready
PROCESS(clr, clk)
BEGIN
		IF(clr='0') THEN  
			do_rdy <= '0';
		ELSIF(clk'EVENT AND clk='1') THEN 
			IF(state = st_flush) THEN 
			do_rdy <= '1';
			ELSE
			do_rdy <= '0';
		END IF;
	END IF;
END PROCESS;

end ReceiverBehavioral;

