# 1、说明
在很多情况下我们在公司使用git需要连接公司的账号，但是如果这个时候需要连接自己的`github`账号的时候，这个时候就需要在自己电脑上使用git链接两个账号或者多个账号

# 2、生产两个ssh-key
代码如下
```bash
$ ssh-keygen -t rsa -C "one@gmail.com" #你的github账号

$ ssh-keygen -t rsa -C "two@gmail.com" #你的github账号
```
注意：
- 不要一路回车，分别在第一个对话即需要输入的时候,输入文件名（如:id_rsa_one和id_rsa_two），这样会生成对应的文件名的公钥和私钥(如：id_rsa_one、id_rsa_one.pub、id_rsa_two、id_rsa_two.pub)
- 如果执行的路径不在`~/.ssh`路径中执行的话，需要把文件拷贝到期目录下

# 3、添加私钥
## 打开ssh-agent
- 如果你是github官方的bash：
```bash
$ ssh-agent -s
```
- 如果你是其它，比如msysgit：
```bash
$ eval $(ssh-agent -s)
```

## 添加私钥
```bash
$ ssh-add ~/.ssh/id_rsa_one
$ ssh-add ~/.ssh/id_rsa_two
```

# 4、创建或者修改config文件
在`~/.ssh`中如果没有`config`则使用`touch config`创建该文件，有的话则进行如下修改:
- 网上demo示例

```
# one(one@gmail.com)

    Host one.github.com

　　HostName github.com

　　PreferredAuthentications publickey

　　IdentityFile ~/.ssh/id_rsa_one

　　User one

# two(two@ gmail.com)

    Host two.github.com

　　HostName github.com

　　PreferredAuthentications publickey

　　IdentityFile ~/.ssh/id_rsa_two

　　User two
```

- 自己电脑的示例(配置了gitlab和两个github账号)

```
Host github.com
    HostName github.com
    User git
    IdentityFile /Users/xiachi/.ssh/id_rsa_public

Host mayexia
    HostName github.com
    User git
    IdentityFile /Users/xiachi/.ssh/id_rsa_350

Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile /Users/xiachi/.ssh/id_rsa
```

最后想连接github的话，需要将对应的公钥添加到github的ssh秘钥中,添加后便可使用git连接到github了。
