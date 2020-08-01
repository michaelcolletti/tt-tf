#!/bin/bash

# Script to create ec2 keys, describe and import
#
KEYPAIRNAME=tf-infra-provision
KEYPAIRNAME2=cf-infra-provision
KEYPEMOUT=${KEYPAIRNAME}.pem
KEYPEMOUT2=${KEYPAIRNAME2}.pem

rm -f $HOME/.aws/$KEYPEMOUT 
# gen public key 
ssh-keygen -t rsa -C "$KEYPAIRNAME" -f ~/.ssh/$KEYPAIRNAME 
aws ec2 import-key-pair --key-name "$KEYPAIRNAME" --public-key-material fileb://~/.ssh/${KEYPAIRNAME2}.pub
#
ssh-keygen -t rsa -C "$KEYPAIRNAME2" -f ~/.ssh/$KEYPAIRNAME2
aws ec2 import-key-pair --key-name "$KEYPAIRNAME2" --public-key-material fileb://~/.ssh/${KEYPAIRNAME2}.pub


aws ec2 create-key-pair --key-name $KEYPAIRNAME --query 'KeyMaterial' --output text > $HOME/.aws/$KEYPEMOUT
aws ec2 create-key-pair --key-name $KEYPAIRNAME2 --query 'KeyMaterial' --output text > $HOME/.aws/$KEYPEMOUT2
chmod 400 $HOME/.aws/$KEYPEMOUT 
chmod 400 $HOME/.aws/$KEYPEMOUT2


aws ec2 describe-key-pairs --key-name $KEYPAIRNAME $KEYPAIRNAME2

printf "When done, delete via aws ec2 delete-key-pair --key-name $KEYPAIRNAME  $KEYPAIRNAME2 \n\n"
