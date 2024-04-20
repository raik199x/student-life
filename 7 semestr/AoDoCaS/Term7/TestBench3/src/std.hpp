#pragma once

#include <array>
#include <sstream>
#include <fstream>

using usize = size_t;
static constexpr const usize N = 4;

typedef enum {
	L,
	H,
	U,
	X,
	Z,
} std_logic;
using std_logic_vector = std::array<std_logic, N>;

auto operator <<(std::ostream& stream, const std_logic bit) -> std::ostream& {
	switch (bit) {
		case  L: return stream << "false false";
		case  H: return stream << "false true ";
		case  X: return stream << "true  false";
		case  Z: return stream << "true  true ";
		default: return stream << "error error";
	};
}

auto vectorize(const usize value) -> std_logic_vector {
	if (value >= (1 << N)) throw "Invalid value";
	std_logic_vector vector;
	for (usize i = 0; i < N; ++i)
		vector[i] = static_cast<std_logic>((value & (1 << i)) != 0);
	return vector;
}

auto numerate(const std_logic_vector vector) -> usize {
	usize value = 0;
	for (usize i = 0; i < N; ++i) {
		const std_logic bit = vector[N - 1 - i];
		if (bit != H && bit != L)
			throw "Invalid bit value";
		value <<= 1;
		value |= (bit == H) ? 1 : 0;
	}
	return value;
}
