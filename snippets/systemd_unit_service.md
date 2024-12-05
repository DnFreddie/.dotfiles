##NAME:systemd_unit##
[Unit]
Description=Script Daemon For Test User Services

[Service]
Type=simple
User=
#Group=
ExecStart=/usr/local/bin/user_service
Restart=on-failure
StandardOutput=file:%h/log_file

[Install]
WantedBy=default.target

