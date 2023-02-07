#!/bin/bash

# Install nvidia drivers
# Debian
#   1. Enable non-free repositories
#   2. sudo apt-get update
#   3. sudo apt-get install nvidia-driver
#   4. sudo reboot
# Ubuntu
#   1. Open "Software & Updates"
#   2. Go to "Additional Drivers" Tab
#   3. Select Drives and click "Apply Changes"
#   4. sudo reboot





# sudo apt-get install sysbench
# sysbench --threads=4 cpu run

dpkg -s "nvidia-smi" > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    echo "Error: nvidia-smi package not installed."
    exit 1
fi






Command="${@}"
echo "Running Command: ${Command}"

FilePrefix=$(echo "${@}" | sed 's/ /_/g' | sed 's/[.]/_/g' | sed 's./._.g')
#echo "File Prefix: ${FilePrefix}"




nGpus=$(nvidia-smi -q | grep "Attached GPUs" | cut -d: -f2 | xargs)
cpumodel=$(grep -m 1 "^model name" /proc/cpuinfo | sed 's/.*: //g')
cpucores=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
cputhreads=$(grep -c ^processor /proc/cpuinfo)



#LOGFILENAME="${FilePrefix}-log.txt"
if [ ! -z "${LOGFILENAME}" ]; then

	# Clear the log
	echo "" > ${LOGFILENAME}
	echo "Starting Log" >> ${LOGFILENAME}
	date >> ${LOGFILENAME}


	echo "" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "CPU Info" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "" >> ${LOGFILENAME}

	echo -e "\tModel: ${cpumodel}" >> ${LOGFILENAME}
	echo -e "\tCores: ${cpucores}" >> ${LOGFILENAME}
	echo -e "\tThreads: ${cputhreads}" >> ${LOGFILENAME}
	echo "" >> ${LOGFILENAME}
	cat /proc/cpuinfo >> ${LOGFILENAME}
	echo "" >> ${LOGFILENAME}
	lscpu >> ${LOGFILENAME}



	echo "" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "GPU Info" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "" >> ${LOGFILENAME}
	
	echo "nGpus: ${nGpus}">> ${LOGFILENAME}
	echo "" >> ${LOGFILENAME}
	nvidia-smi -q >> ${LOGFILENAME}



	echo "" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "top -bn1" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "" >> ${LOGFILENAME}

	top -bn1 >> ${LOGFILENAME}

	echo "" >> ${LOGFILENAME}

	top -bn1 1 >> ${LOGFILENAME}



	echo "" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "Command Information" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "--------------------------------------------------------------------------" >> ${LOGFILENAME}
	echo "" >> ${LOGFILENAME}

	echo "Command: ${Command}" >> ${LOGFILENAME}

fi














DATAFILENAME="${FilePrefix}-data.csv"

#cpuheaders="CPU Utilization [%]"
cpuheaders=""
for i in $(seq 1 1 $cputhreads)
do
    cpuheaders="${cpuheaders},CPU Thread $i Utilization [%]"
done
ramheaders="RAM Utilization [%], RAM Total [GB], RAM Used [GB], Swap Total [GB], Swap Used [GB]"
cpuheaders=$(echo "${cpuheaders}" | sed 's/^,//g')
#gpuheaders=$(nvidia-smi --query-gpu=utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv | head -1)
gpuheaders="GPU 1 Utilization [%],GPU 1 Memory Utilization [%],GPU 1 Memory Total [MiB],GPU 1 Memory Free [MiB],GPU 1 Memory Used [MiB]"
gpuheaders="${gpuheaders},GPU 2 Utilization [%],GPU 2 Memory Utilization [%],GPU 2 Memory Total [MiB],GPU 2 Memory Free [MiB],GPU 2 Memory Used [MiB]"
gpuheaders="${gpuheaders},GPU 3 Utilization [%],GPU 3 Memory Utilization [%],GPU 3 Memory Total [MiB],GPU 3 Memory Free [MiB],GPU 3 Memory Used [MiB]"
gpuheaders="${gpuheaders},GPU 4 Utilization [%],GPU 4 Memory Utilization [%],GPU 4 Memory Total [MiB],GPU 4 Memory Free [MiB],GPU 4 Memory Used [MiB]"
headers="timestamp,seconds elapsed,${ramheaders},${cpuheaders},${gpuheaders}"
echo "${headers}" >> ${DATAFILENAME}








begin=$(date +%s)
# Delay time in seconds (0.1, 0.5, 1)
ticktime=1

#Command="dummyCommand"
TIMEFILENAME="${FilePrefix}-time.txt"
OUTFILENAME="${FilePrefix}-out.txt"
#mytime=$(time eval "${Command}" > "${OUTFILENAME}" 2>&1 &)
{ time eval "${Command}"; } > "${OUTFILENAME}" 2>&1 &
CommandPID=$!
echo "Command PID: ${CommandPID}"

#echo "Capturing Performance Data... Press q to exit"
while true; do
    now=$(date +%s)
    diff=$(($now - $begin))
    mins=$(($diff / 60))
    secs=$(($diff % 60))
    hours=$(($diff / 3600))
    days=$(($diff / 86400))

    # \r  is a "carriage return" - returns cursor to start of line
    # with \33[2K we clear the current line
    printf "\33[2K\r%3d Days, %02d:%02d:%02d" $days $hours $mins $secs

    # -n 1 to get one character at a time, -t 0.1 to set a timeout 
    read -n 1 -t ${ticktime} input                  # so read doesn't hang
    if [[ $input = "qq" ]] || [[ $input = "QQ" ]] 
    then
    		echo "Killing Command: ${Command} ..."
    		kill -0 ${CommandPID}
        echo # to get a newline after quitting
        break
    fi
    
    ps -p ${CommandPID} > /dev/null 2>&1
    if [ $? -ne 0 ]; then
			echo # to get a newline after quitting
			break
		fi

    


    datevalue=$(date --utc +%FT%TZ)
    selapsed="${diff}"
    datevalues="${datevalue},${selapsed}"

    ramutilization=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
    # Remove % and spaces
    ramutilization=$(echo "${ramutilization}" | sed 's/%//g' | sed 's/ //g')
    ramtotal=$(free | grep "Mem:" | awk '{printf $2/1000/1000 "\n"}')
    ramused=$(free | grep "Mem:" | awk '{printf $3/1000/1000 "\n"}')
    #ramfree=$(free | grep "Mem:" | awk '{printf $4/1000/1000 "\n"}')
    swaptotal=$(free | grep "Swap:" | awk '{printf $2/1000/1000 "\n"}')
    swapused=$(free | grep "Swap:" | awk '{printf $3/1000/1000 "\n"}')
    #swapfree=$(free | grep "Swap:" | awk '{printf $4/1000/1000 "\n"}')
    ramvalues="${ramutilization},${ramtotal},${ramused},${swaptotal},${swapused}"

    cpugrep=$(top -bn1)
    cputotal=$(echo "${cpugrep}" | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}' | sed 's/ //g')
    # Remove % and spaces
    #cputotal=$(echo "${cputotal}" | sed 's/%//g' | sed 's/ //g')
    #cpucores=$(echo "${cpugrep}" | grep "Cpu(s)" | sed 's/.*Cpu(s)://g' | sed 's/[^0-9,.]*//g')
    cpucores=$(top bn1 1 | sed 's/%/\n/g' | grep "^Cpu" | sed 's/Cpu.*://g' | sed 's/..,//g' | awk '{printf ($1+$2+$3) "\n"}' | tr '\n' ',' | sed 's/,$//g')
    #cpuvalues="${cputotal},${cpucores}"
    cpuvalues="${cpucores}"

    

    gpuvalues=$(nvidia-smi --query-gpu=utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv | tail -n +2 | tr '\n' ', ' | sed 's/%//g' | sed 's/MiB//g')
    # Remove % and spaces
    gpuvalues=$(echo "${gpuvalues}" | sed 's/%%//g')

    values="${datevalues},${ramvalues},${cpuvalues},${gpuvalues}"
    echo "${values}" >> ${DATAFILENAME}

done

