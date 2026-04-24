library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity operands is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        clear       : in  std_logic;
        load_digit1 : in  std_logic;
        load_digit2 : in  std_logic;
        compute_en  : in  std_logic;
        digit_in    : in  std_logic_vector(3 downto 0);
        digit1      : out std_logic_vector(3 downto 0);
        digit2      : out std_logic_vector(3 downto 0);
        tens        : out std_logic_vector(3 downto 0);
        ones        : out std_logic_vector(3 downto 0)
    );
end operands;

architecture Behavioral of operands is
    signal d1_reg, d2_reg     : unsigned(3 downto 0);
    signal sum_reg            : unsigned(4 downto 0);
begin

    process(clk, reset)
    begin
        if reset = '1' then
            d1_reg <= (others => '0');
            d2_reg <= (others => '0');
            sum_reg <= (others => '0');
        elsif rising_edge(clk) then
            if clear = '1' then
                d1_reg <= (others => '0');
                d2_reg <= (others => '0');
                sum_reg <= (others => '0');
            else
                if load_digit1 = '1' then
                    d1_reg <= unsigned(digit_in);
                elsif load_digit2 = '1' then
                    d2_reg <= unsigned(digit_in);
                elsif compute_en = '1' then
                    sum_reg <= ('0' & d1_reg) + ('0' & d2_reg);
                end if;
            end if;
        end if;
    end process;

    digit1 <= std_logic_vector(d1_reg);
    digit2 <= std_logic_vector(d2_reg);

    -- Simple Binary to BCD for a 5-bit number (max value 30 = 15+15)
    process(sum_reg)
        variable temp_tens : integer range 0 to 3;
        variable temp_ones : integer range 0 to 9;
        variable sum_int   : integer range 0 to 31;
    begin
        sum_int := to_integer(sum_reg);
        
        if sum_int >= 30 then
            temp_tens := 3; temp_ones := sum_int - 30;
        elsif sum_int >= 20 then
            temp_tens := 2; temp_ones := sum_int - 20;
        elsif sum_int >= 10 then
            temp_tens := 1; temp_ones := sum_int - 10;
        else
            temp_tens := 0; temp_ones := sum_int;
        end if;
        
        tens <= std_logic_vector(to_unsigned(temp_tens, 4));
        ones <= std_logic_vector(to_unsigned(temp_ones, 4));
    end process;

end Behavioral;