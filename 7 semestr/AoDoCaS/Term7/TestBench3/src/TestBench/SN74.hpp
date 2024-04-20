#pragma once

#include <Emulation/SN74.hpp>

auto TestBenchSN74(void) -> void {
	SN74 device;
	std::ofstream log;
	log.open("./tests/SN74.txt");
	log << device.header();
	for (std_logic int_d : {L, H})
		for (std_logic int_s : {L, H})
			for (usize int_a = 0; int_a < (1 << N); ++int_a)
				for (usize int_b = 0; int_b < (1 << N); ++int_b) {
					device.D = int_d;
					device.S = int_s;
					device.A = vectorize(int_a);
					device.B = vectorize(int_b);
					log << device.snapshot();
				}
	log << device.x();
	log.close();
}
