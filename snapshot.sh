#!/bin/bash 

if [ $# -ne 1 ]; then
        echo "Create a snapshot of a LV of a running VM"
        echo ""
        echo "Usage: $0 <VM-name>"
        echo "Example: $0 bash snapshot.sh vm-kali-purple"
        exit 1
fi


DATE=$(date +"_%Y%m%d_%H%M%S")
#TARGET="/dev/vghdd0/vm-kali-purple"
TARGET=$1
TARGET_PATH=$(sudo lvs -o "lv_path" | grep -m1 $TARGET | sed -e 's/^[ \t]*//')
SIZE=$(sudo lvs $TARGET_PATH -o LV_SIZE --noheadings --nosuffix | sed -e 's/^[ \t]*//' | sed -e 's/.00g//')
SIZE+=G
NAME="${TARGET##*/}$DATE"
SIZE_FLAG=-L$SIZE

echo "Target VM: " $TARGET
echo "Snapshot Name: " $NAME
echo "Target VM Path: " $TARGET_PATH
echo "Snapshot Size: " $SIZE

echo "creating snapshot..."
sudo lvcreate $SIZE_FLAG -s -n $NAME $TARGET_PATH
echo "done"
sudo lvs
