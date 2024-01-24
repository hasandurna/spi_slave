
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_spi_slave is
--  Port ( );
end tb_spi_slave;

architecture Behavioral of tb_spi_slave is
component spi_slave is
	port(
			rst			: in std_logic;	-- Asenkron sistem sıfırlama
			-- Master ve Slave arasındaki bağlantı noktaları
			sck			: in std_logic;	-- SPI Master tarafından gönderilen SPI saat sinyali
			mosi		: in std_logic;	-- SPI Master'dan gelen data sinyali
			ss			: in std_logic;	-- SPI Master tarafından gönderilen Slave seçme sinyali (Active-low)
			-- Çıkış:
			miso		: out std_logic;	-- Veri, Master önceden belirlenmiş sayıda SCK döngüsü gönderdikten sonra okunacaktır
			
			-- Slave ve Interface FPGA arasındaki portlar
			tx_data	    : in std_logic_vector(7 downto 0);	-- İletilecek veriler burada 8 bitlik gruplar halinde paketlenir
			rx_data		: out std_logic_vector(7 downto 0)	-- Master'dan alınan veriler burada paketlenir, FPGA nin Interface sinyallerine gönderilecek
	);
end component;

signal rst			:  std_logic;	-- Asenkron sistem sıfırlama
signal sck			:  std_logic;	-- SPI Master tarafından gönderilen SPI saat sinyali
signal mosi		    :  std_logic;	-- SPI Master'dan gelen data sinyali
signal ss			:  std_logic;	-- SPI Master tarafından gönderilen Slave seçme sinyali (Active-low)
signal miso		    :  std_logic;	-- Veri, Master önceden belirlenmiş sayıda SCK döngüsü gönderdikten sonra okunacaktır
signal tx_data	    :  std_logic_vector(7 downto 0);	-- İletilecek veriler burada 8 bitlik gruplar halinde paketlenir
signal rx_data		:  std_logic_vector(7 downto 0);	-- Master'dan alınan veriler burada paketlenir, FPGA nin Interface sinyallerine gönderilecek

begin

 uut : spi_slave port map
    (        
        rst			=> rst		,
        sck			=> sck		,
        mosi		=> mosi		,
        ss			=> ss		, 
        miso		=> miso		,
        tx_data     => tx_data  ,
        rx_data     => rx_data   
    );
    
stim_proc: process
begin

-- MOSI hattından gelen veri paketi "0101 1011" olsun

    rst <= '1';			-- Haberlesme reset durumundan baslamali
    sck <= '0';
    ss <= '1';
    mosi <= '0';
    wait for 20 ns;
    rst <= '0';
    wait for 10 ns;
    
    -- SS --
    ss <= '0';			-- Master konusacagi Slave'in SS pinini "low" seviyesine alır ve iletim baslar
    tx_data <= x"2C";	-- MISO hattıdan Master'e gonderceğimiz veri bu olsun
    wait for 5 ns;
    
    mosi <= '1';
    wait for 5 ns;
    sck <= '1';
    wait for 5 ns;
    sck <= '0';
    wait for 5 ns;
    sck <= '1';
    wait for 5 ns;
    sck <= '0';
    mosi <= '0';
    wait for 5 ns;
    sck <= '1';
    wait for 5 ns;
    sck <= '0';
    wait for 5 ns;
    sck <= '1';
    wait for 5 ns;
    sck <= '0';
    mosi <= '1';
    wait for 5 ns;
    sck <= '1';
    wait for 5 ns;
    sck <= '0';
    mosi <= '0';
    wait for 5 ns;
    sck <= '1';
    wait for 5 ns;
    sck <= '0';
    mosi <= '1';
    wait for 5 ns;
    sck <= '1';
    wait for 5 ns;
    sck <= '0';
    mosi <= '0';
    wait for 5 ns;
    sck <= '1';
    wait for 5 ns;
    sck <= '0';
    wait for 5 ns;
    
    ss <= '1';	-- Master ilgili Slave'in SS pinini "high" seviyesine alır ve iletim biter
    
    wait;		

end process;

end Behavioral;
