Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
Use IEEE.STD_LOGIC_UNSIGNED.ALL;
Entity SerialTransmitter is
Port (   din : in STD_LOGIC_VECTOR (6 downto 0);                    -- input data that will be sent
		 start_transmit : in STD_LOGIC;                             -- enable sending
		 clk : in STD_LOGIC;                                        -- clock cycle 
		 serial_out : BUFFER STD_LOGIC;                             -- the sent data
         floating : out STD_LOGIC_VECTOR (8 downto 0) := "000000000" ); -- check no floating 
End SerialTransmitter ;

Architecture Behavior of SerialTransmitter is
	Signal parity_bit : STD_LOGIC;
	Signal da : STD_LOGIC_VECTOR (8 downto 0);
	Signal m : STD_LOGIC_vector (1 downto 0) :="00"; -- counter 
-- That is a counter to not to load the same data again.
Begin
	parity_bit <= din(0) xor din(1) xor din(2) xor din(3) xor din(4) xor din(5) xor din(6) ;
Process
Begin
Wait until (clk'EVENT AND clk='1') ;
	if start_transmit='1' then
		if (m = "00") then
			da (8 downto 0) <= '1' & parity_bit & din (6 downto 0);
			serial_out <= '1';
			m <= "01" ;
		elsif (m = "01") then
			Genbits: FOR i IN 0 To 7 LOOP -- shifting circuit
			    da (i) <=da(i+1);
			End LOOP;
			serial_out<= da (0);
			da (8) <= '0';
	    End if;
	elsif start_transmit = '0' then
		m <="00";
		da <= "000000000" ;
		serial_out <='0';
	End if;
End process;
End Behavior ;