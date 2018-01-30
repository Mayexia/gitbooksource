#!/usr/bin/bash
comment=将数据分析修改为代码示例
cur_path=$PWD
echo ${cur_path}
git add .
git commit -m "${comment}"
git push -u origin master
gitbook build

dir_name=Mayexia.github.io
cur_path2=${cur_path}/../${dir_name}
rm -rf ${cur_path2}/*
cp -rf _book/* ${cur_path2}/.
cd ${cur_path2}
ls
echo $PWD
git add .
git commit -m "${comment}"
git push -u origin master
