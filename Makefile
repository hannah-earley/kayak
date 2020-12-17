CXX=g++

all: kayak test

kayak: kayak.cpp
	$(CXX) -o $@ $^

test: kayak
	@echo "Running tests..."
	/bin/bash -c 'diff -q <(cat invert.kayak | ./kayak invert.kayak | ./kayak invert.kayak) invert.kayak'

.PHONY: all test