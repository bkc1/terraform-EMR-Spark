# EMR cluster with Spark job

## Overview

Terraform example that launches an EMR cluster and executes a simple python Spark workcount job 

## Prereqs & Dependencies

S3 Bucket must be manually removed before running terraform destroy

Create SSH keys in the keys directory:

```sh
ssh-keygen -t rsa -f ./keys/mykey -N ""
```


## Manually adding step via CLI after launching cluster

Note that existing output folder must be removed for addtional steps to complete successfully

```
$ BUCKET=emr-bucket-XXXXX
$ CLUSTER_ID=j-XXXXXX
$ aws emr add-steps --cluster-id $CLUSTER_ID --steps Type=spark,Name=SparkWordCountApp,Args=[--deploy-mode,cluster,--master,yarn,--conf,spark.yarn.submit.waitAppCompletion=false,--num-executors,1,--executor-cores,1,--executor-memory,512m,s3://$BUCKET/demo/word_count_emr.py,s3://$BUCKET/demo/input.txt,s3://$BUCKET/output],ActionOnFailure=CONTINUE --region us-east-2
```

Copy JSON from S3:
```
$ aws s3 cp s3://$BUCKET/demo/step.json /tmp/
```
Define step parameters in JSON:
```
$ aws emr add-steps --region us-east-2 --cluster-id  $CLUSTER_ID --steps file:///tmp/step.json 
```
