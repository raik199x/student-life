#pragma once

#include <std.hpp>

class Counter {
public:
	std_logic OE, ACLR, SCLR, LOAD, ENP, ENT, UD, CLK;
	std_logic_vector D;
private:
	std_logic CLK_OLD;
	std_logic_vector QV;
public:
	Counter(void) : OE(U), ACLR(U), SCLR(U), LOAD(U), ENP(U), ENT(U), UD(U), CLK(U), D({}), CLK_OLD(U) {
		D.fill(U);
		QV.fill(U);
	}
private:
	auto front(void) const -> bool {
		return CLK_OLD == L && CLK == H;
	}
public:
// |----------------------------------------------------------------------|
// |                            Function table                            |
// |----|------|------|------|-----|-----|-----|-----|--------------------|
// | __ | ____ | ____ | ____ | ___ | ___ |   _ |     |                    |
// | OE | ACLR | SCLR | LOAD | ENT | ENP | U/D | CLK | Operation          |
// |----|------|------|------|-----|-----|-----|-----|--------------------|
// | H  |  X   |  X   |  X   |  X  |  X  |  X  |  X  | Q outputs disabled |
// | L  |  L   |  X   |  X   |  X  |  X  |  X  |  X  | Asynchronous clear |
// | L  |  H   |  L   |  X   |  X  |  X  |  X  |  ↑  | Synchronous clear  |
// | L  |  H   |  H   |  L   |  X  |  X  |  X  |  ↑  | Load               |
// | L  |  H   |  H   |  H   |  L  |  L  |  H  |  ↑  | Count up           |
// | L  |  H   |  H   |  H   |  L  |  L  |  L  |  ↑  | Count down         |
// | L  |  H   |  H   |  H   |  H  |  X  |  X  |  X  | Inhibit count      |
// | L  |  H   |  H   |  H   |  X  |  H  |  X  |  X  | Inhibit count      |
// |----|------|------|------|-----|-----|-----|-----|--------------------|
	auto Q(void) -> std_logic_vector {
		// Asynchronous clear
		if (ACLR == L) {
			QV.fill(L);
		}
		// Synchronous clear
		if (ACLR == H && SCLR == L && front()) {
			QV.fill(L);
		}
		// Load
		if (ACLR == H && SCLR == H && LOAD == L && front()) {
			QV = D;
		}
		// Inhibit count else
		if (ACLR == H && SCLR == H && LOAD == H && ENT == L && ENP == L && front()) {
			usize current_value = numerate(QV);
			if (UD == H) {
				if (current_value != 9) ++current_value;
				else current_value = 0;
			}
			if (UD == L) {
				if (current_value != 0) --current_value;
				else current_value = 9;
			}
			QV = vectorize(current_value);
		}
		// Save CLK
		CLK_OLD = CLK;
		// Output
		std_logic_vector Q = QV;
		if (OE == H)
			Q.fill(Z);
		return Q;
	}
	auto RCO(void) const -> std_logic {
		return static_cast<std_logic>(!(ACLR == H && SCLR == H && LOAD == H && ENT == L && ENP == L && UD == L && numerate(QV) == 0));
	}
	auto CCO(void) const -> std_logic {
		return static_cast<std_logic>(!(!static_cast<bool>(RCO()) && CLK == L));
	}
	auto header(void) const -> std::string_view {
		return "OE          ACLR        SCLR        LOAD        ENP         ENT         U/D         CLK         D3          D2          D1          D0          Q3          Q2          Q1          Q0          RCO         CCO         [D] [QV]\n";
	}
	auto snapshot(void) -> std::string {
		const std_logic_vector Q = this->Q();
		auto buffer = std::stringstream();
		buffer << OE << ' ' << ACLR << ' '
			<< SCLR << ' ' << LOAD << ' '
			<< ENP << ' ' << ENT << ' '
			<< UD << ' ' << CLK;
		for (usize i = 0; i < N; ++i)
			buffer << ' ' << D[N - 1 - i];
		for (usize i = 0; i < N; ++i)
			buffer << ' ' << Q[N - 1 - i];
		buffer << ' ' << RCO() << ' ' << CCO() << " (" << numerate(QV) << ") (" << numerate(D) << ")\n";
		return buffer.str();
	}
	auto x(void) -> std::string {
		auto buffer = std::stringstream();
		buffer << X << ' ' << X << ' '
			<< X << ' ' << X << ' '
			<< X << ' ' << X << ' '
			<< X << ' ' << X;
		for (usize i = 0; i < N; ++i)
			buffer << ' ' << X;
		for (usize i = 0; i < N; ++i)
			buffer << ' ' << X;
		buffer << ' ' << X << ' ' << X << " (X) (X)\n";
		return buffer.str();
	}
};
