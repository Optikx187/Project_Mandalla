#!/bin/bash

cat > index.html <<EOF
<h1> "Hello, world"</h1>
<p>DB address: ${db_address}</p>
<p>DB port:  ${db_port}</p>
EOF

nohup busybox httpd -f -p ${port} &