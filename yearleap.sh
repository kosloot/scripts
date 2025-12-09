#! /bin/sh

h_files=`ls include/*/*.h`
cxx_files=`ls src/*.cxx`
cc_files=`ls src/*.cc`
for file in  $h_files $cxx_files $cc_files README README.md
do
    echo try $file
    if test -f $file
    then
	sed -i s/\ 2024\ /\ 2026\ /g $file
	sed -i s/\ 2024$/\ 2026/g $file
	sed -i s/\ 2025\ /\ 2026\ /g $file
	sed -i s/\ 2025$/\ 2026/g $file
   fi
done
