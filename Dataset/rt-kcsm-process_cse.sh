#!/bin/bash


for i in $(seq 1 10)
do
    echo ""
    echo "Working on Day $i"
    echo ""

    for file in /home/riru/CSE-CIC-IDS/2018/Original_Network_Traffic_and_Log_data/fixed_day$i/*
    do
        filename=$(basename "$file")

        if [ ! -d /home/riru/rt-kcsm/data/ ]
        then
            mkdir /home/riru/rt-kcsm/data/
            mkdir /home/riru/rt-kcsm/data/CSE-2018/
            mkdir /home/riru/rt-kcsm/data/CSE-2018/zeek-min/
        fi

        if [ ! -d /home/riru/rt-kcsm/data/CSE-2018/zeek-min/day_"$i"/ ]
        then
            mkdir /home/riru/rt-kcsm/data/CSE-2018/zeek-min/day_"$i"/
        fi

        if [ ! -d /home/riru/rt-kcsm/data/CSE-2018/zeek-min/day_"$i"/"$filename"/ ]
        then
            mkdir /home/riru/rt-kcsm/data/CSE-2018/zeek-min/day_"$i"/"$filename"/
        fi

        echo "Working on file $filename"

        zeek -C -r "$file" base/init-default test-all-policy Log::default_logdir=/home/riru/rt-kcsm/data/CSE-2018/zeek-min/day_"$i"/"$filename"/ LogAscii::use_json=T
    done
done




logpath=
for i in $(seq 1 10)
do
    echo ""
    echo "Working on Day $i"
    echo ""

    for file in /home/riru/CSE-CIC-IDS/2018/Original_Network_Traffic_and_Log_data/fixed_day$i/*
    do
        filename=$(basename "$file")

        if [ ! -d /home/riru/rt-kcsm/data/ ]
        then
            mkdir /home/riru/rt-kcsm/data/
            mkdir /home/riru/rt-kcsm/data/CSE-2018/
            mkdir /home/riru/rt-kcsm/data/CSE-2018/zeek-max/
        fi

        if [ ! -d /home/riru/rt-kcsm/data/CSE-2018/zeek-max/ ]
        then
            mkdir /home/riru/rt-kcsm/data/CSE-2018/zeek-max/
        fi

        if [ ! -d /home/riru/rt-kcsm/data/CSE-2018/zeek-max/day_"$i"/ ]
        then
            mkdir /home/riru/rt-kcsm/data/CSE-2018/zeek-max/day_"$i"/
        fi

        if [ ! -d /home/riru/rt-kcsm/data/CSE-2018/zeek-max/day_"$i"/"$filename"/ ]
        then
            mkdir /home/riru/rt-kcsm/data/CSE-2018/zeek-max/day_"$i"/"$filename"/
        fi

        echo "Working on file $filename"

        zeek -C -r "$file" base/init-default test-all-policy local Log::default_logdir=/home/riru/rt-kcsm/data/CSE-2018/zeek-max/day_"$i"/"$filename"/ LogAscii::use_json=T
    done
done
