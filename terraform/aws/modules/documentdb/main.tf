provider "aws" {
    region      = "${var.aws_region}"
    version     = "~> 1.9.0"
}

locals {
  common_tags = "${map(
    "company:application","${var.application}",
    "company:environment","${var.environment}",
    "company:team","${var.team}"
  )}"
}

resource "aws_docdb_subnet_group" "docdb" {
  name       = "${var.application}-${var.environment_short_name}"
  subnet_ids = "${split(",",var.subnet_ids)}"

  tags = "${local.common_tags}"
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "${var.application}-${var.environment_short_name}"
  engine                  = "docdb"
  backup_retention_period = 15
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true

  db_subnet_group         = "${aws_docdb_subnet_group.docdb.id}"
  vpc_security_group_ids  = "${split(",",var.security_group_ids)}"
  availability_zones      = "${var.availabilty_zones}"

  master_username         = "${var.username}"
  master_password         = "${var.password}"

  tags = "${local.common_tags}"
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = "${var.instance_count}"
  identifier         = "${var.application}-${var.environment_short_name}-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.docdb.id}"
  instance_class     = "${var.instance_size}"

  tags = "${local.common_tags}"
}