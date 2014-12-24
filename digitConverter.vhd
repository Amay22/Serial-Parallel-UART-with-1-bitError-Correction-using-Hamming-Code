----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:25 11/10/2014 
-- Design Name: 
-- Module Name:    digitConverter - digitConverterBehavioral 
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity digitConverter is
port (
    digitIn : in std_logic_vector(0 to 3);
    digitOut : out std_logic_vector(0 to 6)
    );
end digitConverter;

architecture digitConverterBehavioral of digitConverter is

    -- ROM type, 16 entires 7-bit each
    type ROM is array (0 to 15) of std_logic_vector (0 to 6);
    
    -- ROM constant conversions to 7-seg display (start at 0 end at F)
    -- connect bit 0 to a, 1 to b etc...
    constant conversionTable : ROM := ROM '(
    "0000001",  -- 0
    "1001111",  -- 1
    "0010010",  -- 2
    "0000110",  -- 3
    "1001100",  -- 4
    "0100100",  -- 5
    "0100000",  -- 6
    "0001111",  -- 7
    "0000000",  -- 8
    "0000100",  -- 9
    "0001000",  -- A
    "1100000",  -- B
    "0110001",  -- C
    "1000010",  -- D
    "0110000",  -- E
    "0111000"   -- F
    );

begin
    process (digitIn)
                
    begin
        digitOut <= conversionTable(conv_integer(digitIn));
    end process;
	 
end digitConverterBehavioral;

