----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:13:49 12/04/2014 
-- Design Name: 
-- Module Name:    RC5ENC_TB - RC5ENC_TBBehavioral 
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
USE	IEEE.STD_LOGIC_TEXTIO.ALL;
USE	STD.TEXTIO.ALL;
use work.txt_util.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PTB is
end PTB;

architecture PTBBehavioral of PTB is

 COMPONENT ProjectTop
	port(
		data_in: 	in std_logic_vector(7 downto 0);
		input_valid: in std_logic;
		errorbit: 	in std_logic_vector(11 downto 0);
		clr:	in std_logic;
		clk: 	in std_logic;
		data_out: out std_logic_vector (7 downto 0);
		error: 	out std_logic;
		transmit_led: out std_logic_vector (7 downto 0)
		);
   END COMPONENT;

SIGNAL  		clr: STD_LOGIC;  -- asynchronous reset
SIGNAL  		clock: STD_LOGIC;  -- Clock signal
SIGNAL		data_in: 	 std_logic_vector(7 downto 0);
SIGNAL		input_valid:  std_logic;
SIGNAL		errorbit: 	 std_logic_vector(11 downto 0);
SIGNAL		data_out: std_logic_vector (7 downto 0);
SIGNAL		errorflag: 	 std_logic;
SIGNAL		transmit_led:  std_logic_vector (7 downto 0);

--clock period
constant PERIOD: time := 20 NS;

begin

Proj : ProjectTop PORT MAP (clr => clr, clk => clock, 
										data_in => data_in, errorbit => errorbit, 
										data_out => data_out, input_valid => input_valid,
										error => errorflag, transmit_led => transmit_led);

   -- generate the clock...
   clk_gen: process        
        begin
            loop
                clock <= '0';
                wait for PERIOD / 2;
                clock <= '1';
                wait for PERIOD / 2;
            end loop;
        end process;
		 

readcmd: process
        -- This process loops through a file and reads one line
        -- at a time, parsing the line to get the values and
        -- expected result.

        file cmdfile: TEXT;       -- Define the file 'handle'
        variable L: Line;         -- Define the line buffer
        variable good: boolean; --status of the read operation
		
variable		din: 	 std_logic_vector(7 downto 0);
variable		erb: 	 std_logic_vector(11 downto 0);
variable		output: std_logic_vector (7 downto 0);
variable		er: 	 std_logic;
		 
		     FILE outfile : TEXT IS OUT "C:\EL6493\Sim\project_tb_output.TXT";
			      VARIABLE out_line, my_line : LINE;       
				VARIABLE int_val : INTEGER;    
				VARIABLE timer : INTEGER;    

begin
       -- Open the command file...
			timer := 0;
        FILE_OPEN(cmdfile,"C:\EL6493\Sim\project_test_vectors.TXT",READ_MODE);
		  
        loop
            if endfile(cmdfile) then  -- Check EOF
                assert false
                    report "End of file encountered; exiting."
                    severity NOTE;
                exit;
            end if;

            readline(cmdfile,L);           -- Read the line
            next when L'length = 0;  -- Skip empty lines

            hread(L,din,good);     -- Read the data_in argument as hex value
            assert good
                report "Text I/O read error"
                severity ERROR;

            hread(L,erb,good);     -- Read the errorbit argument
            assert good
                report "Text I/O read error"
                severity ERROR;
					 
				hread(L,output,good);     -- Read the correct output argument
            assert good
                report "Text I/O read error"
                severity ERROR;
					 
				read(L,er,good);     -- Read the error flag argument
            assert good
                report "Text I/O read error"
                severity ERROR;

			data_in <= din;
			errorbit <= erb;
		  clr <= '0';
		  input_valid <= '0';
			wait for PERIOD;
			input_valid <= '1';
		  clr <= '1';
		  	wait for PERIOD;
		  input_valid <= '0';

            wait for 23*PERIOD;

				timer := timer + 25*20;
				
				if(data_out = Output) THEN

					if(errorflag = er) THEN
						int_val := 0;
						WRITE( out_line, (int_val));
					else
						WRITE( out_line, (timer));  
						WRITE( out_line, '_');  
						WRITE( out_line, hstr(Output) & '_');  
						WRITE( out_line, hstr(data_out)); 
					end if;
				else
						WRITE( out_line, (timer));  
						WRITE( out_line, '_');  
						WRITE( out_line, hstr(Output) & '_');  
						WRITE( out_line, hstr(data_out));  
				END if; 
				-- write the line to the output file
				WRITELINE( outfile, out_line);  				

            assert (data_out = Output)
                report "Check failed!"
                    severity ERROR;	
						  
            assert (errorflag = er)
                report "Check failed!"
                    severity ERROR;	
 
        end loop;

        wait;

    end process;
	 
-- writecmd: process 
--        file file_pointer : text;
--        variable line_content : string(1 to 2);
--		  variable line_num : line;
--   begin
--        --Open the file write.txt from the specified location for writing(WRITE_MODE).
--		if(do_rdy = '1') THEN
--			line_content := "11";
--			else
--			line_content := "00";
--		END if;
--		if(do_rdy ='1') THEN
--      file_open(file_pointer,"C:\EL6493\Sim\ENCTB.TXT",WRITE_MODE); 
--		write(line_num,line_content); --write the line.
--		writeline(file_pointer,line_num); --write the contents into the file.
--		file_close(file_pointer); --Close the file after writing.
--		END if;
--  end process;

end PTBBehavioral;

