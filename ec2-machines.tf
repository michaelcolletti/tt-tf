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
  sudo yum update -y && sudo yum update --security
  sudo yum install python36-pip.noarch nodejs git.x86_64  -y 
  sudo mkdir noderepo;cd noderepo
  sudo curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
  sudo curl -sL curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  sudo pip install npm@latest
  curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo 
  sudo yum install yarn -y
  git clone https://github.com/michaelcolletti/node-app.git && cd node-app 
  npm install -g nodemon && npm install -g newman && npm install -g
  npm run dev 

HEREDOC
}
resource "aws_instance" "reactapp" {
  ami                         = var.AmiLinux[var.region]
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.PublicAZA.id
  vpc_security_group_ids      = [aws_security_group.FrontEnd.id]
  key_name                    = var.key_name
  tags = {
    Name = "reactapp"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  sudo mkdir /apps
  sudo adduser appuser -d /apps/noderepo && sudo chown -R appuser:appuser  /apps/noderepo
  sudo yum update -y;sudo yum update --security
  sudo yum install git nodejs.x86_64 python36-pip.noarch -y
  sudo chown -R appuser:appuser  /apps/noderepo;cd /apps/noderepo
  curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
  sudo yum install nodejs.x86_64 -y 
  sudo curl -sL curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  npm install npm@latest -g
  su appuser -c "git clone https://github.com/michaelcolletti/react-app.git"
  cd react-app
  su appuser -c "npm install -g"
  su appuser -c "npm start"

HEREDOC
}

resource "aws_instance" "database" {
  ami                         = var.AmiLinux[var.region]
  instance_type               = "t2.small"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.PublicAZA.id
  vpc_security_group_ids      = [aws_security_group.Database.id]
  key_name                    = var.key_name
  tags = {
    Name = "mongodb"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  #sleep 180
  yum update -y
  sudo yum install libcurl openssl xz-libs python2 glibc-2.17-292.180.amzn1.i686 -y
  sudo curl https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/RPMS/mongodb-org-server-4.4.0-1.amzn2.x86_64.rpm --output /tmp/mongodb-org-server-4.4.0-1.amzn2.x86_64.rpm 
  sudo rpm -ivf /tmp/mongodb-org-server-4.4.0-1.amzn2.x86_64.rpm 
  sudo systemctl enable mongod ;sudo systemctl start mongod;sudo service mongod status 
  sudo echo "exclude=mongodb-org,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools" >>/etc/yum.conf 

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
  yum install git python36-pip.noarch -y 
  
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
  instance_type               = "t2.small"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.PublicAZA.id
  vpc_security_group_ids      = [aws_security_group.BuildMon.id]
  key_name                    = var.key_name
  tags = {
    Name = "jenkins"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  sudo yum update -y;sudo yum update --security  -y
  sudo yum install git jenkins -y && sudo systemctl enable jenkins; sudo systemctl start jenkins;sudo systemctl status jenkins
  
HEREDOC
}
resource "aws_instance" "dynalam" {
  ami                         = var.AmiLinux[var.region]
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.PublicAZA.id
  vpc_security_group_ids      = [aws_security_group.FrontEnd.id]
  key_name                    = var.key_name
  tags = {
    Name = "dynalam"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  sudo yum update -y
  sudo yum install python36-pip.noarch nodejs git.x86_64 -y  
  sudo mkdir repo;cd repo
  sudo mkdir noderepo;cd noderepo
  sudo curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
  sudo yum install -y nodejs
  curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo && sudo yum install yarn -y 
  sudo curl -sL curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  cd $HOME && sudo git clone https://github.com/anishkny/realworld-dynamodb-lambda && cd realworld-dynamodb-lambda
  sudo pip install npm
  npm install -g
  npm run start 


HEREDOC
}
