#!/bin/bash 
config_file=${HOME}/.profile
current_path=$(pwd)

THE_TOOLCHAIN_IS=
read -p "Select toolchain? 1)608; 2)628; 3)638; 4)338; :" temp
if [ "$temp" == "1" ]; then
	THE_TOOLCHAIN_IS="608"
elif [ "$temp" == "2" ]; then
	THE_TOOLCHAIN_IS="628"
elif [ "$temp" == "3" ]; then
	THE_TOOLCHAIN_IS="638"
elif [ "$temp" == "4" ]; then
        THE_TOOLCHAIN_IS="338"
fi

if [ ${THE_TOOLCHAIN_IS:-none} == "none" ]; then
echo "error, please retry!"
else

echo -e "Current toolchain is \033[0;32;40m $THE_TOOLCHAIN_IS \033[0m"

test_if_exist=`grep -o "^export PATH=" ${config_file}`

if [ "$test_if_exist" == "" ]; then
	echo "export PATH=test" >> ${config_file}
fi
	
test_if_exist=`grep -o "^export LOCALTOOLCHAIN=" ${config_file}`

if [ "$test_if_exist" == "" ]; then
	echo "export LOCALTOOLCHAIN=test" >> ${config_file}
fi

if [ "$THE_TOOLCHAIN_IS" == "608" ]; then	
	sed -i 's#export PATH=.*#export PATH=/opt/toolchain/jdk1.6.0_31/bin:/opt/toolchain/jdk1.6.0_31/jre/bin:/opt/arm-2010.09/bin:/opt/arm-2011.03/bin:$PATH#g' ${config_file}
elif [ "$THE_TOOLCHAIN_IS" == "628" ]; then
	sed -i 's#export PATH=.*#export PATH=/opt/toolchain/jdk1.6.0_31/bin:/opt/toolchain/jdk1.6.0_31/jre/bin:/opt/arm-2012.09/bin:/opt/arm_eabi-2011.03/bin:/opt/r2-elf-linux-1.3.5.14/bin:$PATH#g' ${config_file}
elif [ "$THE_TOOLCHAIN_IS" == "638" ]; then	
	sed -i 's#export PATH=.*#export PATH=/opt/linaro-aarch64_linux-2014.09_843419-patched/bin:/opt/arm-2012.09_638/bin/:/opt/arm_eabi-2011.03/bin:/opt/java-7-openjdk-amd64/bin:opt/java-7-openjdk-amd64/jre/bin:opt/r2-elf-linux-1.3.5.14/bin:$PATH#g' ${config_file}
elif [ "$THE_TOOLCHAIN_IS" == "338" ]; then
	sed -i 's#export PATH=.*#export PATH=/opt/toolchain/jdk1.6.0_31/bin:/opt/toolchain/jdk1.6.0_31/jre/bin:/opt/arm-2012.09/bin:/opt/arm_eabi-2011.03/bin:/opt/r2-elf-linux-1.3.5.14/bin:$PATH#g' ${config_file}
fi
sed -i "s#export LOCALTOOLCHAIN=.*#export LOCALTOOLCHAIN=${THE_TOOLCHAIN_IS}#"  ${config_file}
source /etc/environment
source /etc/profile
source ${config_file}

cd ${current_path}
fi
