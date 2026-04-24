library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity compute_fsm is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        digit_valid : in  std_logic;
        new_calc    : in  std_logic;
        load_digit1 : out std_logic;
        load_digit2 : out std_logic;
        compute_en  : out std_logic;
        clear       : out std_logic
    );
end compute_fsm;

architecture Behavioral of compute_fsm is
    type state_type is (RESET_STATE, WAIT_FIRST, WAIT_SECOND, COMPUTE, DISPLAY_RESULT);
    signal current_state, next_state : state_type;
begin

    -- State Register
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= RESET_STATE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next State Logic
    process(current_state, reset, digit_valid, new_calc)
    begin
        next_state <= current_state;
        if reset = '1' then
            next_state <= RESET_STATE;
        else
            case current_state is
                when RESET_STATE =>
                    next_state <= WAIT_FIRST;
                when WAIT_FIRST =>
                    if digit_valid = '1' then
                        next_state <= WAIT_SECOND;
                    end if;
                when WAIT_SECOND =>
                    if digit_valid = '1' then
                        next_state <= COMPUTE;
                    end if;
                when COMPUTE =>
                    next_state <= DISPLAY_RESULT;
                when DISPLAY_RESULT =>
                    if new_calc = '1' then
                        next_state <= WAIT_FIRST;
                    end if;
                when others =>
                    next_state <= RESET_STATE;
            end case;
        end if;
    end process;

    -- Output Logic
    process(current_state)
    begin
        load_digit1 <= '0';
        load_digit2 <= '0';
        compute_en  <= '0';
        clear       <= '0';
        
        case current_state is
            when RESET_STATE =>
                clear <= '1';
            when WAIT_FIRST =>
                load_digit1 <= '1';
            when WAIT_SECOND =>
                load_digit2 <= '1';
            when COMPUTE =>
                compute_en <= '1';
            when DISPLAY_RESULT =>
                -- Hold values for display
            when others =>
                clear <= '1';
        end case;
    end process;

end Behavioral;
