## Kindle Clippings 导出（MATLAB版）

Author：[HereChen](http://herechen.github.io/)  
Version：可导出数据  
update：2014-03-28

###项目描述

本项目旨在提取 Kindle 笔记信息，并作分离，然后实现格式化导出。这里的格式化将针对 Markdown，但最终期望是实现笔记的提取以及按条件提取，并且可以自定义导出文本格式。

###使用描述

`clipExport = KindleClippingsExport(clipImportFile, clipExportFile)`

`clipExport`--导出数据  
`clipImportFile`--笔记原始文件，如 `'My Clippings.txt'`  
`clipExportFile`--笔记导出文件名，如 `'exportclip.txt'`

`RunKindleClippingsExport.m`--是一个导出demo  
`KindleClippingsExport.m`--为导出函数

###当前实现功能

- 四行一循环的信息分离
- 标题，作者，位置，时间可提取

###已知bug

- 标注内容部分多行情况
- 笔记及其对应内容的结合

###尚需添加功能

- 笔记类型的提取
- 按条件提取笔记
- 笔记提取和导出部分分离
- 添加参数 varargin，实现可选参数，比如，文件读取编码，导出条件
