## Kindle Clippings 导出（MATLAB版）

Author：[HereChen](http://herechen.github.io/)  
Version：2.0   
update：2014-03-28

###项目描述

本项目旨在提取 Kindle 笔记信息，并作分离，然后实现格式化导出。这里的格式化将针对 Markdown，但最终期望是实现笔记的提取以及按条件提取，并且可以自定义导出文本格式。

###功能描述

- 将笔记分为 bookname author clipping clipping-style location time1 time2，即实现各内容的分离。
- 可以作为数据集导出，如果你需要自定义格式化导出 txt，可以删除其中文件导出部分或自己修改。
- 可以实现通过作者、书名的关键词筛选，同时也可以实现笔记类型的筛选。筛选条件可以是多个。

###使用描述

调用形式  
`clipExport = KindleClippingsExport(clipImportFile, clipExportFile,varargin)`
其中， `clipExport` 和 `varargin` 是可选参数。


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

###项目文件

`RunKindleClippingsExport.m` -- 一个导出demo  
`KindleClippingsExport.m` -- 导出函数
`My Clippings.txt` -- 样本笔记

###Thanks

感谢 [Unkeltao](http://www.unkeltao.com/) 提供在前期数据分离提供的建设性思路。Unkeltao 有个 Ruby 版的笔记导出，值得推荐，[地址](https://github.com/UnkelTao/kindle-note-format)。毕竟 MATLAB 并不是免费的。

另外，此版尚未作更多的测试，若你发现 Bug，诚请相告，thanks in advance！

HereChen chenlei.here@gmail.com
