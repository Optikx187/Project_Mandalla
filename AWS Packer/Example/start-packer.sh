#!/bin/bash
infile=$1
if [ -z "$infile" ]
then
        echo "Param \$infile not passed correctly"
else
 echo "setting AWS connection vars"
 export AWS_MAX_ATTEMPTS=60
 export AWS_POLL_DELAY_SECONDS=60
 export AWS_ACCESS_KEY_ID=<Key>
 export AWS_SECRET_ACCESS_KEY=<Key>
 echo "Running packer build on $infile"
 packer build $infile
fi