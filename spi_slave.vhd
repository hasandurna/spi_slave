library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity spi_slave is
	port(
			rst		: in std_logic;
			sck 	: in std_logic;
			mosi	: in std_logic;
			miso	: out std_logic;
			ss		: in std_logic;
			-- 
			tx_data	: in std_logic_vector(7 downto 0);
			rx_data : out std_logic_vector(7 downto 0)	
	);
end entity;

architecture arch of spi_slave is

signal bit_cnt	: std_logic_vector(2 downto 0);
signal rx_reg 	:  std_logic_vector(7 downto 0);

begin

-- Bit Counter
-- Sola dayali bir yazma yapacagiz yani MSB 7. bitte olacak
process(rst,ss,sck)
begin
	if(ss = '1' or rst = '1') then
		bit_cnt <= "111";			-- Sayaci varsayilan duruma cektik		
	elsif(ss = '0' and rising_edge(sck)) then
		if(bit_cnt = "000") then
			bit_cnt <= "111";		-- Overflow olmasin diye
		else
			bit_cnt <= bit_cnt - "001";	
		end if;		
	end if;
end process;

-- MOSI uzerinden gelen veriyi RX registerini kullanarak bit bazinda sirali bir sekilde Slave'e yazdik
process(rst, ss, sck)
begin
	if(ss = '1' or rst = '1') then	-- SS kontrolunu master yapiyor, biz sadece input aliyoruz
		rx_reg <= (others => '0');
	elsif(ss = '0' and rising_edge(sck)) then
		rx_reg(to_integer(unsigned(bit_cnt))) <= mosi;
	end if;
end process;
rx_data <= rx_reg;

-- MISO uzerinden TX registerini kullanarak verileri bit bazinda sirayla Master'a gonderdik 
process(rst, ss, sck)
begin
	if(ss = '1' or rst = '1') then
		miso <= '0';
	elsif(ss = '0' and rising_edge(sck)) then
		miso <= tx_data(to_integer(unsigned(bit_cnt)));
	end if;
end process;
--

end architecture;