library ieee;
use ieee.std_logic_1164.all;

entity register_4bit is
    port (
        clk         : in std_logic := '0';                     -- Clock signal
        rst         : in std_logic := '0';                     -- Reset signal (active high)
        en          : in std_logic := '0';                     -- Enable signal
        data_in     : in std_logic_vector(3 downto 0) := (others => '0');  -- Data input
        data_out    : out std_logic_vector(3 downto 0) := (others => '0')  -- Data output
    );
end register_4bit;

architecture Behavioral of register_4bit is
    begin 
        -- This process is triggered on the rising edge of the clock 
        -- when the enable signal is high and reset is not active
        process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    data_out <= (others => '0');  -- Reset the output to zero
                elsif en = '1' then
                    data_out <= data_in;          -- Load the input data into the register
                end if;
            end if;
        end process;
end Behavioral;