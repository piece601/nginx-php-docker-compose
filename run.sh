#!/bin/bash

source /opt/remi/php73/enable
php-fpm
nginx -g "daemon off;"