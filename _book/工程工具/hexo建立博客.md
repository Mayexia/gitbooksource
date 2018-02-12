# 1、安装环境
需要先安装：
```
Node.js
git
```
# 2、Hexo的安装与部署
在安装完成Node.js后，执行如下命令安装Hexo
```
sudo npm install -g hexo
```
完成安装之后,初始化Hexo
```
hexo init
```
然后生成静态页面，
进入到你所创建的博客的根目录(即你的博客源文件目录)，执行如下命令(两个命令都可以):

```
hexo generate
# hexo g
```
启动本地服务，进行文章预览调试，命令：

```
hexo server
```
浏览器输入http://localhost:4000

# 3、博客部署到github
在博客根目录下的_config.yml文件中，修改如下配置:
```
deploy:
     type: git
     repo: git@github.com:xcbachelor/xcbachelor.github.io.git(更换成你的仓库)
     branch: master
```
然后执行如下命令安装hexo的deploy工具:
```
npm install hexo-deployer-git --save
```
# 4、生成ssh秘钥与github链接
```
cd ~/. ssh #检查本机已存在的ssh密钥
ssh-keygen -t rsa -C "邮件地址"
git config --global user.name "昵称"// 你的github用户名，非昵称
git config --global user.email  "xxx@xx.com"// 填写你的github
```
注册邮箱
然后将生成的id_rsa.pub中的秘钥填入到github的配置中

# 5、部署博客
```
hexo clean #清楚缓存
hexo g -d #生成并部署
```
# 6、Hexo常用命令
```
hexo new "postName" #新建文章
hexo new page "pageName" #新建页面
hexo generate #生成静态页面至public目录
hexo server #开启预览访问端口（默认端口4000，'ctrl + c'关闭server）
hexo deploy #将.deploy目录部署到GitHub
hexo help # 查看帮助
hexo version #查看Hexo的版本
```
