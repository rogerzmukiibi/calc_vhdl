library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calculator_top is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        digit_in    : in  std_logic_vector(3 downto 0);
        digit_valid : in  std_logic;
        new_calc    : in  std_logic;
        
        seg_digit1  : out std_logic_vector(6 downto 0);
        seg_digit2  : out std_logic_vector(6 downto 0);
        seg_tens    : out std_logic_vector(6 downto 0);
        seg_ones    : out std_logic_vector(6 downto 0)
    );
end calculator_top;

architecture Structural of calculator_top is

    signal load_digit1 : std_logic;
    signal load_digit2 : std_logic;
    signal compute_en  : std_logic;
    signal clear       : std_logic;
    
    signal digit1_out  : std_logic_vector(3 downto 0);
    signal digit2_out  : std_logic_vector(3 downto 0);
    signal tens_out    : std_logic_vector(3 downto 0);
    signal ones_out    : std_logic_vector(3 downto 0);

begin

    fsm_inst : entity work.compute_fsm
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

    datapath_inst : entity work.operands
        port map (
            clk         => clk,
            reset       => reset,
            clear       => clear,
            load_digit1 => load_digit1,
            load_digit2 => load_digit2,
            compute_en  => compute_en,
            digit_in    => digit_in,
            digit1      => digit1_out,
            digit2      => digit2_out,
            tens        => tens_out,
            ones        => ones_out
        );

    dec_digit1 : entity work.seven_seg_decoder
        port map (
            digit_in => digit1_out,
            seg_out  => seg_digit1
        );

    dec_digit2 : entity work.seven_seg_decoder
        port map (
            digit_in => digit2_out,
            seg_out  => seg_digit2
        );

    dec_tens : entity work.seven_seg_decoder
        port map (
            digit_in => tens_out,
            seg_out  => seg_tens
        );

    dec_ones : entity work.seven_seg_decoder
        port map (
            digit_in => ones_out,
            seg_out  => seg_ones
        );

end Structural;