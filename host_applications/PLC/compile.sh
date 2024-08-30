#! /bin/bash

#sudo apt-get install libmodbus-dev

gcc -o plc plc.c -lmodbus
gcc -o hmi hmi.c -lmodbus
