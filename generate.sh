#!/bin/bash

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

cat >>src/main.cc <<EOF
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

for i in a b c
do
	cmake -S . -B builds/$i
	cmake --build builds/$i
done

for i in a b c
do
	mkdir -p builds/$i/coverage-reports/gcovr
	gcovr --gcov-executable /usr/bin/gcov \
		--root $PWD \
		--xml --xml-pretty --output $PWD/builds/$i/coverage-reports/gcov-results.xml \
		builds/$i &
done
