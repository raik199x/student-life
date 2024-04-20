----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2023 14:10:14
-- Design Name: 
-- Module Name: Circuit - architecture1
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

entity Circuit is
	port (
		ledsmain    : out STD_LOGIC_VECTOR(3 DOWNTO 0);
		ledsboard   : out STD_LOGIC_VECTOR(3 DOWNTO 0);
		pushbuttons : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		dipswitch   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		--clock diff pair
		sysclk_p    : in  STD_LOGIC;
		sysclk_n    : in  STD_LOGIC
	);
end entity;

architecture architecture1 of Circuit is
	COMPONENT ibufds
	PORT (
		i, ib : IN  STD_LOGIC;
		o     : OUT STD_LOGIC
	);
	END COMPONENT;
	component Divider is
		port (
			CLK_IN:  in  std_logic;
			CLK_OUT: out std_logic
		);
	end component;
	component Counter is
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
	end component;

	signal CLOCK, CLOCK_C : std_logic;
	signal CLK_NO_DIV : std_logic;
	signal SCLR_TMP, LOAD_TMP, ACLR_TMP : std_logic;
	signal D_TMP: std_logic_vector(3 downto 0);
begin
	CLOCK_C <= CLOCK;
	Divider1: Divider port map (
		CLK_IN => CLK_NO_DIV,
		CLK_OUT => CLOCK
	);
	buffds : ibufds port map (
		i => sysclk_p,
		ib => sysclk_n,
		o => CLK_NO_DIV
	);

	ledsmain(0) <= CLOCK_C;
	ledsmain(3) <= CLOCK_C;
	SCLR_TMP    <= not pushbuttons(1);
	LOAD_TMP    <= not pushbuttons(2);
	ACLR_TMP    <= not pushbuttons(3);
	D_TMP       <= pushbuttons(0) & not pushbuttons(4) & not pushbuttons(4) & not pushbuttons(4);
	Counter1: Counter generic map (WIDTH => 4) port map (
			OE   => dipswitch(0),
			UD   => dipswitch(1),
			CLK  => CLOCK_C,
			ENT  => dipswitch(2),
			ENP  => dipswitch(3),
			SCLR => SCLR_TMP,
			LOAD => LOAD_TMP,
			ACLR => ACLR_TMP,
			D    => D_TMP,
			CCO  => ledsmain(1),
			RCO  => ledsmain(2),
			Q    => ledsboard
		);
end architecture;
