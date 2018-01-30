# 1、小知识点
- 读取csv文件
```scala
 val vocDF = spark.sqlContext.read.format("com.databricks.spark.csv").option("header", true).load(vocabulary_name)
```
- 保存结果到csv
```scala
def saveDataFrameAsCsv(df: DataFrame, path: String = "sample.csv"): Unit = {
   val saveOptions = Map("header" -> "true", "path" -> path)
   df.write.format("com.databricks.spark.csv").mode(SaveMode.Overwrite).options(saveOptions).save()
 }
```
