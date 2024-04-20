----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2023 14:13:52
-- Design Name: 
-- Module Name: Divider - architecture1
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

entity Divider is
	port (
		CLK_IN:  in  std_logic;
		CLK_OUT: out std_logic
	);
end entity;

architecture architecture1 of Divider is
	signal   counter: integer   := 0;
	signal   holder:  std_logic := '0';
	constant DIVISOR: integer   := 200000000;
begin
	process (CLK_IN) begin
		if rising_edge(CLK_IN) then
			if counter = DIVISOR then
				counter <= 0;
				holder  <= not holder;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;
	CLK_OUT <= holder;
end architecture;
