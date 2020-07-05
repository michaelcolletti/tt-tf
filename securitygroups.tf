resource "aws_security_group" "FrontEnd" {
  name = "FrontEnd"
  tags = {
    Name = "FrontEnd"
  }
  description = "ONLY HTTP CONNECTION INBOUD"
  vpc_id      = aws_vpc.terraformmain.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Database" {
  name = "Database"
  tags = {
    Name = "Database"
  }
  description = "ONLY TCP MongoDB CONNECTION INBOUND"
  vpc_id      = aws_vpc.terraformmain.id
  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "TCP"
    security_groups = [aws_security_group.FrontEnd.id]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Bastion" {
  name = "Bastion"
  tags = {
    Name = "Bastion"
  }
  description = "ONLY TCP SSH CONNECTION INBOUND from blessed subnet"
  vpc_id      = aws_vpc.terraformmain.id
  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "TCP"
    security_groups = [aws_security_group.FrontEnd.id]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

