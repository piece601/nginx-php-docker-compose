# nginx-php-docker-compose
快速建立 php+nginx 的 docker container 透過 docker-compose
執行 ``docker-compose up -d`` 將 nginx + php 7.3 container 啟動起來
並且將 container 內部 ``/var/www/`` 掛載到目錄下的 ``www`` 同時 nginx 的根目錄也是此
