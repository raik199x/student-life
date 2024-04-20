----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2023 17:14:02
-- Design Name: 
-- Module Name: Counter_Behavioural - simulation
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
-- use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity Counter_Behavioural is
	-- Generics
	generic (
		WIDTH: positive := 4
	);
	-- Constants
	constant ITERATIONS: integer  := 3 + 4 + 2 + 2 + 13 + 12 + 6 + 1;
	constant DELAY:      time     := 1000000 ps / ITERATIONS;
end entity;

architecture simulation of Counter_Behavioural is
	-- Simulation constants (do not care value)
	constant IDC:    std_logic := '1';
	-- Input signals (control)
	signal UUT_OE:   std_logic := 'U';
	signal UUT_UD:   std_logic := 'U';
	signal UUT_CLK:  std_logic := 'U';
	signal UUT_ENT:  std_logic := 'U';
	signal UUT_ENP:  std_logic := 'U';
	signal UUT_SCLR: std_logic := 'U';
	signal UUT_LOAD: std_logic := 'U';
	signal UUT_ACLR: std_logic := 'U';
	-- Input signals (data)
	signal UUT_D:    std_logic_vector(WIDTH - 1 downto 0) := (others => 'U');
	-- Output signals (status)
	signal UUT_CCO:  std_logic := 'U';
	signal UUT_RCO:  std_logic := 'U';
	-- Output signals (data)
	signal UUT_Q:    std_logic_vector(WIDTH - 1 downto 0) := (others => 'U');
begin
	-- Instantiate units under test (UUT-s)
	UUT: entity work.Counter(custom)
		generic map (WIDTH => WIDTH)
		port map (
			OE => UUT_OE,
			UD => UUT_UD,
			CLK => UUT_CLK,
			ENT => UUT_ENT,
			ENP => UUT_ENP,
			SCLR => UUT_SCLR,
			LOAD => UUT_LOAD,
			ACLR => UUT_ACLR,
			D => UUT_D,
			CCO => UUT_CCO,
			RCO => UUT_RCO,
			Q => UUT_Q
		);
	-- Simulation process
	process begin
		-- Async clear (3 CLK)
		UUT_OE   <= '0'; UUT_ACLR <= '0';
		UUT_SCLR <= IDC; UUT_LOAD <= IDC;
		UUT_ENP  <= IDC; UUT_ENT  <= IDC;
		UUT_UD   <= IDC; UUT_D    <= (others => IDC);
		for N in 1 to 3 loop
			if N = 3 then
				UUT_ENP  <= '0'; UUT_ENT  <= '0';
			end if;
			UUT_CLK  <= '0'; wait for DELAY;
		end loop;
		-- Count up (4 CLK)
		UUT_OE   <= '0'; UUT_ACLR <= '1';
		UUT_SCLR <= '1'; UUT_LOAD <= '1';
		-- UUT_ENP  <= '0'; UUT_ENT  <= '0'; (Moved up!)
		UUT_UD   <= '1'; UUT_D    <= (others => IDC);
		UUT_CLK  <= '1'; wait for DELAY;
		UUT_CLK  <= '0'; wait for DELAY;
		UUT_CLK  <= '1'; wait for DELAY;
		UUT_SCLR <= '0'; UUT_LOAD <= '1';
		UUT_ENP  <= IDC; UUT_ENT  <= IDC;
		UUT_CLK  <= '0'; wait for DELAY;
		-- Sync clear (2 CLK)
		UUT_CLK  <= '1'; wait for DELAY;
		UUT_SCLR <= '1'; UUT_LOAD <= '0';
		UUT_UD   <= '1'; UUT_D    <= "0111";
		UUT_CLK  <= '0'; wait for DELAY;
		-- Sync load (2 CLK)
		UUT_CLK  <= '1'; wait for DELAY;
		UUT_SCLR <= '1'; UUT_LOAD <= '1';
		UUT_ENP  <= '0'; UUT_ENT  <= '0';
		UUT_UD   <= '1'; UUT_D    <= (others => IDC);
		UUT_CLK  <= '0'; wait for DELAY;
		-- Count up (13 CLK)
		UUT_OE   <= '0'; UUT_ACLR <= '1';
		UUT_SCLR <= '1'; UUT_LOAD <= '1';
		UUT_ENP  <= '0'; UUT_ENT  <= '0';
		UUT_UD   <= '1'; UUT_D    <= (others => IDC);
		for N in 1 to 7 loop
			UUT_CLK <= '1'; wait for DELAY;
			if N = 4 then
				UUT_OE   <= '1'; UUT_ACLR <= '1';
			elsif N = 6 then
				UUT_OE   <= '0'; UUT_ACLR <= '1';
			end if;
			if not (N = 7) then
				UUT_CLK <= '0'; wait for DELAY;
			end if;
		end loop;
		-- Count down (12 CLK)
		UUT_UD   <= '0'; UUT_D    <= (others => IDC);
		for N in 1 to 6 loop
			UUT_CLK  <= '0'; wait for DELAY;
			UUT_CLK  <= '1'; wait for DELAY;
		end loop;
		-- Inhibit counting (6 CLK)
		UUT_UD   <= IDC; UUT_D    <= (others => IDC);
		for N in 1 to 3 loop
			if N = 3 then UUT_ENP <= '0'; else UUT_ENP <= '1'; end if;
			if N = 1 then UUT_ENT <= '0'; else UUT_ENT <= '1'; end if;
			UUT_CLK  <= '0'; wait for DELAY;
			UUT_CLK  <= '1'; wait for DELAY;
		end loop;
		-- The end (1 CLK)
		UUT_OE   <= 'X'; UUT_ACLR <= 'X';
		UUT_SCLR <= 'X'; UUT_LOAD <= 'X';
		UUT_ENP  <= 'X'; UUT_ENT  <= 'X';
		UUT_UD   <= 'X'; UUT_D    <= (others => 'X');
		UUT_CLK  <= 'X'; wait for DELAY;
		wait;
	end process;
end architecture;
