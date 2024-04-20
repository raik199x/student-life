#pragma once

#include <std.hpp>

class SN74 {
public:
	std_logic D, S;
	std_logic_vector A, B;
public:
	SN74(void) : D(U), S(U) {
		A.fill(U);
		B.fill(U);
	}
public:
	auto Y(void) const -> std_logic_vector {
		std_logic_vector Y;
		if (D) Y.fill(L);
		else switch(S) {
			case L: Y = A; break;
			case H: Y = B; break;
			default: Y.fill(Z); break;
		}
		return Y;
	}
	auto header(void) const -> std::string_view {
		return "D           S           A3          A2          A1          A0          B3          B2          B1          B0          Y3          Y2          Y1          Y0         \n";
	}
	auto snapshot(void) const -> std::string {
		const std_logic_vector Y = this->Y();
		auto buffer = std::stringstream();
		buffer << D << ' ' << S;
		for (usize i = 0; i < N; ++i)
			buffer << ' ' << A[N - 1 - i];
		for (usize i = 0; i < N; ++i)
			buffer << ' ' << B[N - 1 - i];
		for (usize i = 0; i < N; ++i)
			buffer << ' ' << Y[N - 1 - i];
		buffer << '\n';
		return buffer.str();
	}
	auto x(void) const -> std::string {
		auto buffer = std::stringstream();
		buffer << X << ' ' << X;
		for (usize i = 0; i < N; ++i)
			buffer << ' ' << X;
		for (usize i = 0; i < N; ++i)
			buffer << ' ' << X;
		for (usize i = 0; i < N; ++i)
			buffer << ' ' << X;
		buffer << '\n';
		return buffer.str();
	}
};
