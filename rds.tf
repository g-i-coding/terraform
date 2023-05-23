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
  cluster_identifier     = "celzey-tf-db-cluster"
  db_subnet_group_name   = aws_db_subnet_group.db.name
  engine                 = "aurora-mysql"
  availability_zones     = aws_subnet.private[*].availability_zone
  engine_version         = "5.7.mysql_aurora.2.10.0"
  database_name          = "celzeydb"
  vpc_security_group_ids = [module.db_sg.sg_id]
  master_username        = var.db_credentials.username
  master_password        = var.db_credentials.password
  skip_final_snapshot    = true
  tags = {
    "Name" = "celzey-tf-cluster"
  }

}
