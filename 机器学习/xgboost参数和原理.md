# 1、XGBoost参数
在运行XGBoost程序之前，必须设置三种类型的参数：通用类型参数（general parameters）、booster参数和学习任务参数（task parameters）。

一般类型参数general parameters –参数决定在提升的过程中用哪种booster，常见的booster有树模型和线性模型。

Booster参数-该参数的设置依赖于我们选择哪一种booster模型。

学习任务参数task parameters-参数的设置决定着哪一种学习场景，例如，回归任务会使用不同的参数来控制着排序任务。
命令行参数-一般和xgboost的CL版本相关。
## 1.1Booster参数：
- eta[默认是0.3] 和GBM中的learning rate参数类似。通过减少每一步的权重，可以提高模型的鲁棒性。典型值0.01-0.2
- min_child_weight[默认是1] 决定最小叶子节点样本权重和。当它的值较大时，可以避免模型学习到局部的特殊样本。但如果这个值过高，会导致欠拟合。这个参数需要用cv来调整
- max_depth [默认是6] 树的最大深度，这个值也是用来避免过拟合的3-10
- max_leaf_nodes 树上最大的节点或叶子的数量，可以代替max_depth的作用，应为如果生成的是二叉树，一个深度为n的树最多生成2n个叶子,如果定义了这个参数max_depth会被忽略
- gamma[默认是0] 在节点分裂时，只有在分裂后损失函数的值下降了，才会分裂这个节点。Gamma指定了节点分裂所需的最小损失函数下降值。这个参数值越大，算法越保守。
- max_delta_step[默认是0] 这参数限制每颗树权重改变的最大步长。如果是0意味着没有约束。如果是正值那么这个算法会更保守，通常不需要设置。
- subsample[默认是1] 这个参数控制对于每棵树，随机采样的比例。减小这个参数的值算法会更加保守，避免过拟合。但是这个值设置的过小，它可能会导致欠拟合。典型值：0.5-1
- colsample_bytree[默认是1] 用来控制每颗树随机采样的列数的占比每一列是一个特征0.5-1
- colsample_bylevel[默认是1] 用来控制的每一级的每一次分裂，对列数的采样的占比。
- lambda[默认是1] 权重的L2正则化项
- alpha[默认是1] 权重的L1正则化项
- scale_pos_weight[默认是1] 各类样本十分不平衡时，把这个参数设置为一个正数，可以使算法更快收敛。

## 1.2通用参数
- booster[默认是gbtree]
选择每次迭代的模型，有两种选择：gbtree基于树的模型、gbliner线性模型
- silent[默认是0]
当这个参数值为1的时候，静默模式开启，不会输出任何信息。一般这个参数保持默认的0，这样可以帮我们更好的理解模型。
- nthread[默认值为最大可能的线程数]这个参数用来进行多线程控制，应当输入系统的核数，如果你希望使用cpu全部的核，就不要输入这个参数，算法会自动检测。

## 1.3学习目标参数：
- objective[默认是reg：linear]
这个参数定义需要被最小化的损失函数。最常用的值有：binary：logistic二分类的逻辑回归，返回预测的概率非类别。multi:softmax使用softmax的多分类器，返回预测的类别。在这种情况下，你还要多设置一个参数：num_class类别数目。
- eval_metric[默认值取决于objective参数的取之]
对于有效数据的度量方法。对于回归问题，默认值是rmse，对于分类问题，默认是error。典型值有：rmse均方根误差；mae平均绝对误差；logloss负对数似然函数值；error二分类错误率；merror多分类错误率；mlogloss多分类损失函数；auc曲线下面积。
- seed[默认是0]随机数的种子，设置它可以复现随机数据的结果，也可以用于调整参数。


# 2、spark的相关代码
- 训练代码
```
import ml.dmlc.xgboost4j.scala.spark.XGBoost
import ml.dmlc.xgboost4j.scala.spark.XGBoostModel
import org.apache.spark.sql.{DataFrame, SaveMode, SparkSession}
import org.apache.spark.ml.linalg.{DenseVector, Vector, Vectors}
import ml.dmlc.xgboost4j.scala.spark.XGBoostClassificationModel
import ml.dmlc.xgboost4j.scala.{Booster, XGBoost => SXGBoost}
import org.apache.spark.mllib.evaluation.BinaryClassificationMetrics
```
```
def train(spark:SparkSession,featuresDF:DataFrame,params_map:Map[String,String]): XGBoostModel ={
    val sc = spark.sparkContext
    val model_name = params_map("model_name").toString
    val tree_deep = params_map("tree_deep").toString.toInt
    val tree_num = params_map("tree_num").toString.toInt
    val lr = params_map("lr").toString.toDouble
    val scale_pos_weight = params_map("scale_pos_weight").toString.toInt
    val lambda_value = params_map("lambda_value").toString.toDouble
    val colsample_bytree = params_map("colsample_bytree").toString.toDouble
    val n_workers = params_map("n_workers").toString.toInt
    val seed_max = params_map("seed").toString.toInt
    val seed = scala.util.Random.nextInt(seed_max)
    val gamma = params_map.get("gamma").getOrElse("0.0").toString.toFloat
    val objective = "binary:logistic"

    val paramMap = List(
      "eta" -> lr,
      "max_depth" -> tree_deep,
      "lambda" -> lambda_value,
      "objective" -> objective,
      "scale_pos_weight" -> scale_pos_weight,
      "colsample_bytree" -> colsample_bytree,
      "subsample"->0.75,
      "seed" -> seed).toMap
    var xgboostModel = XGBoost.trainWithDataFrame(featuresDF, paramMap, tree_num, nWorkers = n_workers, useExternalMemory = true)
    val model_name_hadoop = model_name + "_hadoop"
    xgboostModel.saveModelAsHadoopFile(model_name_hadoop)(sc)

    return xgboostModel
  }
```

- 预测代码
```
def predict(spark:SparkSession,featuresDF:DataFrame,xgboostModel:XGBoostModel): Unit ={
    import spark.implicits._
    val sc = spark.sparkContext
    val predict_test = xgboostModel.transform(featuresDF)

    val prob_label_df = predict_test.map{x=>
      val label = x.getAs("label").toString.toDouble
      val probabilities = x.getAs[DenseVector]("probabilities").toArray(1)
      (probabilities,label)
    }

    //auc计算
    val dataset_metric = new BinaryClassificationMetrics(prob_label_df.rdd)
    val dataset_auc = dataset_metric.areaUnderROC()
    println("dataset auc:" + dataset_auc)

    //ks计算
    val ks_result = computer(prob_label_df,20,sc)
    val ksMax = ks_result._1
    val ksInfosDF = ks_result._2.toList.toDF("level", "good", "bad", "numGood", "numBad",
      "pctGood", "pctBad", "ks", "pBad", "scoreMin", "scoreMean", "scoreMax", "len", "pBad2Total")
    ksInfosDF.show()
    println("最大ks:",ksMax)
  }
```
