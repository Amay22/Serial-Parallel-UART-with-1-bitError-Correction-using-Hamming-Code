----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:56:42 12/01/2014 
-- Design Name: 
-- Module Name:    Transmitter - TransmitterBehavioral 
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

entity Transmitter is
	port(data_in: 	in std_logic_vector(11 downto 0);
		input_valid: in std_logic;
		clr:	in std_logic;
		clk: 	in std_logic;
		transmit_led: out std_logic_vector (7 downto 0);
		txd: 	out std_logic);
end Transmitter;

architecture TransmitterBehavioral of Transmitter is
TYPE     StateType IS (ST_IDLE, ST_DATA_IN, ST_TRANSMIT);
SIGNAL	state : StateType;

SIGNAL i_cnt: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL temp_data: STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL temp_txd: STD_LOGIC;


SIGNAL		led0:  std_logic;
SIGNAL		led1:  std_logic;
SIGNAL		led2:  std_logic;
SIGNAL		led3:  std_logic;
SIGNAL		led4:  std_logic;
SIGNAL		led5:  std_logic;
SIGNAL		led6:  std_logic;
SIGNAL		led7:  std_logic;  

begin

--state
process(clr, clk)
begin
	if (clr = '0') then
		state <= st_idle;
	elsif (clk'event and clk = '1') then
		case state is
			when st_idle =>
				if(input_valid = '1') then
					state <= st_data_in;
				end if;
			when st_data_in =>
				state <= st_transmit;
			when st_transmit =>
				if (i_cnt = "1100") then
					state <= st_idle;
				end if;
		end case;
	end if;
end process;

--i counter
 PROCESS(clr, clk)
 BEGIN
    IF(clr='0') THEN  i_cnt<="0000";
    ELSIF(clk'EVENT AND clk='1') THEN
       IF(state=st_transmit) THEN
         IF(i_cnt="1100") THEN   i_cnt<="0000";
         ELSE   i_cnt<=i_cnt+1;
         END IF;
       END IF;
    END IF;
 END PROCESS;
 

process(clr, clk)
begin
	if(clr = '0') then
		temp_data <= "1111111111111";
		
	elsif (clk'event and clk ='1') then
		if (state = st_data_in) then
			temp_data <= data_in & '0';
			
		else
		temp_data(0) <= temp_data(1);
		temp_data(1) <= temp_data(2);
		temp_data(2) <= temp_data(3);
		temp_data(3) <= temp_data(4);
		temp_data(4) <= temp_data(5);
		temp_data(5) <= temp_data(6);
		temp_data(6) <= temp_data(7);
		temp_data(7) <= temp_data(8);
		temp_data(8) <= temp_data(9);
		temp_data(9) <= temp_data(10);
		temp_data(10) <= temp_data(11);
		temp_data(11) <= temp_data(12);
		temp_data(12) <= '1';
		
		end if;
	end if;
end process;

txd <= temp_data(0);
temp_txd <= temp_data(0);

--transmitting data led
process(clr, clk)
begin
	if(clr = '0') then
	
		led0 <= '1';
		led1 <= '1';
		led2 <= '1';
		led3 <= '1';
		led4 <= '1';
		led5 <= '1';
		led6 <= '1';
		led7 <= '1';	
		
	elsif (clk'event and clk ='1') then
	
		led0 <= temp_txd;
		led1 <= led0;
		led2 <= led1;
		led3 <= led2;
		led4 <= led3;
		led5 <= led4;
		led6 <= led5;
		led7 <= led6;
		
	end if;
end process;

transmit_led <= led0 & led1 & led2 & led3 & led4 & led5 & led6 & led7;	

end TransmitterBehavioral;

