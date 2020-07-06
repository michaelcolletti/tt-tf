resource "aws_launch_template" "lt-node" {
  name_prefix   = "node"
  image_id      = "var.AmiLinux[var.region]"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "lt-node" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = "aws_launch_template.ltnode.id"
    version = "$Latest"
  }
}
