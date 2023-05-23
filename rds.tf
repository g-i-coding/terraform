module "db_sg" {
  source        = "./modules/rds"
  sg_name       = "celzey-tf-DB-SG"
  description   = "SG for rds portion of terraform demo"
  vpc_id        = aws_vpc.main.id
  sg_db_ingress = var.sg_db_ingress
  sg_db_egress  = var.sg_db_egress
  sg_source     = aws_instance.main.vpc_security_group_ids
}

resource "aws_db_subnet_group" "db" {
  name_prefix = "celzey-db"
  subnet_ids  = aws_subnet.private.*.id
  tags = {
    "Name" = "celzey-tf-group"
  }
}

resource "aws_rds_cluster" "db" {
  cluster_identifier   = "celzey-tf-db-cluster"
  db_subnet_group_name = aws_db_subnet_group.db.name
  engine               = "aurora-postgresql"
  engine_mode          = "provisioned"
  availability_zones   = aws_subnet.private[*].availability_zone
  engine_version       = "13.6"
  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
  database_name          = "celzeydb"
  vpc_security_group_ids = [module.db_sg.sg_id]
  master_username        = var.db_credentials.username
  master_password        = var.db_credentials.password
  skip_final_snapshot    = true
  tags = {
    "Name" = "celzey-tf-cluster"
  }

}
resource "aws_rds_cluster_instance" "db" {
  count                = 2
  identifier           = "celzey-tf-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.db.id
  instance_class       = "db.t3.small"
  engine               = aws_rds_cluster.db.engine
  engine_version       = aws_rds_cluster.db.engine_version
  db_subnet_group_name = aws_db_subnet_group.db.name
}

output "db_endpoints" {
  value = {
    writer = aws_rds_cluster.db.endpoint
    reader = aws_rds_cluster.db.reader_endpoint
  }
}
