variable "name" {}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "subnet_id" {}
variable "public_key_name" {}
#variable "private_key" {}
variable "region" {}
variable "instance_type" {}
variable "admin_email" {}
variable "admin_user" {}
variable "admin_pw" {}
variable "license" {}
variable "account_id" {}
variable "vpn_cidr" {}
variable "hostname" {}
variable "dns_zone_id" {}
variable "environment" {}
variable "environment_short_name" {}
variable "team" {}


data "aws_ami" "openvpn" {
  most_recent = "true"

  filter {
    name = "name"
    values = ["OpenVPN Access Server *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]
}

resource "aws_security_group" "openvpn" {
  name   = "${var.name}"
  vpc_id = "${var.vpc_id}"
  description = "OpenVPN security group"

  tags {
    Name = "${var.name}"
    "playstudios:environment" = "${var.environment}"
    "playstudios:team" = "${var.team}"
  }

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # ingress {
  #   protocol    = "tcp"
  #   from_port   = 22
  #   to_port     = 22
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # For OpenVPN Client Web Server & Admin Web UI
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 943
    to_port     = 943
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "udp"
    from_port   = 1194
    to_port     = 1194
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# data "template_file" "user_data" {
#   template = "${file("${path.module}/user-data.sh")}"
#   vars {
#     hostname                = "${var.hostname}"
#     region                  = "${var.region}"
#     environment             = "${var.environment}"
#     environment_short_name  = "${var.environment_short_name}"
#     admin_email             = "${var.admin_email}"
#   }
# }

resource "aws_instance" "openvpn" {
  ami           = "${data.aws_ami.openvpn.id}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.public_key_name}"
  subnet_id     = "${var.subnet_id}"
  
  associate_public_ip_address = true
  #iam_instance_profile = "${aws_iam_instance_profile.openvpnprofile.name}"

  vpc_security_group_ids = ["${aws_security_group.openvpn.id}"]

  # depends_on = [
  #   "aws_iam_instance_profile.openvpnprofile",
  #   "aws_iam_policy.allowvpnsecrets",
  #   "aws_iam_policy_attachment.openvpnsecrets",
  #   "aws_iam_role.openvpn",
  # ]

  tags {
    Name = "${var.name}"
    "playstudios:environment" = "${var.environment}"
    "playstudios:team" = "${var.team}"
  }

  # `admin_user` and `admin_pw` need to be passed in to the appliance through `user_data`, see docs -->
  # https://docs.openvpn.net/how-to-tutorialsguides/virtual-platforms/amazon-ec2-appliance-ami-quick-start-guide/
  user_data = <<USERDATA
admin_user=${var.admin_user}
admin_pw=${var.admin_pw}
public_hostname=${var.hostname}
license=${var.license}
USERDATA
}

resource "aws_route53_record" "openvpn" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.hostname}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.openvpn.public_ip}"]
}

# below is the proper way to do it, 
# but openvpnas expects everything to be passed in user data :(
# attempts at modifying user data with provisioners have gone horribly wrong

# data "aws_iam_policy_document" "openvpn" {
#   statement {
#     actions = [
#       "sts:AssumeRole"
#     ]
#     principals = {
#       type = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#     effect = "Allow"
#   }
# }

# data "aws_iam_policy_document" "allowvpnsecrets" {
#   statement {
#     actions = [
#       "secretsmanager:GetSecretValue"
#     ]
#     resources = [
#       "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:${var.environment}/openvpn_*"
#     ]
#     effect = "Allow"
#   }
# }

# resource "aws_iam_policy" "allowvpnsecrets" {
#   name="${var.environment_short_name}-openvpn-secrets"
#   description="allow access to open vpn secrets"
#   policy="${data.aws_iam_policy_document.allowvpnsecrets.json}"
# }

# resource "aws_iam_role" "openvpn" {
#   name="${var.environment_short_name}-openvpn"
#   assume_role_policy="${data.aws_iam_policy_document.openvpn.json}"
# }

# resource "aws_iam_policy_attachment" "openvpnsecrets" {
#   name = "${var.environment_short_name}-openvpn-secrets-openvpn-role"
#   roles=["${aws_iam_role.openvpn.name}"]
#   policy_arn="${aws_iam_policy.allowvpnsecrets.arn}"
# }

# resource "aws_iam_instance_profile" "openvpnprofile" {
#   name="${var.environment_short_name}-openvpn"
#   role = "${aws_iam_role.openvpn.name}"
# }


output "private_ip"        { value = "${aws_instance.openvpn.private_ip}" }
output "public_ip"         { value = "${aws_instance.openvpn.public_ip}" }
output "security_group_id" { value = "${aws_security_group.openvpn.id}" }
