#!/bin/bash

# 安装依赖和shadowsocks
sudo apt-get update
sudo apt-get -y install python-gevent
sudo apt-get -y install python-m2crypto
sudo apt-get -y install python-pip
sudo pip install --upgrade pip
sudo pip install setuptools
sudo pip install shadowsocks

# 设置密码
read -p "请设置shadowsocks的密码(默认: 123): " password
if [ "$password" = "" ]; then
    password="123"
fi

# 配置文件 ~/.shadowsocks
CONFIG=~/.shadowsocks
sudo dd of=$CONFIG << EOF
{
    "server"        : "0.0.0.0",
    "server_port"   : 8388,
    "local_port"    : 1080,
    "password"      : "${password}",
    "timeout"       : 600,
    "method"        : "aes-256-cfb"
}
EOF

# 开机启动shadowsocks
sudo dd of=/etc/rc.local << EOF
#!/bin/bash

sudo /usr/local/bin/ssserver -c ${CONFIG} -d start
exit 0
EOF


# 运行
sudo /usr/local/bin/ssserver -c ${CONFIG} -d start

# 提示信息
echo "shadowsocks安装好了\n公有IP  : $(curl ifconfig.me)\n配置文件: $CONFIG \n$(cat $CONFIG)"
