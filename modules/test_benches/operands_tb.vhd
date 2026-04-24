library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity operands_tb is
end operands_tb;

architecture behavior of operands_tb is
    -- Inputs
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal clear       : std_logic := '0';
    signal load_digit1 : std_logic := '0';
    signal load_digit2 : std_logic := '0';
    signal compute_en  : std_logic := '0';
    signal digit_in    : std_logic_vector(3 downto 0) := (others => '0');

    -- Outputs
    signal digit1      : std_logic_vector(3 downto 0);
    signal digit2      : std_logic_vector(3 downto 0);
    signal tens        : std_logic_vector(3 downto 0);
    signal ones        : std_logic_vector(3 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate UUT
    uut: entity work.operands
        port map (
            clk         => clk,
            reset       => reset,
            clear       => clear,
            load_digit1 => load_digit1,
            load_digit2 => load_digit2,
            compute_en  => compute_en,
            digit_in    => digit_in,
            digit1      => digit1,
            digit2      => digit2,
            tens        => tens,
            ones        => ones
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

        -- Load Digit 1
        digit_in <= x"5";
        load_digit1 <= '1';
        wait for clk_period;
        load_digit1 <= '0';

        -- Load Digit 2
        digit_in <= x"7";
        load_digit2 <= '1';
        wait for clk_period;
        load_digit2 <= '0';

        -- Compute
        compute_en <= '1';
        wait for clk_period;
        compute_en <= '0';

        wait for clk_period * 2;

        -- Clear
        clear <= '1';
        wait for clk_period;
        clear <= '0';
        
        wait;
    end process;

end behavior;
