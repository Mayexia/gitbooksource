#!/usr/bin/bash
comment=添加内容
path_name=Mayexia.github.io
git add .
git commit -m "${comment}"
git push -u origin master
gitbook build
rm -rf ../${path_name}/*
