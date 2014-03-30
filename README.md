## Kindle Clippings 导出（MATLAB版）

Author：[HereChen](http://herechen.github.io/)  
Version：2.0.1   
update：2014-03-29

###项目描述

本项目旨在提取 Kindle 笔记信息（Kindle Paperwhite），并作分离，然后实现格式化导出。这里的格式化将针对 Markdown，目的在于导出之后可以直接发布。但可以通过修改数据导出部分来实现自定义数据导出。

###功能描述

- 将笔记分为 bookname author clipping clipping-style location time1 time2，即实现各内容的分离。
- 可以作为数据集导出，如果你需要自定义格式化导出 txt，可以删除其中文件导出部分或自己修改。
- 可以实现通过作者、书名的关键词筛选，同时也可以实现笔记类型的筛选。筛选条件可以是多个。
- 语言支持中文和英文（涉及到根据关键词分离数据，故存在语言支持的限制）。

###使用描述

调用形式  
`clipExport = KindleClippingsExport(clipImportFile, clipExportFile,varargin)`  
其中， `clipExport` 和 `varargin` 是可选参数。

默认调用形式  
`KindleClippingsExport(clipFile,clipExport,'bookname','','author','','clipstyle','','encoding','UTF-8')`


`clipExport` -- 导出数据  
`clipImportFile` -- 笔记原始文件，如 `'My Clippings.txt'`  
`clipExportFile` -- 笔记导出文件名，如 `'exportclip.txt'`

`varargin` 为输入参数，包括  
`'author'` -- 作者  
`'bookname'` -- 书名  
`'clipstyle'` -- 剪切类型，比如：`标注`，`Highlight`  
`'encoding'`  -- 打开文件编码方式，比如：`'UTF-8'`  

每个参数后面设置对应值。

###示例

	clipImportFile = 'My Clippings.txt';
	clipExportFile = 'ClipExportZhouGuoPing.txt';
	KindleClippingsExport(clipImportFile,clipExportFile,...
    	'bookname','尼采');

导出效果发布后效果：[http://herechen.github.io/zhouguoping-Nietzsche-on-turning-point-of-century/](http://herechen.github.io/zhouguoping-Nietzsche-on-turning-point-of-century/)。

###项目文件

`RunKindleClippingsExport.m` -- 一个导出demo  
`KindleClippingsExport.m` -- 导出函数  
`My Clippings.txt` -- 样本笔记

###设计思路

Kindle 笔记的提取依赖于其格式和关键词，以一个实际示例来展示。

>  ==========  
> 假如你愿意，你就恋爱吧 (王小波作品系列) (王小波，李银河)  
> - Your Highlight at location 212-213 | Added on Friday, 14 March 2014 12:05:02
>   
> 肉麻是什么呢？肉麻就是人们不得不接受降低人格行为时的感觉。  
>  ==========

- 每条笔记有四行；
- 笔记之间以 `==========` 分割；
- 标题和作者之间以 `(` 分开，取最后一个括号做分离，并且将省略最后一个反括号；
- 位置以数字读取；
- 笔记类型通过关键词 `Your` 和 `at` 提取；
- 时间通过 `,` 来分割获取；
- 笔记内容直接提取第四行，如果为空将过滤。

Kindle 系统语言为中文时类似。

###更新记录

2014/03/29 12:20:46  
1 添加筛选后如果无剪贴的警示输出。  
2 各个属性分离错误时的警示输出。

###Thanks

感谢 [Unkeltao](http://www.unkeltao.com/) 提供在前期数据分离提供的建设性思路。Unkeltao 有个 Ruby 版的笔记导出，值得推荐，[地址](https://github.com/UnkelTao/kindle-note-format)。毕竟 MATLAB 并不是免费的。

另外，此版尚未作更多的测试，若你发现 Bug，诚请相告，thanks in advance！

HereChen chenlei.here@gmail.com
