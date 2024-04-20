----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2023 10:14:23
-- Design Name: 
-- Module Name: SN74_TestBench_1 - run
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
use std.textio.all;
use ieee.std_logic_textio.all;

entity SN74_TestBench_1 is end entity;

architecture run of SN74_TestBench_1 is
	-- Constants
	constant WIDTH:      positive := 4;
	constant ITERATIONS: positive := 2 ** (2 * WIDTH + 2);
	constant EXTRA_ITER: positive := 1;
	constant DELAY:      time     := 1000000 ps / (ITERATIONS + EXTRA_ITER);
	-- Signals
	signal A:    std_logic_vector(WIDTH-1 downto 0) := (others => '0');
	signal B:    std_logic_vector(WIDTH-1 downto 0) := (others => '0');
	signal D:    std_logic                             := '0';
	signal S:    std_logic                             := '0';
	signal Y_a1: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
	signal Y_a2: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
	signal Y_a3: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
	signal Y_a4: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
	signal Y_a5: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
	-- Utility functions
	function to_std_logic(H, L: boolean) return std_logic is begin
		if H then
			if L then return 'Z';
			else      return 'X';
			end if;
		else
			if L then return '1';
			else      return '0';
			end if;
		end if;
	end function;
begin
	-- Instantiate unit under test (UUT)
	uut1: entity work.SN74(architecture1)
		generic map (WIDTH => WIDTH)
		port map (A => A, B => B, D => D, S => S, Y => Y_a1);
	uut2: entity work.SN74(architecture2)
		generic map (WIDTH => WIDTH)
		port map (A => A, B => B, D => D, S => S, Y => Y_a2);
	uut3: entity work.SN74(architecture3)
		generic map (WIDTH => WIDTH)
		port map (A => A, B => B, D => D, S => S, Y => Y_a3);
	uut4: entity work.SN74(architecture4)
		generic map (WIDTH => WIDTH)
		port map (A => A, B => B, D => D, S => S, Y => Y_a4);
	uut5: entity work.SN74(architecture5)
		generic map (WIDTH => WIDTH)
		port map (A => A, B => B, D => D, S => S, Y => Y_a5);
	-- Testing process
	process 
		file input_file: text;
		variable line_content: line;
		variable D_h, S_h, A3_h, A2_h, A1_h, A0_h, B3_h, B2_h, B1_h, B0_h: boolean;
		variable D_l, S_l, A3_l, A2_l, A1_l, A0_l, B3_l, B2_l, B1_l, B0_l: boolean;
	begin
		-- Open the input file
		file_open(input_file, "/home/timurialvarez/BSUIR-GH/AoDoCaS/Term7/TestBench3/tests/SN74.txt", read_mode);
		-- Read and ignore the header line
		readline(input_file, line_content);
		-- Read data from the file and simulate the entity
		while not endfile(input_file) loop
			-- Read a line from the file
			readline(input_file, line_content);
			-- Parse this line
			read(line_content, D_h);  read(line_content, D_l);
			read(line_content, S_h);  read(line_content, S_l);
			read(line_content, A3_h); read(line_content, A3_l);
			read(line_content, A2_h); read(line_content, A2_l);
			read(line_content, A1_h); read(line_content, A1_l);
			read(line_content, A0_h); read(line_content, A0_l);
			read(line_content, B3_h); read(line_content, B3_l);
			read(line_content, B2_h); read(line_content, B2_l);
			read(line_content, B1_h); read(line_content, B1_l);
			read(line_content, B0_h); read(line_content, B0_l);
			-- Set the input signals to the values read from the file
			D <= to_std_logic(D_h, D_l);
			S <= to_std_logic(S_h, S_l);
			A <= to_std_logic(A3_h, A3_l) & to_std_logic(A2_h, A2_l) & to_std_logic(A1_h, A1_l) & to_std_logic(A0_h, A0_l);
			B <= to_std_logic(B3_h, B3_l) & to_std_logic(B2_h, B2_l) & to_std_logic(B1_h, B1_l) & to_std_logic(B0_h, B0_l);
			-- Check if the output value matches the expected value
			wait for 1ps;
			assert Y_a1 = Y_a2 and Y_a1 = Y_a3 and Y_a1 = Y_a4 and Y_a1 = Y_a5
				report "Mismatch detected for Y_a1" severity error;
			wait for DELAY;
		end loop;
		-- Close the input file
		file_close(input_file);
		-- Wait for simulation to end
		wait;
	end process;
end architecture;
