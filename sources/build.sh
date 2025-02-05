#!/bin/sh
set -e

# Go the sources directory to run commands
SOURCE="${BASH_SOURCE[0]}"
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
cd $DIR
echo $(pwd)

rm -rf ../fonts

echo "Generating Static fonts"
mkdir -p ../fonts/ttf
mkdir -p ../fonts/variable
fontmake -m IbarraRealNova.designspace -i -o ttf --output-dir ../fonts/ttf/

echo "Generating VFs"
fontmake -m IbarraRealNova.designspace -o variable --output-dir ../fonts/variable/

rm -rf master_ufo/ instance_ufo/ instance_ufos/

ttfs=$(ls ../fonts/ttf/*.ttf)
vfs=$(ls ../fonts/variable/*.ttf)

echo "Fixing Hinting"
for vf in $vfs
do
	gftools fix-nonhinting $vf $vf;
	if [ -f "$vf.fix" ]; then mv "$vf.fix" $vf; fi
done

for ttf in $ttfs
do
	gftools fix-nonhinting $ttf $ttf;
	if [ -f "$ttf.fix" ]; then mv "$ttf.fix" $ttf; fi
done

rm -f ../fonts/variable/*.ttx
rm -f ../fonts/ttf/*.ttx
rm -f ../fonts/variable/*gasp.ttf
rm -f ../fonts/ttf/*gasp.ttf

echo "Done"
