resource "aws_security_group" "sshhttps" {
  provider = aws.app
  name        = "securemgmt"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress = [
    {
      description      = "HTTPS port to VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      self             = true
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description      = "SSH port to VPC "
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      self             = true
      prefix_list_ids  = []
      security_groups  = []
    }
  ]
  egress = [
    {
      description      = "All outbound from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = true
      prefix_list_ids  = []
      security_groups  = []
    }
  ]

  tags = merge(
    var.network_tags,
    { Name = "${var.label}-securemgmt" }
  )
}

resource "aws_security_group" "http_only" {
  provider = aws.app
  name        = "http_only"
  description = "Allow HTTP inbound traffic for certbot setup"
  vpc_id      = aws_vpc.vpc.id
  ingress = [
    {
      description      = "HTTP port to VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      self             = true
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description      = "HTTP port to VPC"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      self             = true
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description      = "HTTP port to VPC"
      from_port        = 3000
      to_port          = 3000
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      self             = true
      prefix_list_ids  = []
      security_groups  = []
    }
  ]
  tags = merge(
    var.network_tags,
    { Name = "${var.label}-http_only" }
  )
}
