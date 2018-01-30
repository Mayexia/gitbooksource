#!/usr/bin/bash
pwd
comment=添加内容
path_name=Mayexia.github.io
echo '更新源代码到github'
git add .
git commit -m "${comment}"
git push -u origin master

echo 'gitbook生成html内容'
gitbook build

echo '更新gitpages内容'
rm -rf ../${path_name}/*
cp -rf _book/* ${path}/.
cd ../${path_name}/
git add .
git commit -m "${comment}"
git push -u origin master
