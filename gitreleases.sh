#! /bin/bash

OK="\033[1;32m OK  \033[0m"
FAIL="\033[1;31m  FAILED  \033[0m"

wd=/tmp/testdownloads
if test -d $wd
then
    rm -rf $wd
fi

mkdir $wd
cd $wd
echo "Testing in directory $wd"

files='ticcutils timbl timblserver mbt mbtserver libfolia uctodata ucto frogdata frog dimbl foliautils toad ticcltools wopr'
for file in $files
do
    gh release download -A tar.gz --repo https://github.com/LanguageMachines/$file
    echo "downloaded $file"
    tar zxf $file-*.tar.gz
done

# configure and make all
for file in $files
do
    for dir in $file-*
    do
	if test -d $dir
	then
	    echo $dir
	    pushd $dir
	    echo "configuring $file in $dir"
	    sh bootstrap.sh
	    ./configure --prefix=$wd > $wd/$file.log 2>&1
	    if [ $? -ne 0 ];
	    then
		echo -e $FAIL
		popd
		echo "see $file.log"
		exit
	    fi
	    echo "making $file in $dir"
	    make -j4 install >> $wd/$file.log 2>&1
	    if [ $? -ne 0 ];
	    then
		echo -e $FAIL
		popd
		echo "see $file.log"
		exit
	    fi
	    echo "checking $file in $dir"
	    make check >> $wd/$file.log 2>&1
	    if [ $? -ne 0 ];
	    then
		echo -e $FAIL
		popd
		echo "see $file.log"
		exit
	    fi
	    popd
	fi
    done
done

echo "voor test"
pwd

# poor mans test
testfiles='timbl timblserver mbt mbtserver folialint ucto frog dimbl FoLiA-alto'
for file in $testfiles
do
    for dir in $file-*
    do
	if test -d $dir
	then
	    ./bin/$file -V
	fi
    done
done
