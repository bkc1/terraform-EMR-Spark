[
 {
   "Name": "Spark Word count",
   "Type":"CUSTOM_JAR",
   "Jar":"command-runner.jar",
   "ActionOnFailure": "CONTINUE",
   "Args":
   [
     "spark-submit",
     "--deploy-mode", "cluster",
     "--master", "yarn",
     "--conf", "spark.yarn.submit.waitAppCompletion=false",
     "--num-executors","1",
     "--executor-cores","4",
     "--executor-memory","2g",
     "s3://${bucket}/demo/word_count_emr.py",
     "s3://${bucket}/demo/input.txt",
     "s3://${bucket}/output"
   ]
 }
]
