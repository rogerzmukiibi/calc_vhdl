library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity compute_fsm_tb is
end compute_fsm_tb;

architecture behavior of compute_fsm_tb is
    -- Inputs
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal digit_valid : std_logic := '0';
    signal new_calc    : std_logic := '0';

    -- Outputs
    signal load_digit1 : std_logic;
    signal load_digit2 : std_logic;
    signal compute_en  : std_logic;
    signal clear       : std_logic;

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate UUT
    uut: entity work.compute_fsm
        port map (
            clk         => clk,
            reset       => reset,
            digit_valid => digit_valid,
            new_calc    => new_calc,
            load_digit1 => load_digit1,
            load_digit2 => load_digit2,
            compute_en  => compute_en,
            clear       => clear
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

        -- Test WAIT_FIRST -> WAIT_SECOND
        digit_valid <= '1';
        wait for clk_period;
        digit_valid <= '0';
        wait for clk_period * 2;

        -- Test WAIT_SECOND -> COMPUTE -> DISPLAY_RESULT
        digit_valid <= '1';
        wait for clk_period;
        digit_valid <= '0';
        wait for clk_period * 2;

        -- Test DISPLAY_RESULT -> WAIT_FIRST
        new_calc <= '1';
        wait for clk_period;
        new_calc <= '0';
        
        wait;
    end process;

end behavior;
