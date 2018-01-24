# 一、模型论文解读
- 论文:《Topical Word Embeddings》 Liu Y, Liu Z, Chua T S, et al. 2015.

## 1、摘要
大多数词嵌入模型通常使用单个向量来表示每个单词，因此这些模型无法区分同音异义和的一词多义的情况。为了增强判别性，我们采用潜在的主题模型为文本语料库中的每个词分配主题，并基于词和主题来学习主题词嵌入（TWE），这样我们可以灵活地获得情景词嵌入，来衡量情景中单词相似性。我们还可以构建文档的向量表示，这比一些广泛使用的文档模型（如潜在主题模型）更具有表现力。在实验中，我们评估TWE模型的两个任务：情景单词相似性和文本分类。实验结果表明，我们的模型比典型的词嵌入（包括基于上下文的词相似度的多种原型版本）表现更好，同时也优于文本分类的潜在主题模型和其他代表性文档模型。

论文的代码实现地址:[topic word embeddings](https://github.com/largelymfs/topical_word_embeddings)

## 2、介绍
词嵌入（word embedding），也被称为词表示（ word representation），在基于语料库的上下文构建连续词向量中起着越来越重要的作用。词嵌入既能捕捉单词的语义信息，又能捕捉单词的相似性，因此广泛应用于各种IR和NLP任务中。

大多数词嵌入方法都是假定用每个词能够用单个向量代表，但是无法解决一词多义和同音异议的问题。多原型向量空间模型（Reisinger and Mooney 2010）是将一个单词的上下文分成不同的群（groups），然后为每个群生成不同的原型向量。遵循这个想法， （Huang et al. 2012） 提出了基于神经语言模型（Bengio et al. 2003）的多原型词嵌入。

尽管这些模型是有用的，但是多原型词嵌入面临以下几个挑战：（1）这些模型孤立地为每个词生成多原型向量，忽略了词之间复杂的相关性和它们的上下文。（2）在多原型设置中，一个单词的上下文被分成没有重叠的簇，而实际上，一个词的几个意义可能是相互关联的，它们之间没有明确的语义边界。

在本文中，我们提出了一个更加灵活更加强大的多原型单词嵌入框架——主题词嵌入（TWE），其中主题词是指以特定主题为背景的词。TWE的基本思想是，允许每个词在不同的主题下有不同的嵌入向量。例如，“苹果”这个词在食物主题下表示一个水果，而在IT主题下代表一个IT公司。

我们使用LDA（Blei, Ng, and Jordan 2003）来获取单词主题，执行collapsed Gibbs sampling （Griffiths and Steyvers 2004）来迭代地为每个单词令牌分配潜在的主题。这样，给定一个单词序列D={w1,...,wM}，在使用LDA收敛后，每个单词wi 被分配给一个特定的主题zi，形成一个单词-主题对⟨wi,zi⟩，用来学习主题词嵌入。我们设计了三种TWE模型来学习主题词向量，如图1所示，其中，窗口大小是1，wi−1和wi+1是wi的上下文单词。

[论文解读地址](http://blog.csdn.net/u014568072/article/details/78679925?locationNum=7&fps=1)


# 二、代码实现

## 1、源码下载

[github地址](https://github.com/largelymfs/topical_word_embeddings)

## 2、topic word embedings使用方式

代码中有三种实现方式，分别在TWE-1、TWE-2、TWE-3中，三种方式都非常依赖其他的库，使用方式如下：

 - 代码依赖于gibbslda++(LDA的c++实现方式)，使用其生成tassign文件和wordmap.txt文件，然后工后续代码使用,如何获取该文件见下文中gibbslda++的使用

 - 使用命令`python train.py wordmap_filename tassign_filename topic_number`运行程序

 - 输出文件在文件夹output中,分别为:`word_vector.txt` 和`topic_vector.txt`

## 3、gibbslda++使用方式

[下载地址](http://sourceforge.net/projects/gibbslda/)

#### (1) 将文件放在linux下，然后执行如下命令:

```
cd /home/user/LDA/

gunzip GibbsLDA++-0.2.tar.gz

tar -xf GibbsLDA++-0.2.tar

cd \GibbsLDA++-0.2
```

#### (2) 执行如下命令

 ```
 make clean
 make
 ```

#### (3) 在执行命令后会出现报错，按照如下操作进行修改

- 在src/utill.cpp 文件头加入：
```
include <stdio.h>
#include <stdlib.h>
```

- 在src/utill.h 文件头加入：
```
#include <stdlib.h>
```

- 在src/lda.cp 文件头加入：
```
#include <stdio.h>
```
- 重新编译

#### (4) 语料准备

文件格式是dat。这是最原始的txt文件。你也可以用任何软件存成txt文件之后，直接把后缀改成dat就行。

文件内容:
第1行是你总共的文章篇数
第2行到第M行就是你的那些文章，每篇文章占一行。对于英文来说，每个词之间已经用空格分开了，但是中文不行，所以你要先对文章进行分词和去停用词。

注意:文章格式是ANSI，文章中不能有空行

#### (5) 运行
- 执行命令
```
lda -est [-alpha <double>] [-beta <double>] [-ntopics <int>] [-niters <int>] [-savestep <int>] [-twords <int>] -dfile <string>
```
- 例子:
```
src/lda -est -alpha 0.5 -beta 0.1 -ntopics 100 -niters 1000 -savestep 100 -twords 20 -dfile /home/leichen/LDA/data.dat
```

参数alpha是0.5（这个可以先不管），参数beta是0.1（这个也可以先不管），产生100个topic，运算迭代1000次，每迭代100次之后的结果都保存出来，每个topic包含出现概率最大的前20个词，要运算的文件是/home/leichen/LDA/data.dat

#### (6) 结果

结果文件存在你的测试文件所在的目录:
- model-final.others 设置的参数
- model-final.phi    每个主题下的词概率分布
- model-final.tassign  每篇文章的各个词被指定的主题编号
- model-final.theta  每篇文章的主题概率分布
- model-final.twords 每个主题下的前20个主题词
- wordmap.txt 词典
