% 2014/12/1 18:37:30
% by HereChen

clear;
clc;

%%

clipImportFile = 'My Clippings.txt';                  % 读取文件
clipExportFile = 'ClipExportZhouGuoPing.txt';         % 导出文件名
KindleClippingsExport(clipImportFile,clipExportFile,...
    'bookname','尼采');