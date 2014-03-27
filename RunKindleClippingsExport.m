% 2014/03/27 01:01:30
% by HereChen

clear;clc
slCharacterEncoding('GBK')
%%
clipFile = 'My Clippings.txt';              % 读取文件
clipExport = 'ClipExportWang.txt';              % 导出文件名
varargin = {'encoding', 'UTF-8'};
clipExport = KindleClippingsExport(clipFile,clipExport,varargin);