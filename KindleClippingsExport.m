function clipExport = KindleClippingsExport(clipImportFile,clipExportFile)
%KINDLECLIPPINGSEXPORT
%   check encoding: slCharacterEncoding()
%   set encoding: slCharacterEncoding('GBK') or 'UTF-8'
%   clipExport is the last result of export.

%   HereChen
%   2014/03/27 01:01:30

%% 格式说明说明
% 输出参数：书名 作者 笔记类型 位置 时间 内容 (位置不需要)
% 笔记类型：[书签 Bookmark] [笔记 Note]  [标注 Highlight]
% 时间类型：[添加于 Added on]

% clipText
% 书名作者: ?知乎周刊·读书这件小事 (知乎)
% 位置时间: - 我的笔记 位置 #762 | 添加于2013年12月24日星期二 下午09:55:16
% 笔记内容：good .试试

% format
% 书名作者：bookname' '(author)
% 位置时间：xxxx #location xxx | 添加于/Added on' 'time
% 注意事项：英文笔记在内容下方，中文笔记在内容上方

encoding = 'UTF-8';                         % 读取文件的编码格式

%% 读取每行数据

fileID = fopen(clipImportFile,'r','n',encoding);
formatSpec = '%s';                          % 读取格式
clippings = textscan(fileID,formatSpec,...  % 读取，忽略 '='
    'delimiter','\n');
fclose(fileID);

%% 提取三条

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

%% 按条件提取

% 书名 作者 笔记类型 位置 时间 内容 (笔记类型尚未记录)
clipExport = cell(sizeClip,5);      % 标题 作者 位置 时间 内容
dx = [1 2 3 4 5];                   % 对应 标题 作者 位置 时间 内容 作为下标
                                    % 用以记录对应内容保存所在列
[clipExport{:,5}] = deal(clipText{:,3});

for i=1:sizeClip
    % title author
    tempClip = clipText{i,1};
    indexAuthor = find(tempClip=='(');
    % 以 '(' 判断是否有作者，并且取最后一个 '(' 为开端
    % 不考虑有作者没有标题的情况狂
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
    % 跨页位置
    tempClip = clipText{i,2};
    tempLocation = regexp(tempClip,'(\d+)-(\d+)','tokens');
    % 如果不跨页
    if isempty(tempLocation)
        tempLocation = regexp(tempClip,'(\d+)','tokens');
        tempLocation = tempLocation{1};
    else
        tempLocation = tempLocation{1,1};
        tempLocation = strcat(tempLocation{1},'-',tempLocation{2});
    end
    
    clipExport{i,dx(3)} = tempLocation;
    
    % time
    % 用 '添加于' 或 'Added on' 来分割取得
    tempTime = textscan(tempClip,'%s','delimiter',{'添加于','Added on'});
    tempTime = tempTime{1,1};
    
    clipExport{i,dx(4)} = tempTime{end};
end

%% 文件保存

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


