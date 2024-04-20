----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2023 10:14:23
-- Design Name: 
-- Module Name: SN74_TestBench_0 - run
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

entity SN74_TestBench_0 is end entity;

architecture run of SN74_TestBench_0 is
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
	-- Testing process
	process 
		file input_file: text;
		variable line_content: line;
		variable D_h, S_h, A3_h, A2_h, A1_h, A0_h, B3_h, B2_h, B1_h, B0_h, Y3_h, Y2_h, Y1_h, Y0_h: boolean;
		variable D_l, S_l, A3_l, A2_l, A1_l, A0_l, B3_l, B2_l, B1_l, B0_l, Y3_l, Y2_l, Y1_l, Y0_l: boolean;
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
			read(line_content, Y3_h); read(line_content, Y3_l);
			read(line_content, Y2_h); read(line_content, Y2_l);
			read(line_content, Y1_h); read(line_content, Y1_l);
			read(line_content, Y0_h); read(line_content, Y0_l);
			-- Set the input signals to the values read from the file
			D <= to_std_logic(D_h, D_l);
			S <= to_std_logic(S_h, S_l);
			A <= to_std_logic(A3_h, A3_l) & to_std_logic(A2_h, A2_l) & to_std_logic(A1_h, A1_l) & to_std_logic(A0_h, A0_l);
			B <= to_std_logic(B3_h, B3_l) & to_std_logic(B2_h, B2_l) & to_std_logic(B1_h, B1_l) & to_std_logic(B0_h, B0_l);
			-- Check if the output value matches the expected value
			wait for 1ps;
			assert Y_a1 = to_std_logic(Y3_h, Y3_l) & to_std_logic(Y2_h, Y2_l) & to_std_logic(Y1_h, Y1_l) & to_std_logic(Y0_h, Y0_l)
				report "Mismatch detected for Y_a1" severity error;
			wait for DELAY;
		end loop;
		-- Close the input file
		file_close(input_file);
		-- Wait for simulation to end
		wait;
	end process;
end architecture;
