#!/bin/bash

init () {
	rm -rf builds src
	mkdir -p src

	for i in `seq -w 00 09`
	do
		cat >src/fn_$i.cc <<-EOF
			#include <iostream>
			void fn_$i() {
			   std::cout << "$i" << std::endl;
			}
		EOF
	done

	cat >>src/main.cc <<-EOF
	int main () {
	EOF
	for i in `seq -w 00 04`
	do
		cat >>src/main.cc <<-EOF
			   extern void fn_$i ();
			   fn_$i ();
		EOF
	done
	cat >>src/main.cc <<-EOF
		}
	EOF
}

build () {

	for i in a b c
	do
		cmake -S . -B builds/$i
		cmake --build builds/$i
	done
}

generate_build () {
	SRC_DIR=$PWD
	for i in a b c
	do
		mkdir -p builds/$i/coverage-reports/gcovr
		cd builds/$i
		gcovr --gcov-executable /usr/bin/gcov \
			--root $SRC_DIR \
			--xml --xml-pretty --output coverage-reports/gcov-results.xml &
		cd -
	done
}

generate_root () {
	SRC_DIR=$PWD
	for i in a b c
	do
		mkdir -p builds/$i/coverage-reports/gcovr
		gcovr --gcov-executable /usr/bin/gcov \
			--root $SRC_DIR \
			--xml --xml-pretty --output builds/$i/coverage-reports/gcov-results.xml \
			builds/$i &
		cd -
	done
}

init
build
#generate_build
generate_root

