----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:07 12/03/2014 
-- Design Name: 
-- Module Name:    ECC - ECCBehavioral 
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

entity ECC is
	port(data_in: 	in std_logic_vector(0 to 11);
		di_vld:	in std_logic;
		clr:	in std_logic;
		clk: 	in std_logic;
		error: 	out std_logic;
		data_out: 	out std_logic_vector(0 to 7)
		);
end ECC;

architecture ECCBehavioral of ECC is

TYPE     StateType IS (ST_IDLE, ST_DATAIN, ST_CHECK, ST_ECC, ST_DATAOUT);
SIGNAL	state : StateType;

signal ham : std_logic_vector(0 to 11);
signal parity: std_logic_vector(0 to 3);
signal location: std_logic_vector(0 to 3);
signal temperror: std_logic;

begin
--state
process(clr, clk)
begin
	if (clr = '0') then
		state <= st_idle;
	elsif (clk'event and clk = '1') then
		case state is
			when st_idle =>
				if(di_vld = '1') then
					state <= st_datain;
				end if;
			when st_datain =>
				state <= st_check;
			when st_check =>
				if(temperror = '1') then
				state <= st_ecc;
				else
				state <= st_dataout;
				end if;
			when st_ecc =>
				state <= st_dataout;
			when st_dataout =>
				state <= st_idle;
		end case;
	end if;
end process;

--load data
 PROCESS(clr, clk)
 BEGIN
    IF(clr='0') THEN  
	 ham <= "000000000000";
    ELSIF(clk'EVENT AND clk='1') THEN
       IF(state=st_datain) THEN
			ham <= data_in;
		ELSIF(state=st_ecc) THEN
			ham(conv_integer(location(3) & location(2) & location(1) & location(0))-1) <= NOT (ham(conv_integer(location(3) & location(2) & location(1) & location(0))-1));
       END IF;
    END IF;
 END PROCESS;
 
--Compute Parity
parity(0) <= ham(2) XOR ham(4) XOR ham(6) XOR ham(8) XOR ham(10);
parity(1) <= ham(2) XOR ham(5) XOR ham(6) XOR ham(9) XOR ham(10);
parity(2) <= ham(4) XOR ham(5) XOR ham(6) XOR ham(11);
parity(3) <= ham(8) XOR ham(9) XOR ham(10) XOR ham(11);

--Compute Error bit location
location(0) <= parity(0) XOR ham(0);
location(1) <= parity(1) XOR ham(1);
location(2) <= parity(2) XOR ham(3);
location(3) <= parity(3) XOR ham(7);

--error flag
temperror <= location(0) OR location(1) OR location(2) OR location(3);

 --check error flag
 PROCESS(clr, clk)
 BEGIN
     IF(clr='0') THEN  
	 error <= '0';
    ELSIF(clk'EVENT AND clk='1') THEN
       IF(state=st_check) THEN
			error <= temperror;
       END IF;
    END IF;
 END PROCESS;

  --dataout
 PROCESS(clr, clk)
 BEGIN
    IF(clr='0') THEN  
		data_out <= "00000000";
    ELSIF(clk'EVENT AND clk='1') THEN
       IF(state=st_dataout) THEN
				data_out(0) <= ham(2);
				data_out(1) <= ham(4);
				data_out(2) <= ham(5);
				data_out(3) <= ham(6);
				data_out(4) <= ham(8);
				data_out(5) <= ham(9);
				data_out(6) <= ham(10);
				data_out(7) <= ham(11);
       END IF;
    END IF;
 END PROCESS;

end ECCBehavioral;
