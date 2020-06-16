#!/bin/bash
 export AWS_MAX_ATTEMPTS=60
 export AWS_POLL_DELAY_SECONDS=60
 export AWS_ACCESS_KEY_ID=
 export AWS_SECRET_ACCESS_KEY=

 packer build ubuntu.json