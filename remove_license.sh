#!/bin/bash

srcfile=${1:-dummy}

if [[ "${srcfile}" == "dummy" ]]; then
	#statements
	echo "usage: ${BASH_SOURCE[0]} dst-file-name"
	exit; #return;
fi

rm -rf local_tmp
mkdir local_tmp
dd if=${srcfile} of="local_tmp/tmp_script.bin"  bs=16k count=1
sed -n '1,/this is end of script symbol/p' local_tmp/tmp_script.bin > local_tmp/tmp_script.txt
rm local_tmp/tmp_script.bin

grep "license"  local_tmp/tmp_script.txt >/dev/null
if [[ $? -ne 0 ]]; then
	#statements
	echo "no license partion in file, exit"
	exit
fi

sed -i '/# File Partition: license/,/mmc unlzo.*license/d' local_tmp/tmp_script.txt
totalsize=$(stat -c%s ${srcfile})
paddedscriptsize=$((0x4000))
scriptsize=$(stat -c%s local_tmp/tmp_script.txt)
required=$((${paddedscriptsize} - ${scriptsize}))
cat local_tmp/tmp_script.txt > local_tmp/tmp_script
rm local_tmp/tmp_script.txt
for ((i=0;i<${required};i++)); do
	printf "\xff" >> local_tmp/tmp_script
done

cat local_tmp/tmp_script > local_tmp/target.bin
#
dd if=${srcfile} of="local_tmp/tmp.bin" bs=$((0x4000)) skip=1 count=200K
echo "${totalsize} - 16 - 8 - 0x4000 = $((${totalsize} - 16 - 8 - 0x4000))"
dd if="local_tmp/tmp.bin" of="local_tmp/tmptmp.bin" bs=$((${totalsize} - 16 - 8 - 0x4000)) count=1
rm local_tmp/tmp.bin
#dd if=${srcfile} of=local_tmp/tmptmp.bin bs=1 skip=0x4000 count=$((${totalsize} - 16 - 8 - 0x4000))
cat local_tmp/tmptmp.bin >> local_tmp/target.bin
./crc -a local_tmp/tmp_script
split -d -a 2 -b $((0x4000)) local_tmp/tmp_script tmp_script.
cat tmp_script.01 >> local_tmp/target.bin
rm tmp_script.*
./crc -a local_tmp/target.bin
dd if=local_tmp/tmp_script of=local_tmp/first_16.bin bs=16 count=1
cat local_tmp/first_16.bin >> local_tmp/target.bin
rm local_tmp/first_16.bin
mv local_tmp/target.bin local_tmp/MstarUpgrade.bin
