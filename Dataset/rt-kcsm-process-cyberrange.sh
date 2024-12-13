#!/bin/bash

IFS=$'\n'

#find . -name \*.tar.gz -execdir tar -xzvf {} \;
#find . -name \*.zip -execdir unzip -o {} \;

data_path="/home/riru/Cyberrange Dataset/dataset"
timeslice_folder="20-11-2024-15-30"   #"23-11-2024-15-57"


if [ ! -d /home/riru/rt-kcsm/data/Cyberrange/ ]
then
    mkdir /home/riru/rt-kcsm/data/Cyberrange/
fi
if [ ! -d /home/riru/rt-kcsm/data/Cyberrange/zeek-min/ ]
then
    mkdir /home/riru/rt-kcsm/data/Cyberrange/zeek-min/
fi


cd $data_path
for host in ./*/
do
    host=$(sed 's/^.\{1\}//g' <<< $host)
    if [ -d $data_path$host$timeslice_folder ]
    then
        cd $data_path$host$timeslice_folder
        for pcap in $(find . -name "*.pcapng" | sed 's/^.\{1\}//g')
        do
            echo "working on $data_path$host$timeslice_folder$pcap"
            if [ ! -d "/home/riru/rt-kcsm/data/Cyberrange/zeek-min$host" ]
            then
                mkdir "/home/riru/rt-kcsm/data/Cyberrange/zeek-min$host"
            fi
            if [ ! -d "/home/riru/rt-kcsm/data/Cyberrange/zeek-min$host$timeslice_folder" ]
            then
                mkdir "/home/riru/rt-kcsm/data/Cyberrange/zeek-min$host$timeslice_folder"
            fi

            logdir="/home/riru/rt-kcsm/data/Cyberrange/zeek-min$host$timeslice_folder/"
            echo "saving output to $logdir"

            tshark -t ad -r "$data_path$host$timeslice_folder$pcap" -Y 'dns' > "$data_path$host$timeslice_folder$pcap.dns.log"
            zeek -C -r "$data_path$host$timeslice_folder$pcap" base/init-default test-all-policy Log::default_logdir="$logdir" LogAscii::use_json=T

        done
        cd $data_path
    fi
    echo "still working.."
done

echo "now merging and filtering notices"
cd /home/riru/rt-kcsm/data/Cyberrange/zeek-min/

find /home/riru/rt-kcsm/data/Cyberrange/zeek-min/ -name "notice.log" -exec cat {} + >> merged_notice.log

grep -v "SSL::Invalid_Server_Cert\|ProtocolDetector::Protocol_Found" merged_notice.log > merged_notice_filtered1.log

grep -v "SSL::Invalid_Server_Cert\|ProtocolDetector::Protocol_Found\|Conn::Content_Gap" merged_notice.log > merged_notice_filtered_2.log

if [ ! -d /home/riru/rt-kcsm/data/Cyberrange/zeek-max/ ]
then
    mkdir /home/riru/rt-kcsm/data/Cyberrange/zeek-max/
fi

cd $data_path
for host in ./*/
do
    host=$(sed 's/^.\{1\}//g' <<< $host)
    if [ -d $data_path$host$timeslice_folder ]
    then
        cd $data_path$host$timeslice_folder
        for pcap in $(find . -name "*.pcapng" | sed 's/^.\{1\}//g')
        do
            echo "working on $data_path$host$timeslice_folder$pcap"
            if [ ! -d "/home/riru/rt-kcsm/data/Cyberrange/zeek-max$host" ]
            then
                mkdir "/home/riru/rt-kcsm/data/Cyberrange/zeek-max$host"
            fi
            if [ ! -d "/home/riru/rt-kcsm/data/Cyberrange/zeek-max$host$timeslice_folder" ]
            then
                mkdir "/home/riru/rt-kcsm/data/Cyberrange/zeek-max$host$timeslice_folder"
            fi

            logdir="/home/riru/rt-kcsm/data/Cyberrange/zeek-max$host$timeslice_folder/"
            echo "saving output to $logdir"

            zeek -C -r "$data_path$host$timeslice_folder$pcap" base/init-default test-all-policy local Log::default_logdir="$logdir" LogAscii::use_json=T

        done
        cd $data_path
    fi
    echo "working.."
done
echo "finished zeek_max run"

echo "now merging and filtering notices"
cd /home/riru/rt-kcsm/data/Cyberrange/zeek-max/

echo "" > "merged_notice_$timeslice_folder.log"
for notice in $(find /home/riru/rt-kcsm/data/Cyberrange/zeek-max/ -name "notice.log" | grep $timeslice_folder)
do
    echo $notice
    cat $notice >> "merged_notice_$timeslice_folder.log"
done

echo "" > "merged_notice-weird-dns-ssh_$timeslice_folder.log"
for file in $(find /home/riru/rt-kcsm/data/Cyberrange/zeek-max/ -name "notice.log" -or -name "weird.log" -or -name "dns.log" -or -name "ssh.log" | grep $timeslice_folder)
do
    echo $file
    cat $file >> "merged_notice-weird-dns-ssh_$timeslice_folder.log"
done

grep -v "SSL::Invalid_Server_Cert\|ProtocolDetector::Protocol_Found" merged_notice.log > merged_notice_filtered1.log

grep -v "SSL::Invalid_Server_Cert\|ProtocolDetector::Protocol_Found\|Conn::Content_Gap" merged_notice.log > merged_notice_filtered_2.log

unset IFS


