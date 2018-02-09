# Git全局配置
```bash
git config --global user.name "夏驰"
git config --global user.email "xiachi@github.com"
```

# 创建一个新的仓库
```bash
git clone git@github.com:xiachi/code.git
cd code
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master
```

# 从已知文件夹上传到仓库
```bash
cd existing_folder
git init
git remote add origin git@github.com:xiachi/code.git
git add .
git commit -m "Initial commit"
git push -u origin master
```

# 已知的本地仓库
```bash
cd existing_repo
git remote add origin git@github.com:xiachi/code.git
git push -u origin --all
git push -u origin --tags
```
