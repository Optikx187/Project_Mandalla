#!/bin/bash
echo "Hello, world" > index.html
echo ${db_address} >> index.html
echo ${db_port} >> index.html
nohup busybox httpd -f -p ${port} &