
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL ;
use IEEE.STD_LOGIC_ARITH.ALL;

entity display is   
    Port ( disp : out STD_LOGIC_VECTOR (6 downto 0);
           anodo : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           result : in std_logic_vector(6 downto 0));
end display;

architecture Behavioral of display is
        
        signal n : std_logic_vector(6 downto 0); -- Disp 1, armazena valor N
	    signal o : std_logic_vector(6 downto 0); -- Disp 2, armazena valor o
	    signal equal : std_logic_vector(6 downto 0); -- Disp 3, armazena valor = 
	    
	    signal cont : std_logic_vector(1 downto 0); -- contador display
	 
	   signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0);
        -- creating 10.5ms refresh period
        signal LED_activating_counter: std_logic_vector(1 downto 0);

begin

clk_anodo: process(clk,reset_n)
begin 
    if(reset_n = '1') then
        refresh_counter <= (others => '0');
    elsif(rising_edge(clk)) then
        refresh_counter <= refresh_counter + 1;
    end if;
end process clk_anodo;
 
 LED_activating_counter <= refresh_counter(19 downto 18);
 

-- 4-to-1 MUX to generate anode activating signals for 4 LEDs 
desloca_display: process(LED_activating_counter)
begin
    case LED_activating_counter is
    when "00" => anodo <= "11110111";                 
        cont <= "00";        
    when "01" =>
        anodo <= "11111011";         
        cont <= "01";        
    when "10" =>
        anodo <= "11111101";         
        cont <= "10";        
    when "11" =>
        anodo <= "11111110";         
        cont <= "11";      
    when others => anodo <= "11111111";                     
    end case;
end process desloca_display;

bit_to_BCD: process(cont, result)
begin
    case cont is
    when "00" => disp <= "0001001"; -- "n"     
    when "01" => disp <= "1100010"; -- "o" 
    when "10" => disp <= not "0001001"; -- "=" 
    when "11" => disp <= result;     
    when others => disp <= "1111111";             
    end case;
end process;

end Behavioral;
