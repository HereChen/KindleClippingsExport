% 2014/03/27 01:01:30
% by HereChen

clear;clc
slCharacterEncoding('GBK')
%%
clipFile = 'My Clippings.txt';              % ��ȡ�ļ�
clipExport = 'ClipExportWang.txt';              % �����ļ���
varargin = {'encoding', 'UTF-8'};
clipExport = KindleClippingsExport(clipFile,clipExport,varargin);