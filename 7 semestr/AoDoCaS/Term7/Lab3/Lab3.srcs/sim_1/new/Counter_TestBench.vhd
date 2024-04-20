----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2023 10:14:23
-- Design Name: 
-- Module Name: Counter_TestBench - run
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

entity Counter_TestBench is end entity;

architecture run of Counter_TestBench is
	-- Constants
	constant WIDTH:      positive := 4;
	-- Constants
	constant ITERATIONS: integer  := 3 + 4 + 2 + 2 + 13 + 12 + 6 + 1;
	constant EXTRA_ITER: positive := 1;
	constant DELAY:      time     := 1000000 ps / (ITERATIONS + EXTRA_ITER);
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
	-- Testing process
	process 
		file input_file: text;
		variable line_content: line;
		variable OE_h, ACLR_h, SCLR_h, LOAD_h, ENP_h, ENT_h, UD_h, CLK_h, D3_h, D2_h, D1_h, D0_h, Q3_h, Q2_h, Q1_h, Q0_h, RCO_h, CCO_h: boolean;
		variable OE_l, ACLR_l, SCLR_l, LOAD_l, ENP_l, ENT_l, UD_l, CLK_l, D3_l, D2_l, D1_l, D0_l, Q3_l, Q2_l, Q1_l, Q0_l, RCO_l, CCO_l: boolean;
	begin
		-- Open the input file
		file_open(input_file, "/home/timurialvarez/BSUIR-GH/AoDoCaS/Term7/TestBench3/tests/Counter.txt", read_mode);
		-- Read and ignore the header line
		readline(input_file, line_content);
		-- Read data from the file and simulate the entity
		while not endfile(input_file) loop
			-- Read a line from the file
			readline(input_file, line_content);
			-- Parse this line
			read(line_content, OE_h);   read(line_content, OE_l);
			read(line_content, ACLR_h); read(line_content, ACLR_l);
			read(line_content, SCLR_h); read(line_content, SCLR_l);
			read(line_content, LOAD_h); read(line_content, LOAD_l);
			read(line_content, ENP_h);  read(line_content, ENP_l);
			read(line_content, ENT_h);  read(line_content, ENT_l);
			read(line_content, UD_h);   read(line_content, UD_l);
			read(line_content, CLK_h);  read(line_content, CLK_l);
			read(line_content, D3_h);   read(line_content, D3_l);
			read(line_content, D2_h);   read(line_content, D2_l);
			read(line_content, D1_h);   read(line_content, D1_l);
			read(line_content, D0_h);   read(line_content, D0_l);
			read(line_content, Q3_h);   read(line_content, Q3_l);
			read(line_content, Q2_h);   read(line_content, Q2_l);
			read(line_content, Q1_h);   read(line_content, Q1_l);
			read(line_content, Q0_h);   read(line_content, Q0_l);
			read(line_content, RCO_h);  read(line_content, RCO_l);
			read(line_content, CCO_h);  read(line_content, CCO_l);
			-- Set the input signals to the values read from the file
			UUT_OE   <= to_std_logic(OE_h, OE_l);
			UUT_ACLR <= to_std_logic(ACLR_h, ACLR_l);
			UUT_SCLR <= to_std_logic(SCLR_h, SCLR_l);
			UUT_LOAD <= to_std_logic(LOAD_h, LOAD_l);
			UUT_ENP  <= to_std_logic(ENP_h, ENP_l);
			UUT_ENT  <= to_std_logic(ENT_h, ENT_l);
			UUT_UD   <= to_std_logic(UD_h, UD_l);
			UUT_CLK  <= to_std_logic(CLK_h, CLK_l);
			UUT_D    <= to_std_logic(D3_h, D3_l) & to_std_logic(D2_h, D2_l) & to_std_logic(D1_h, D1_l) & to_std_logic(D0_h, D0_l);
			-- Check if the output value matches the expected value
			wait for 1ps;
			assert UUT_Q = to_std_logic(Q3_h, Q3_l) & to_std_logic(Q2_h, Q2_l) & to_std_logic(Q1_h, Q1_l) & to_std_logic(Q0_h, Q0_l)
				report "Mismatch detected for Q" severity error;
			assert UUT_RCO = to_std_logic(RCO_h, RCO_l)
				report "Mismatch detected for RCO" severity error;
			assert UUT_CCO = to_std_logic(CCO_h, CCO_l)
				report "Mismatch detected for CCO" severity error;
			wait for DELAY;
		end loop;
		-- Close the input file
		file_close(input_file);
		-- Wait for simulation to end
		wait;
	end process;
end architecture;
