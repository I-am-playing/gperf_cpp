NAME=command_line

CXX_FLAGS=-std=c++11 -I gen/
LD_FLAGS=-lstdc++

.PHONY: all
all: bin/${NAME}
	@echo "" > /dev/null

.PHONY: clean
clean:
	rm -rf gen
	rm -rf bin

.PHONY: run
run: bin/${NAME}
	@echo "Running:  '$< +helpverbose -xyz +nolog'"
	@./$< +helpverbose -xyz +nolog

gen:
	@echo "Creating: $@"
	@mkdir -p $@

gen/perfecthash.h: gperf/command_line_options.gperf inc/command_options.h | gen
	@echo "gperf:    $@"
	@gperf -CGD -N IsValidCommandLineOption -K Option -L C++ -t $< > $@

bin:
	@echo "Creating: $@"
	@mkdir -p $@

bin/${NAME}: src/main.cpp gen/perfecthash.h inc/command_options.h | bin
	@echo "Building: $@"
	@$(CXX) $< ${CXX_FLAGS} ${LD_FLAGS} -o $@
