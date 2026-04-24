library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_tb is
end seven_seg_tb;

architecture behavior of seven_seg_tb is
    -- Inputs
    signal digit_in : std_logic_vector(3 downto 0) := (others => '0');

    -- Outputs
    signal seg_out  : std_logic_vector(6 downto 0);

begin
    -- Instantiate UUT
    uut: entity work.seven_seg_decoder
        port map (
            digit_in => digit_in,
            seg_out  => seg_out
        );

    -- Stimulus process
    stim_proc: process
    begin
        for i in 0 to 15 loop
            digit_in <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;
        end loop;
        
        -- Test wildcard case
        digit_in <= "UUUU";
        wait for 10 ns;
        
        wait;
    end process;

end behavior;
