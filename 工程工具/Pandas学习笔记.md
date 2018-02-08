# 1、读取csv文件

- 读取csv文件带head
```Python
import os
import pandas as pd
df = pd.read_csv("filepath")
```

- 读取csv文件不带head且重命名header
```Python
import os
import pandas as pd
df = pd.read_csv(file_path,header=None)
columns_dict={i:name for i,name in enumerate(header_list)}
df.rename(columns=columns_dict, inplace=True)
```
