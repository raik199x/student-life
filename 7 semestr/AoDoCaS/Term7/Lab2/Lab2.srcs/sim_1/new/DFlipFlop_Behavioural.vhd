----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2023 17:15:11
-- Design Name: 
-- Module Name: DFlipFlop_Behavioural - simulation
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

entity DFlipFlop_Behavioural is
	-- Generics
	-- generic ();
	-- Constants
	constant REPEATS:    integer  := 1;
	constant ITERATIONS: integer  := (2 ** 3) * (1 + REPEATS);
	constant DELAY:      time     := 1000000 ps / ITERATIONS;
end entity;

architecture simulation of DFlipFlop_Behavioural is
	-- Input signals
	signal UUT_C:   std_logic := 'U';
	signal UUT_R:   std_logic := 'U';
	signal UUT_D:   std_logic := 'U';
	-- Output signals
	signal UUT_Q_0: std_logic := 'U';
	signal UUT_Q_1: std_logic := 'U';
	signal UUT_Q_2: std_logic := 'U';
	signal UUT_Q_3: std_logic := 'U';
	-- Utility functions
	function to_std_logic(value: integer) return std_logic is begin
		if    value = 0 then return '0';
		elsif value = 1 then return '1';
		else                 return 'X';
		end if;
	end function;
begin
	-- Instantiate units under test (UUT-s)
	-- Units are sorted by their generic flags `INV_[X, Y] -> 0bYX` using Gray codes
	uut_dff_0: entity work.DFlipFlop(custom) -- Gray code: 0b00
		generic map (INV_C => false, INV_R => false)
		port map (C => UUT_C, R => UUT_R, D => UUT_D, Q => UUT_Q_0);
	uut_dff_1: entity work.DFlipFlop(custom)-- Gray code: 0b01
		generic map (INV_C => true, INV_R => false)
		port map (C => UUT_C, R => UUT_R, D => UUT_D, Q => UUT_Q_1);
	uut_dff_2: entity work.DFlipFlop(custom)-- Gray code: 0b11
		generic map (INV_C => true, INV_R => true)
		port map (C => UUT_C, R => UUT_R, D => UUT_D, Q => UUT_Q_2);
	uut_dff_3: entity work.DFlipFlop(custom)-- Gray code: 0b10
		generic map (INV_C => false, INV_R => true)
		port map (C => UUT_C, R => UUT_R, D => UUT_D, Q => UUT_Q_3);
	-- Simulation process
	process begin
		for int_r in 0 to 1 loop
			for tmp_0 in 0 to REPEATS loop
				for int_d in 0 to 1 loop
					for int_c in 0 to 1 loop
						UUT_C <= to_std_logic(int_c);
						UUT_D <= to_std_logic(int_d);
						UUT_R <= to_std_logic(int_r);
						wait for DELAY;
					end loop;
				end loop;
			end loop;
		end loop;
		UUT_C <= 'X';
		UUT_D <= 'X';
		UUT_D <= 'X';
		wait;
	end process;
end architecture;
