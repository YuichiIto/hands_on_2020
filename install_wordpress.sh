# 01.HTTPサーバソフト(Apache)のインストールと設定
## Apacheのインストール
sudo yum -y install httpd

## Apacheサーバの起動
sudo systemctl start httpd

## ec2-userにApacheサーバ内のファイルを読み込み・書き込み権限を付与
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

# 02.PHPのインストール
sudo amazon-linux-extras enable php7.3
sudo yum -y install php php-gd php-mysqlnd php-xmlrpc

# 03.DBのインストールと設定
## MariaDBのインストール
sudo yum install mariadb mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo -e "\n"Y"\n"test"\n"test"\n"Y"\n"Y"\n"Y"\n"Y|sudo mysql_secure_installation # パスワードは「test」で、Yes/Noの質問はYesを選択

## MariaDBへの接続とWordPress用のデータベースとユーザを作成
mysql -u root -ptest < create_user_and_db.sql

# 4.Wordpressのインストール
## ホームディレクトリへ移動
cd
pwd

## wordpressをダウンロードして、展開
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php

## Wordpressの設定ファイルのDB名・DBユーザ・DBパスワードを指定
sed -i -e 's/database_name_here/wordpress-db/g' wordpress/wp-config.php
sed -i -e 's/username_here/wordpress-user/g' wordpress/wp-config.php
sed -i -e 's/password_here/password/g' wordpress/wp-config.php

## wordpressをhttpサーバの資材置き場に入れる
mkdir /var/www/html/blog
cp -r wordpress/* /var/www/html/blog/
#AllowOverride を None から All に変更
sudo sed -i -e 's/None/All/g' /etc/httpd/conf/httpd.conf

## ファイルの書き込み許可
sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;

## httpd再起動
sudo systemctl restart httpd
