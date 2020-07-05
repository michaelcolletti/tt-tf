#!/bin/bash
#
#
#
if [[ $# -ne 2 ]];then 
printf "Need 2 args Key and Secret Key"
exit
fi

export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
export AWS_DEFAULT_REGION=us-east-1
