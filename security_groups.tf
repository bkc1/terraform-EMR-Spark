## Security group for instances.
resource "aws_security_group" "emr" {
  name        = "${var.app_prefix}"
  description = "${var.app_prefix} - EMR - Terraform managed"
  vpc_id      = "${aws_vpc.myapp.id}"
  depends_on = ["aws_subnet.myapp1"]
  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
  tags = {
    Name = "${var.app_prefix}-emr"
    env  = "${var.env}"
  }

 # SSH access
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

 # ICMP replys from the VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

# outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

