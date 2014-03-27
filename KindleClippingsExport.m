function clipExport = KindleClippingsExport(clipImportFile,clipExportFile)
%KINDLECLIPPINGSEXPORT
%   check encoding: slCharacterEncoding()
%   set encoding: slCharacterEncoding('GBK') or 'UTF-8'
%   clipExport is the last result of export.

%   HereChen
%   2014/03/27 01:01:30

%% ��ʽ˵��˵��
% ������������� ���� �ʼ����� λ�� ʱ�� ���� (λ�ò���Ҫ)
% �ʼ����ͣ�[��ǩ Bookmark] [�ʼ� Note]  [��ע Highlight]
% ʱ�����ͣ�[����� Added on]

% clipText
% ��������: ?֪���ܿ����������С�� (֪��)
% λ��ʱ��: - �ҵıʼ� λ�� #762 | �����2013��12��24�����ڶ� ����09:55:16
% �ʼ����ݣ�good .����

% format
% �������ߣ�bookname' '(author)
% λ��ʱ�䣺xxxx #location xxx | �����/Added on' 'time
% ע�����Ӣ�ıʼ��������·������ıʼ��������Ϸ�

encoding = 'UTF-8';                         % ��ȡ�ļ��ı����ʽ

%% ��ȡÿ������

fileID = fopen(clipImportFile,'r','n',encoding);
formatSpec = '%s';                          % ��ȡ��ʽ
clippings = textscan(fileID,formatSpec,...  % ��ȡ������ '='
    'delimiter','\n');
fclose(fileID);

%% ��ȡ����

clippings = clippings{1,1};
sizeClip = floor(length(clippings)/5);
clipText = cell(sizeClip,3);
for i=1:3
    if i~=3
        [clipText{:,i}] = deal(clippings{i:5:end,1});
    else
        [clipText{:,i}] = deal(clippings{i+1:5:end,1});
    end
end

%% ��������ȡ

% ���� ���� �ʼ����� λ�� ʱ�� ���� (�ʼ�������δ��¼)
clipExport = cell(sizeClip,5);      % ���� ���� λ�� ʱ�� ����
dx = [1 2 3 4 5];                   % ��Ӧ ���� ���� λ�� ʱ�� ���� ��Ϊ�±�
                                    % ���Լ�¼��Ӧ���ݱ���������
[clipExport{:,5}] = deal(clipText{:,3});

for i=1:sizeClip
    % title author
    tempClip = clipText{i,1};
    indexAuthor = find(tempClip=='(');
    % �� '(' �ж��Ƿ������ߣ�����ȡ���һ�� '(' Ϊ����
    % ������������û�б���������
    if ~isempty(indexAuthor)
        tempAuthor = tempClip(1:indexAuthor(end)-1);
        tempTitle = tempClip(indexAuthor(end)+1:end-1);
    else
        tempAuthor = tempClip;
        tempTitle = '';
    end
    
    clipExport{i,dx(1)} = tempAuthor;
    clipExport{i,dx(2)} = tempTitle;
    
    % location
    % ��ҳλ��
    tempClip = clipText{i,2};
    tempLocation = regexp(tempClip,'(\d+)-(\d+)','tokens');
    % �������ҳ
    if isempty(tempLocation)
        tempLocation = regexp(tempClip,'(\d+)','tokens');
        tempLocation = tempLocation{1};
    else
        tempLocation = tempLocation{1,1};
        tempLocation = strcat(tempLocation{1},'-',tempLocation{2});
    end
    
    clipExport{i,dx(3)} = tempLocation;
    
    % time
    % �� '�����' �� 'Added on' ���ָ�ȡ��
    tempTime = textscan(tempClip,'%s','delimiter',{'�����','Added on'});
    tempTime = tempTime{1,1};
    
    clipExport{i,dx(4)} = tempTime{end};
end

%% �ļ�����

% fileWrite = fopen(clipExportFile,'a+','n',encoding);
% formarSpec = {'> %s\n\n',...
%     '<p text-align=right>%s # %s</p>\n'};
% for i=117:137
%     clipcontent = clipExport{i,dx(5)};
%     cliplocation = clipExport{i,dx(3)};
%     cliptime = clipExport{i,dx(4)};
%     fprintf(fileWrite, '\n');
%     fprintf(fileWrite, formarSpec{1}, clipcontent);
%     fprintf(fileWrite, formarSpec{2}, cliplocation, cliptime);
% end
% fclose(fileWrite);


