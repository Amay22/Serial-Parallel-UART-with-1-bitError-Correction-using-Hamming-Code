----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:42:41 12/03/2014 
-- Design Name: 
-- Module Name:    ProjectTop - ProjectTopBehavioral 
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

entity ProjectTop is
	port(data_in: 	in std_logic_vector(7 downto 0);
		input_valid: in std_logic;
		errorbit: 	in std_logic_vector(11 downto 0);
		clr:	in std_logic;
		clk: 	in std_logic;
		data_out: out std_logic_vector (7 downto 0);
		error: 	out std_logic;
		transmit_led: out std_logic_vector (7 downto 0)
		);
end ProjectTop;

architecture ProjectTopBehavioral of ProjectTop is

	     -- Encoder components
	component ParityGenerator is
	port(data_in: 	in std_logic_vector(0 to 7);
		errorbit: 	in std_logic_vector(11 downto 0);
		data_out: 	out std_logic_vector(0 to 11));
	end component ParityGenerator;
	
	     -- Transmitter components
	component Transmitter is
	port(data_in: 	in std_logic_vector(11 downto 0);
		input_valid: in std_logic;
		clr:	in std_logic;
		clk: 	in std_logic;
		transmit_led: out std_logic_vector (7 downto 0);
		txd: 	out std_logic);
	end component Transmitter;
	
	    -- Receiver components
    component Receiver is
	port(data_in: 	in std_logic;
		clr:	in std_logic;
		clk: 	in std_logic;
		do_rdy: 	out std_logic;
		data_out: out std_logic_vector (11 downto 0));
    end component Receiver;
	 
	    -- ECC components
    component ECC is
	port(data_in: 	in std_logic_vector(0 to 11);
		di_vld:	in std_logic;
		clr:	in std_logic;
		clk: 	in std_logic;
		error: 	out std_logic;
		data_out: 	out std_logic_vector(0 to 7)
		);
    end component ECC;
	 
signal tx_data: std_logic;
signal en_data: std_logic_vector (0 to 11);
signal ecc_data: std_logic_vector (0 to 11);
signal di_flag: std_logic;

begin

encode: ParityGenerator port map (data_in => data_in, data_out => en_data, errorbit => errorbit);
												
txd: Transmitter port map (clk => clk, clr => clr, data_in => en_data, input_valid => input_valid, transmit_led => transmit_led, txd => tx_data);

rxd: Receiver port map (clk => clk, clr => clr, data_in => tx_data, data_out => ecc_data, do_rdy => di_flag);

errorcc: ECC port map (clk => clk, clr => clr,  data_in => ecc_data, di_vld => di_flag, error => error, data_out => data_out);

end ProjectTopBehavioral;

