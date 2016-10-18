#! /bin/sh

wd=/tmp/testdownloads
if test -d $wd
then
    rm -rf $wd
fi

mkdir $wd
cd $wd
echo "Testing in directory $wd"

files='ticcutils timbl timblserver mbt mbtserver libfolia uctodata ucto frogdata frog dimbl foliautils' # ticcltools'
for file in $files
do
    curl -o $file.curl -s -L https://github.com/LanguageMachines/$file/releases/latest
    grep "releases/download/" $file.curl > $file.bla
    sed "s/^ *<a href=\"//g" -i $file.bla
    line=$(sed "s/\" rel=\"nofollow\">//g" $file.bla)
    wget http://github.com/$line > /dev/null 2>&1
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
