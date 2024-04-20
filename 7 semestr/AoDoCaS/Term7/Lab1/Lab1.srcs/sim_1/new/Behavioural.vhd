----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.09.2023 17:37:36
-- Design Name: 
-- Module Name: Behavioural - simulation
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity Behavioural is
	generic (
		-- Data line width (for units under test)
		-- Max value is 8!!! Higher values result it 0ps DELAY
		DL_WIDTH: positive := 4
	);
	constant ITERATIONS: positive := 2 ** (2 * DL_WIDTH + 2);
	constant DELAY:      time     := 1000000 ps / ITERATIONS;
	constant MAX_VALUE:  positive := 2 ** DL_WIDTH - 1;
end entity;

architecture simulation of Behavioural is
	-- Signals
	signal A:    std_logic_vector(DL_WIDTH-1 downto 0) := (others => '0');
	signal B:    std_logic_vector(DL_WIDTH-1 downto 0) := (others => '0');
	signal D:    std_logic                             := '0';
	signal S:    std_logic                             := '0';
	signal Y_a1: std_logic_vector(DL_WIDTH-1 downto 0) := (others => '0');
	signal Y_a2: std_logic_vector(DL_WIDTH-1 downto 0) := (others => '0');
	signal Y_a3: std_logic_vector(DL_WIDTH-1 downto 0) := (others => '0');
	signal Y_a4: std_logic_vector(DL_WIDTH-1 downto 0) := (others => '0');
	signal Y_a5: std_logic_vector(DL_WIDTH-1 downto 0) := (others => '0');
	-- Utility functions
	-- Convert value `V` to std_logic
	function to_std_logic(V: integer) return std_logic is begin
		if    V = 0 then return '0';
		elsif V = 1 then return '1';
		else             return 'X';
		end if;
	end function;
	-- Convert value `V` to std_logic_vector
	function to_std_logic_vector(V: integer) return std_logic_vector is begin
		return std_logic_vector(to_unsigned(V, DL_WIDTH));
	end function;
begin
	-- Instantiate units under test (UUT-s)
	uut1: entity work.SN74(architecture1) -- architecture1 :: passed
		generic map (WIDTH => DL_WIDTH)
		port map (A => A, B => B, D => D, S => S, Y => Y_a1);
	uut2: entity work.SN74(architecture2) -- architecture2 :: passed
		generic map (WIDTH => DL_WIDTH)
		port map (A => A, B => B, D => D, S => S, Y => Y_a2);
	uut3: entity work.SN74(architecture3) -- architecture3 :: passed
		generic map (WIDTH => DL_WIDTH)
		port map (A => A, B => B, D => D, S => S, Y => Y_a3);
	uut4: entity work.SN74(architecture4) -- architecture4 :: passed
		generic map (WIDTH => DL_WIDTH)
		port map (A => A, B => B, D => D, S => S, Y => Y_a4);
	uut5: entity work.SN74(architecture5) -- architecture5 :: passed
		generic map (WIDTH => DL_WIDTH)
		port map (A => A, B => B, D => D, S => S, Y => Y_a5);
	-- Simulation process
	process begin
		for int_d in 0 to 1 loop
			for int_s in 0 to 1 loop
				for int_a in 0 to MAX_VALUE loop
					for int_b in 0 to MAX_VALUE loop
						D <= to_std_logic(int_d);
						S <= to_std_logic(int_s);
						A <= to_std_logic_vector(int_a);
						B <= to_std_logic_vector(int_b);
						wait for DELAY;
					end loop;
				end loop;
			end loop;
		end loop;
		D <= 'X';
		S <= 'X';
		A <= (others => 'X');
		B <= (others => 'X');
		wait;
	end process;
end architecture;
