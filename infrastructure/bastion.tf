#Elastic IP for Bastion Server
resource "aws_eip" "bastion_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.vpc_igw]

  tags = {
    Name    = "Bastion Server EIP"
  }

}

#Bastion Server
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.server_ami.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_us_east_1a.id
  security_groups = [aws_security_group.bastion.id]
  key_name = var.keyname_bastion

  tags = {
    Name    = "Bastion Server"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion_eip.id
}