import qbs

CppApplication {
	Depends {
		name: "cpp"
	}
	cpp.cxxLanguageVersion: "c++20"
	cpp.includePaths: ["src"]
	name: "TestBench3"
	files: ["src/*.cpp"]
}
