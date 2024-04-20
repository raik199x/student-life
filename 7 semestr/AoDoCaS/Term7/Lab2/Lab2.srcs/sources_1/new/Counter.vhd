----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2023 17:13:20
-- Design Name: 
-- Module Name: Counter - custom
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

-- Category: SYNCHRONOUS 4-BIT UP/DOWN BINARY COUNTERS WITH 3-STATE OUTPUTS
-- THAT IS A LIE! IF FACT IT IS NOT BINARY BUT DECADE COUNTER (AKA BCD)
-- Implementation: custom Counter
entity Counter is
	-- Generics
	generic (
		WIDTH: positive := 4
	);
	-- Ports
	port (
		-- Input pins (control)
		OE:   in  std_logic;
		UD:   in  std_logic;
		CLK:  in  std_logic;
		ENT:  in  std_logic;
		ENP:  in  std_logic;
		SCLR: in  std_logic;
		LOAD: in  std_logic;
		ACLR: in  std_logic;
		-- Input pins (data)
		D:    in  std_logic_vector(WIDTH - 1 downto 0);
		-- Output pins (status)
		CCO:  out std_logic;
		RCO:  out std_logic;
		-- Output pins (data)
		Q:    out std_logic_vector(WIDTH - 1 downto 0)
	);
end entity;

-- |----------------------------------------------------------------------|
-- |                            Function table                            |
-- |----|------|------|------|-----|-----|-----|-----|--------------------|
-- | __ | ____ | ____ | ____ | ___ | ___ |   _ |     |                    |
-- | OE | ACLR | SCLR | LOAD | ENT | ENP | U/D | CLK | Operation          |
-- |----|------|------|------|-----|-----|-----|-----|--------------------|
-- | H  |  X   |  X   |  X   |  X  |  X  |  X  |  X  | Q outputs disabled |
-- | L  |  L   |  X   |  X   |  X  |  X  |  X  |  X  | Asynchronous clear |
-- | L  |  H   |  L   |  X   |  X  |  X  |  X  |  ↑  | Synchronous clear  |
-- | L  |  H   |  H   |  L   |  X  |  X  |  X  |  ↑  | Load               |
-- | L  |  H   |  H   |  H   |  L  |  L  |  H  |  ↑  | Count up           |
-- | L  |  H   |  H   |  H   |  L  |  L  |  L  |  ↑  | Count down         |
-- | L  |  H   |  H   |  H   |  H  |  X  |  X  |  X  | Inhibit count      |
-- | L  |  H   |  H   |  H   |  X  |  H  |  X  |  X  | Inhibit count      |
-- |----|------|------|------|-----|-----|-----|-----|--------------------|
architecture custom of Counter is
	-- Constants
	constant INV_C: boolean := false;
	constant INV_R: boolean := true;
	-- Internal signals: DIR, CTL
	signal DIR_U: std_logic;
	signal DIR_D: std_logic;
	signal CTL:   std_logic_vector(6 downto 0);
	-- Internal signals: XB, DVC
	signal XB:    std_logic_vector(WIDTH - 1 downto 0);
	signal DVC:   std_logic_vector(WIDTH - 1 downto 0);
	-- INternal signals XB, DV[A, B, C], DV, QV, R
	signal XC:    std_logic_vector(WIDTH - 1 downto 0);
	signal DVA:   std_logic_vector(WIDTH - 1 downto 0);
	signal DVB:   std_logic_vector(WIDTH - 1 downto 0);
	signal DV:    std_logic_vector(WIDTH - 1 downto 0);
	signal QV:    std_logic_vector(WIDTH - 1 downto 0);
	signal R:     std_logic_vector(WIDTH - 1 downto 0);
	-- Internal signals: W
	signal W:     std_logic_vector(2 downto 1);
begin
	-- DIR
	DIR_U <= UD;
	DIR_D <= not UD;
	-- CTL
	CTL(0) <= SCLR and LOAD;
	CTL(1) <= SCLR and not LOAD;
	CTL(2) <= not ENT and not ENP and SCLR and not CTL(1);
	CTL(3) <= DIR_U and R(3) and R(2) and R(1) and R(0) and not ENT;
	CTL(4) <= not ENT and R(0) and R(1) and R(2) and R(3) and DIR_D;
	CTL(5) <= not (CTL(3) or CTL(4));
	CTL(6) <= not ENT and not ENP;
	-- XB
	XB(0) <= not CTL(2);
	XB(1) <= not (R(0) and CTL(2));
	XB(2) <= not (R(0) and R(1) and CTL(2));
	XB(3) <= not (R(0) and CTL(2));
	-- DVC
	DVC(0) <= CTL(2) and XC(0);
	DVC(1) <= R(0) and CTL(2) and W(2) and W(1) and not QV(1);
	DVC(2) <= R(1) and R(0) and CTL(2) and XC(2) and W(2);
	DVC(3) <= R(2) and R(1) and R(0) and CTL(2) and XC(3);

	-- XC, DV[A, B], DV, QV, R
	GENERATOR: for N in 0 to WIDTH - 1 generate
		XC(N) <= not (QV(N) and CTL(0));
		DVA(N) <= D(N) and CTL(1);
		DVB(N) <= XB(N) and CTL(0) and QV(N);
		DV(N) <= DVA(N) or DVB(N) or DVC(N);
		DFF: entity work.DFlipFlop(custom)
			generic map (INV_C => INV_C, INV_R => INV_R)
			port map (C => CLK, D => DV(N), R => ACLR, Q => QV(N));
		R(N) <= not ((not QV(N) and DIR_U) or (QV(N) and DIR_D));
	end generate;

	-- W
	W(1) <= not (DIR_U and R(3));
	W(2) <= not (not QV(2) and DIR_D and not QV(3));
	-- CCO
	CCO <= not (not CLK and CTL(6) and not CTL(5));
	-- RCO
	RCO <= CTL(5);
	-- Q
	OUTPUT: for N in 0 to WIDTH - 1 generate
		Q(N) <= QV(N) when OE = '0' else 'Z';
	end generate;
end architecture;
