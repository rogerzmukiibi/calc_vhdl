library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calculator_top_tb is
end calculator_top_tb;

architecture behavior of calculator_top_tb is
    -- Inputs
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal digit_in    : std_logic_vector(3 downto 0) := (others => '0');
    signal digit_valid : std_logic := '0';
    signal new_calc    : std_logic := '0';

    -- Outputs
    signal seg_digit1  : std_logic_vector(6 downto 0);
    signal seg_digit2  : std_logic_vector(6 downto 0);
    signal seg_tens    : std_logic_vector(6 downto 0);
    signal seg_ones    : std_logic_vector(6 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate UUT
    uut: entity work.calculator_top
        port map (
            clk         => clk,
            reset       => reset,
            digit_in    => digit_in,
            digit_valid => digit_valid,
            new_calc    => new_calc,
            seg_digit1  => seg_digit1,
            seg_digit2  => seg_digit2,
            seg_tens    => seg_tens,
            seg_ones    => seg_ones
        );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for clk_period;

        -- Test Calculation 1: 5 + 7 = 12
        digit_in <= x"5";
        digit_valid <= '1';
        wait for clk_period;
        digit_valid <= '0';
        wait for clk_period * 2;

        digit_in <= x"7";
        digit_valid <= '1';
        wait for clk_period;
        digit_valid <= '0';
        wait for clk_period * 4; -- wait for COMPUTE and DISPLAY states
        
        -- Start New Calculation
        new_calc <= '1';
        wait for clk_period;
        new_calc <= '0';
        wait for clk_period;

        -- Test Calculation 2: 9 + 9 = 18
        digit_in <= x"9";
        digit_valid <= '1';
        wait for clk_period;
        digit_valid <= '0';
        wait for clk_period * 2;

        digit_in <= x"9";
        digit_valid <= '1';
        wait for clk_period;
        digit_valid <= '0';
        wait for clk_period * 4;

        wait;
    end process;

end behavior;
