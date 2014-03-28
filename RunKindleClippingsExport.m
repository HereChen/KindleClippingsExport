% 2014/03/27 01:01:30
% by HereChen

clear;clc
slCharacterEncoding('GBK')
%%
clipImportFile = 'My Clippings.txt';                  % 读取文件
clipExportFile = 'ClipExportZhouGuoPing.txt';         % 导出文件名
KindleClippingsExport(clipImportFile,clipExportFile,...
    'bookname','尼采');