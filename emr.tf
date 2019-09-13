
resource "aws_emr_cluster" "cluster" {
  name          = "emr-spark-demo"
  release_label = "emr-5.26.0"
  applications  = ["Spark"]
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true
  service_role  = "${aws_iam_role.emr.arn}"
  log_uri       = "s3://${aws_s3_bucket.data.bucket}/logs"
  ec2_attributes {
    subnet_id                         = "${aws_subnet.myapp1.id}"
    emr_managed_master_security_group = "${aws_security_group.emr.id}"
    emr_managed_slave_security_group  = "${aws_security_group.emr.id}"
    instance_profile                  = "${aws_iam_instance_profile.emr-profile.arn}"
    key_name                          = "${aws_key_pair.myapp.key_name}"
  }
  master_instance_group {
    instance_type = "m4.large"
  }
  core_instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 2

    ebs_config {
      size                 = "40"
      type                 = "gp2"
      volumes_per_instance = 1
    }

    #bid_price = "0.30"
  }

  tags = {
    env  = "${var.env}"
  }

  step {
    action_on_failure = "CONTINUE"
    name              = "Spark Word count"
    hadoop_jar_step {
      jar        = "command-runner.jar"
      args       = [
        "spark-submit",
        "--deploy-mode", "cluster",
        "--master", "yarn",
        "--conf", "spark.yarn.submit.waitAppCompletion=false",
        "--num-executors","1",
        "--executor-cores","4",
        "--executor-memory","2g",
        "s3://${aws_s3_bucket.data.bucket}/demo/word_count_emr.py",
        "s3://${aws_s3_bucket.data.bucket}/demo/input.txt",
        "s3://${aws_s3_bucket.data.bucket}/output"
        ]
    }
  }
  configurations_json = <<EOF
    [
    {
    "Classification": "spark-defaults",
      "Properties": {
      "maximizeResourceAllocation": "true"
      }
    }
  ]
  EOF
  depends_on = ["aws_s3_bucket.data"]
  lifecycle {
    ignore_changes = ["step"]
  }
}

