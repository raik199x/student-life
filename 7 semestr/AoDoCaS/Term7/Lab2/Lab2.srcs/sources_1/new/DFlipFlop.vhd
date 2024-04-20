----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2023 17:13:03
-- Design Name: 
-- Module Name: DFlipFlop - custom
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
use IEEE.STD_LOGIC_1164.ALL;

-- Category: SYNCHRONOUS 1-BIT D-FLIP-FLOP WITH ASYNCHRONOUS RESET
-- Implementation: custom DFlipFlop
entity DFlipFlop is
	generic (
		INV_C: boolean;
		INV_R: boolean
	);
	port (
		-- Input pins
		C: in  std_logic;
		D: in  std_logic;
		R: in  std_logic;
		-- Output pins
		Q: out std_logic
	);
end entity;

architecture custom of DFlipFlop is begin
	process (C, R, D) begin
		if (R = '1' and not INV_R) or (R = '0' and INV_R) then
			-- Asynchronous Reset
			Q <= '0';
		else
			-- Synchronous load
			if INV_C = false then
				if rising_edge(C) then
					Q <= D;
				end if;
			end if;
			if INV_C = true then
				if falling_edge(C) then
					Q <= D;
				end if;
			end if;
		end if;
	end process;
end architecture;
