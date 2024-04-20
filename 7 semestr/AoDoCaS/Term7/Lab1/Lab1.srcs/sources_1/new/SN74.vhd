----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.09.2023 17:37:05
-- Design Name: 
-- Module Name: SN74 - architecture1..5
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

-- Category: QUADRUPLE 2-LINE TO 1-LINE DATA SELECTORS/MULTIPLEXERS
-- Implementation: SN74LV/SN74HC
entity SN74 is
	generic (
		-- Width of quadruple lines
		WIDTH: positive
	);
	port (
		-- Input quadruple lines
		A: in  std_logic_vector(WIDTH-1 downto 0);
		B: in  std_logic_vector(WIDTH-1 downto 0);
		-- Disable/Enable (not G)
		D: in  std_logic;
		-- Select (not A/B)
		S: in  std_logic;
		-- Output quadruple line
		Y: out std_logic_vector(WIDTH-1 downto 0)
	);
end entity;

-- Function table (SN74)
-- |---|---|---|---||---|
-- | D | S | A | B || Y |
-- |---|---|---|---||---|
-- | H | X | X | X || L |
-- | L | L | L | X || L |
-- | L | L | H | X || H |
-- | L | H | X | L || L |
-- | L | H | X | H || H |
-- |---|---|---|---||---|

-- Implementation 1
-- Parallel unconditional assignment is required (+ logical operators)
architecture architecture1 of SN74 is
	-- Internal signal
	signal Enable:  std_logic_vector(WIDTH-1 downto 0) := (others => '0');
	signal SelectB: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
begin
	Enable  <= (others => not D);
	SelectB <= (others => S);
	Y       <= Enable and ((A and not SelectB) or (B and SelectB));
end architecture;

-- Implementation 2
-- Parallel conditional assignment is required
architecture architecture2 of SN74 is
	-- Internal signals
	signal DS: std_logic_vector(1 downto 0) := (others => '0');
begin
	DS <= D & S;
	Y  <= A               when DS = "00" else
		  B               when DS = "01" else
		  (others => '0') when DS = "10" else
		  (others => '0') when DS = "11" else
		  (others => 'X');
end architecture;

-- Implementation 3
-- Parallel selected assignment is required
architecture architecture3 of SN74 is
	-- Internal signals
	signal DS: std_logic_vector(1 downto 0) := (others => '0');
begin
	DS <= D & S;
	with DS select
		Y <= A               when "00",
			 B               when "01",
			 (others => '0') when "10",
			 (others => '0') when "11",
			 (others => 'X') when others;
end architecture;

-- Implementation 4
-- Sequential conditional is required (if)
architecture architecture4 of SN74 is
	-- Internal signals
	signal DS: std_logic_vector(1 downto 0) := (others => '0');
	signal ALARM: std_logic := '0';
begin
	DS <= D & S;
	ALARM <= '1' when D = 'X' or S = 'X' else '0';
	process (A, B, D, S, ALARM) begin
		if    DS = "00" then Y <= A;
		elsif DS = "01" then Y <= B;
		elsif DS = "10" then Y <= (others => '0');
		elsif DS = "11" then Y <= (others => '0');
		else                 Y <= (others => 'X');
		end if;
	end process;
end architecture;

-- Implementation 5
-- Sequential selection operator is required (case)
architecture architecture5 of SN74 is
	-- Internal signals
	signal DS: std_logic_vector(1 downto 0) := (others => '0');
	signal ALARM: std_logic := '0';
begin
	DS <= D & S;
	ALARM <= '1' when D = 'X' or S = 'X' else '0';
	process (A, B, D, S, ALARM) begin
		case DS is
			when "00"   => Y <= A;
			when "01"   => Y <= B;
			when "10"   => Y <= (others => '0');
			when "11"   => Y <= (others => '0');
			when others => Y <= (others => 'X');
		end case;
	end process;
end architecture;
