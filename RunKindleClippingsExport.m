% 2014/03/27 01:01:30
% by HereChen

clear;clc

%%
clipFile = 'My Clippings.txt';              % 读取文件
clipExport = 'ClipExportWang.txt';              % 导出文件名

clipExport = KindleClippingsExport(clipFile,clipExport);