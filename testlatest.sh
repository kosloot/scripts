#! /bin/sh

wd=/tmp/testdownloads
if test -d $wd
then
    rm -rf $wd
fi

mkdir $wd
cd $wd
echo "Testing in directory $wd"

files='ticcutils timbl timblserver mbt mbtserver libfolia ucto frogdata frog dimbl'
for file in $files
do
    wget http://software.ticc.uvt.nl/$file-latest.tar.gz > /dev/null 2>&1
    if test -e $file-latest.tar.gz
    then
	echo "downloaded $file"
	tar zxf $file-latest.tar.gz
    else
	echo "unable te find $file"
	exit
    fi
done

# configure and make all
for file in $files
do
    for dir in $file-*
    do
	if test -d $dir
	then
	    cd $dir
	    echo "configuring $file in $dir"
	    ./configure --prefix=$wd > $wd/$file.log 2>&1
	    echo "making $file in $dir"
	    make install >> $wd/$file.log 2>&1
	    cd $wd
	fi
    done
done

echo "voor test"
pwd

# poor mans test
testfiles='timbl timblserver mbt mbtserver ucto frog dimbl'
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
