nano /etc/apt/sources.list
 
# # # replace isi file dengan baris dibawah ini # # #
 
deb http://kebo.pens.ac.id/ubuntu/ focal main restricted universe multiverse
deb http://kebo.pens.ac.id/ubuntu/ focal-updates main restricted universe multiverse
deb http://kebo.pens.ac.id/ubuntu/ focal-security main restricted universe multiverse
deb http://kebo.pens.ac.id/ubuntu/ focal-backports main restricted universe multiverse
deb http://kebo.pens.ac.id/ubuntu/ focal-proposed main restricted universe multiverse
  
deb http://security.ubuntu.com/ubuntu focal-security main restricted 
deb http://security.ubuntu.com/ubuntu focal-security universe 
deb http://security.ubuntu.com/ubuntu focal-security multiverse

apt update

adduser odoo
usermod -aG sudo odoo
su - odoo

sudo apt install -y postgresql
sudo su postgres
createuser --createdb --username postgres --no-createrole --no-superuser --pwprompt odoo
exit

wget https://nightly.odoo.com/12.0/nightly/src/odoo_12.0.latest.tar.gz

sudo mkdir /opt/odoo
cd /opt/odoo
sudo tar xvf ~/odoo_12.0.latest.tar.gz
sudo mv odoo-12.0.GANTI_SESUAI_NAMA_FOLDER/ odoo-server

sudo mkdir addons
sudo chown -R odoo: *
sudo apt install -y git python3-pip python3-polib build-essential wget python3-dev python3-venv python3-wheel libfreetype6-dev libxml2-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less libjpeg-dev zlib1g-dev libpq-dev libxslt1-dev libldap2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev
 
sudo wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6-1.bionic_amd64.deb
 
sudo pip3 install -r /opt/odoo/odoo-server/requirements.txt
sudo nano /etc/odoo-server.conf
 
# # # replace isi file dengan baris dibawah ini # # #
 
[options]
admin_passwd = superadmin
db_host = False
db_port = False
db_user = odoo
db_password = odoo
logfile = /var/log/odoo/odoo-server.log
addons_path = /opt/odoo/odoo-server/odoo/addons,/opt/odoo/addons
 
# # #

sudo mkdir /var/log/odoo
sudo touch /var/log/odoo/odoo-server.log
sudo chown -R odoo:odoo /var/log/odoo
sudo cp /opt/odoo/odoo-server/setup/odoo /opt/odoo/odoo-server/odoo-bin
sudo chmod a+x /opt/odoo/odoo-server/odoo-bin
 
sudo nano /etc/systemd/system/odoo-server.service
 
# # # replace isi file dengan baris dibawah ini # # #
 
[Unit]
Description=Odoo12
Requires=postgresql.service
After=network.target postgresql.service
 
[Service]
Type=simple
SyslogIdentifier=odoo
PermissionsStartOnly=true
User=odoo
Group=odoo
ExecStart=/usr/bin/python3 /opt/odoo/odoo-server/odoo-bin -c /etc/odoo-server.conf
StandardOutput=journal+console
KillMode=mixed
 
[Install]
WantedBy=multi-user.target
 
# # #
 
sudo systemctl daemon-reload
sudo systemctl enable odoo-server
