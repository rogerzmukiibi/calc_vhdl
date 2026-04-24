library ieee;
use ieee.std_logic_1164.all;

entity register_tb is
end register_tb;

architecture behavior of register_tb is

    -- Inputs
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal en      : std_logic := '0';
    signal data_in : std_logic_vector(3 downto 0) := (others => '0');

    -- Outputs
    signal data_out : std_logic_vector(3 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.register_4bit port map (
          clk      => clk,
          rst      => rst,
          en       => en,
          data_in  => data_in,
          data_out => data_out
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Hold reset state
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for clk_period;

        -- Test case 1: Write data with enable high
        data_in <= x"AA";
        en <= '1';
        wait for clk_period;

        -- Test case 2: Attempt to write data with enable low (should hold previous value)
        en <= '0';
        data_in <= x"55";
        wait for clk_period * 2;

        -- Test case 3: Write new data with enable high
        en <= '1';
        data_in <= x"FF";
        wait for clk_period;

        -- Test case 4: Apply reset during operation
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        
        -- End simulation
        wait;
    end process;

end behavior;
