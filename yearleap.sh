#! /bin/sh

h_files=`ls include/*/*.h`
cxx_files=`ls src/*.cxx`
for file in  $h_files $cxx_files README README.md
do
    echo try $file
    if test -f $file
    then
	sed -i s/\ 2016\ /\ 2017\ /g $file
	sed -i s/\ 2016$/\ 2017/g $file
   fi
done
