variable "region" {
  default = "us-east-1"
}

variable "AmiLinux" {
  type = map(string)
  default = {
    us-east-1 = "ami-b73b63a0" # Virginia
    us-east-2 = "ami-ea87a78f" # Ohio
  }
  description = "I add only 3 regions (Virginia, Oregon, Ireland) to show the map feature but you can add all the regions that you need"
}

variable "aws_access_key" {
  default = ""
  description = "AWS access key"
}

variable "aws_secret_key" {
  default = ""
  description = "AWS secret key"
}

variable "credentialsfile" {
  default     = "/Users/michael/.aws/credentials" #replace your home directory
  description = "Where your access and secret_key are stored, you create the file when you run the aws config"
}

variable "vpc-fullcidr" {
  default     = "10.0.0.0/16"
  description = "The Full VPC CDIR"
}

variable "Subnet-Public-AzA-CIDR" {
  default     = "10.0.1.0/24"
  description = "Public Subnet CIDR"
}

variable "Subnet-Private-AzA-CIDR" {
  default     = "10.0.2.0/24"
  description = "Private Subnet CIDR"
}

variable "key_name" {
  default     = "tf-infra-provision"
  description = "the ssh key to use in the EC2 machines"
}

variable "DnsZoneName" {
  default     = "mediaflow.internal"
  description = "the internal dns name"
}

# for ASG and LC
variable "aws-launch-template-nodeid" {
  default     = "node"
  description = "Launch config for Node ASG"
}
######
# for asg lc and scaling with notifyt
variable "availability_zones" {
# No spaces allowed between az names!
  default = ["us-east-2a","us-east-2b","us-east-2c"]
}
variable "asg_min" {
  default = "2"
}
variable "asg_max" {
  default = "10"
}
#
# From other modules
#
variable "public_subnet_id" {}
variable "webapp_lc_id" {}
variable "webapp_lc_name" {}
variable "webapp_elb_name" {}
