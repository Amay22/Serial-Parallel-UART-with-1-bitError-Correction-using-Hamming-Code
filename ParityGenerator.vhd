----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:26:25 12/02/2014 
-- Design Name: 
-- Module Name:    ParityGenerator - ParityGeneratorBehavioral 
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

entity ParityGenerator is
port(data_in: 	in std_logic_vector(0 to 7);
		errorbit: 	in std_logic_vector(11 downto 0);
		data_out: 	out std_logic_vector(0 to 11));
end ParityGenerator;

architecture ParityGeneratorBehavioral of ParityGenerator is

signal ham : std_logic_vector(0 to 11);

begin
ham(0) <= ham(2) XOR ham(4) XOR ham(6) XOR ham(8) XOR ham(10);
ham(1) <= ham(2) XOR ham(5) XOR ham(6) XOR ham(9) XOR ham(10);
ham(2) <= data_in(0);
ham(3) <= ham(4) XOR ham(5) XOR ham(6) XOR ham(11);
ham(4) <= data_in(1);
ham(5) <= data_in(2);
ham(6) <= data_in(3);
ham(7) <= ham(8) XOR ham(9) XOR ham(10) XOR ham(11);
ham(8) <= data_in(4);
ham(9) <= data_in(5);
ham(10) <= data_in(6);
ham(11) <= data_in(7);
data_out <= errorbit;
end ParityGeneratorBehavioral;

