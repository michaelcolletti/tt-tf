resource "aws_instance" "nodeapp" {
  ami                         = var.AmiLinux[var.region]
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.PublicAZA.id
  vpc_security_group_ids      = [aws_security_group.FrontEnd.id]
  key_name                    = var.key_name
  tags = {
    Name = "nodeapp"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  sudo yum update -y;sudo yum update --security 
  sudo yum install git nodejs python36-pip.noarch -y 
  sudo mkdir noderepo;cd noderepo
  sudo curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
  sudo curl -sL curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  sudo pip install npm
  git clone https://github.com/michaelcolletti/node-example-app.git
  cd node-example-app
  npm install 
  npm run dev

HEREDOC

}

resource "aws_instance" "database" {
  ami                         = var.AmiLinux[var.region]
  instance_type               = "t2.small"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.PrivateAZA.id
  vpc_security_group_ids      = [aws_security_group.Database.id]
  key_name                    = var.key_name
  tags = {
    Name = "mongodb"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  sleep 180
  yum update -y
  #x add repo for mongodb 
  sudo curl https://repo.mongodb.org/yum/amazon/mongodb-org.repo > /etc/yum.repos.d/mongodb-org.repo

#sudo yum install mongodb-org -y 
  sudo yum install mongodb-server.x86_64 -y
  sudo systemctl enable mongodb;sudo systemctl start mongodb ;sudo systemctl status mongodb

#  yum install -y mysql55-server
#  service mysqld start
#  /usr/bin/mysqladmin -u root password 'secret'
#  mysql -u root -psecret -e "create user 'root'@'%' identified by 'secret';" mysql
#  mysql -u root -psecret -e 'CREATE TABLE mytable (mycol varchar(255));' test
#  mysql -u root -psecret -e "INSERT INTO mytable (mycol) values ('linuxacademythebest') ;" test

HEREDOC

}

resource "aws_instance" "monitoring" {
  ami                         = var.AmiLinux[var.region]
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.PublicAZA.id
  vpc_security_group_ids      = [aws_security_group.FrontEnd.id]
  key_name                    = var.key_name
  tags = {
    Name = "monitoring"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  sudo yum update -y;sudo yum update --security 
  sudo mkdir /monitoring;cd /monitoring
  yum install git nodejs python36-pip.noarch -y 
  sudo pip install npm

#  service httpd start
#  chkconfig httpd on
#  echo "<?php" >> /var/www/html/calldb.php
#  echo "\$conn = new mysqli('mydatabase.linuxacademy.internal', 'root', 'secret', 'test');" >> /var/www/html/calldb.php
#  echo "\$sql = 'SELECT * FROM mytable'; " >> /var/www/html/calldb.php
###  echo "\$result = \$conn->query(\$sql); " >>  /var/www/html/calldb.php
#  echo "while(\$row = \$result->fetch_assoc()) { echo 'the value is: ' . \$row['mycol'] ;} " >> /var/www/html/calldb.php
#  echo "\$conn->close(); " >> /var/www/html/calldb.php
#  echo "?>" >> /var/www/html/calldb.php
HEREDOC
}

resource "aws_instance" "jenkins" {
  ami                         = var.AmiLinux[var.region]
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.PublicAZA.id
  vpc_security_group_ids      = [aws_security_group.FrontEnd.id]
  key_name                    = var.key_name
  tags = {
    Name = "jenkins"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  sudo yum update -y;sudo yum update --security 
  sudo yum install git jenkins
  #sudo mkdir /noderepo;cd /noderepo
  #sudo curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
  #sudo curl -sL curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  #sudo pip install npm
HEREDOC
}
