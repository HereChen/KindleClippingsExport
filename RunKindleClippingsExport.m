% 2014/03/27 01:01:30
% by HereChen

clear;clc
slCharacterEncoding('GBK')
%%
clipImportFile = 'My Clippings.txt';                  % ��ȡ�ļ�
clipExportFile = 'ClipExportZhouGuoPing.txt';         % �����ļ���
KindleClippingsExport(clipImportFile,clipExportFile,...
    'bookname','���');