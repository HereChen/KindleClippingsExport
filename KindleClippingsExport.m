function varargout = KindleClippingsExport(clipImportFile,clipExportFile,varargin)
%KINDLECLIPPINGSEXPORT
%   The software will convert Kindle Clippings into markdown format.
%   Language-surpport Chinese English.
%   1 Get clippings with segment '=========='.
%   2 Clippings none-four lines will be ignorant.
%   3 Test Kindle PaperWhite system 5.4.2.1.
%
%   clipImportFile - input Kindle Clippings txt filename.
%   clipExportFile - export Kindle Clippings txt filename.
%   varargin
%       'encoding' - encoding of the way open txt-file
%                    'UTF-8' 'GBK'
%       filter the clippings with condition...
%       'author' 'bookname' 'clipstyle'
%   varargout - exported clippings data set.(clipExport)
%
%   Default setting...
%   KindleClippingsExport(clipFile,clipExport,'bookname','',
%       'author','','clipstyle','','encoding','UTF-8')
%
%   Example...
%   clipImportFile = 'My Clippings.txt';
%   clipExportFile = 'ClipExportZhouGuoPing.txt';
%   KindleClippingsExport(clipImportFile,clipExportFile,...
%       'bookname','尼采');
%
%   In case of encoding matters...
%   check encoding: slCharacterEncoding()
%   set encoding: slCharacterEncoding('GBK') or 'UTF-8'

%   HereChen
%   (chenlei.here@gmail.com)(herechen.github.io)
%   Copyright 2014 HereChen
%   $Date: 2014/03/28 00:35:45 $

%% deault settings

% default encoding of open txt-file.
encoding = 'UTF-8';
% default filter, no filter.
author = '';
bookname = '';
clipstyle = '';

% varargin
nVarargs = length(varargin);
if nargin < 2, error('At least two input arguments'); end
if nVarargs > 8, error('At most six output arguments'); end
for k=1:2:nVarargs
    varMark = 0;
    if strcmp(varargin{k},'author')
        author = varargin{k+1};
        varMark = 1;
    elseif strcmp(varargin{k},'bookname')
        bookname = varargin{k+1};
        varMark = 1;
    elseif strcmp(varargin{k},'clipstyle')
        clipstyle = varargin{k+1};
        varMark = 1;
    elseif strcmp(varargin{k},'encoding')
        encoding = varargin{k+1};
        varMark = 1;
    end
    if ~varMark
        error('No such argument %s.',char(varargin{k}));
    end
end

% varargout
if nargout == 0, varargout = {}; end
if nargout > 1, error('At most one output arguments'); end

% segment of clippings
segClip = '==========';

%% read every line of clipImportFile

fileID = fopen(clipImportFile,'r','n',encoding);
formatSpec = '%s';                          % 读取格式
clippings = textscan(fileID,formatSpec,...  % 读取，忽略 '='
    'delimiter','\n');
fclose(fileID);

% break if no clippings
if isempty(clippings)||length(clippings{1,1})<5
    warning('No clippings in your file %s',char(clipImportFile));
    return;
end

%% get every note
% get ervery note by segClip.

clippings = clippings{1,1};

% Ignorant clipping if its content is not equal 4 lines.
segIndex = strcmp(clippings,segClip);
segIndex = find(segIndex==1);
subSegIndex = segIndex(2:end) - segIndex(1:end-1);
subSegIndex = [segIndex(1); subSegIndex] - 1;

% the index of not four-line clippings.
noneFourLine = find(subSegIndex~=4);

if numel(noneFourLine)~=0
    % warning for ignorance lines.
    warning('Ignorant clippings in file %s',char(clipImportFile));
    for k=1:numel(noneFourLine)
        fprintf('	Clipping before line %g-th.\n',segIndex(noneFourLine(k)));
    end
    
    % delete none-four-lines clippings.
    segIndex = setdiff(segIndex,segIndex(noneFourLine));
    tempClip = cell(length(clippings)-sum(subSegIndex(noneFourLine))-...
        numel(noneFourLine),1);
    for i=1:numel(segIndex)
        [tempClip{(i-1)*5+1:i*5}] = deal(clippings{segIndex(i)-4:segIndex(i)});
    end
    clippings = tempClip;
end

% split bookname+author location+date clippping
sizeClip = length(clippings)/5;
clipText = cell(sizeClip,3);

if sizeClip==0                              % break if no clipping
    warning('There is no clipping.');
    return;
end

for i=1:3
    if i~=3
        [clipText{:,i}] = deal(clippings{i:5:end,1});
    else
        [clipText{:,i}] = deal(clippings{i+1:5:end,1});
    end
end

%% detail splitting
% bookname author clipping clipping-style location time1 time2
% time1 mm-dd-yy, time2 hh-mm-ssgit pull

clipExport = cell(sizeClip,7);
[clipExport{:,3}] = deal(clipText{:,3});    % save clippings

for i=1:sizeClip
    try
        % save bookname author
        % split by '('
        tempClip = clipText{i,1};
        indexAuthor = find(tempClip=='(');
        if ~isempty(indexAuthor)
            tempTitle = tempClip(1:indexAuthor(end)-1);
            tempAuthor = tempClip(indexAuthor(end)+1:end-1);
        else
            tempAuthor = '';
            tempTitle = tempClip;
        end
    catch
        tempAuthor = '';
        tempTitle = '';
    end
    clipExport{i,1} = tempTitle;            % save bookname
    clipExport{i,2} = tempAuthor;           % save author
    
    try
        % save clipping-style
        % split by （'我的',' 位置',) or ('的',' |') or ('Your ',' at')
        % ('This ',' at') - Article
        tempClip = clipText{i,2};
        tempClipStyle = textscan(tempClip,'%s','delimiter',...
            {'我的',' 位置','的',' |','Your ',' at','This '});
        clipExport{i,4} = tempClipStyle{1,1}{2};

        % save location
        % if double page spread or more.
        tempLocation = regexp(tempClip,'(\d+)-(\d+)','tokens');
        % single page
        if isempty(tempLocation)
            tempLocation = regexp(tempClip,'(\d+)','tokens');
            tempLocation = tempLocation{1}{1,1};
        else
            tempLocation = tempLocation{1,1};
            tempLocation = strcat(tempLocation{1},'-',tempLocation{2});
        end
    catch
        tempLocation = '';
    end
    clipExport{i,5} = tempLocation;         % save location
    
    try
        % save time yy-mm-dd hh-mm-ss
        % split by '添加于' or 'Added on' - time
        % split by ('年','月','日星期') or (', ') - time1 time2
        tempTime = textscan(tempClip,'%s','delimiter',...
            {'添加于','Added on'});
        tempTime = tempTime{1,1};
        tempTime = tempTime{end};

        tempTime2 = regexp(tempTime,'(\d+):(\d+):(\d+)','tokens');
        tempTime2 = tempTime2{1,1};
        tempTime2ch = tempTime2;
        tempTime2 = time2str(tempTime2);        % save time2

        if  ~isempty(strfind(tempTime,'年'))    % Chinese-format
            tempTime12 = strrep(tempTime,tempTime2,'');
            tempTime12 = textscan(tempTime12,'%s','delimiter',...
                {'年','月','日'});
            tempTime12 = tempTime12{1,1};

            tptempTime1 = cell(3,1);
            tptempTime1{1} = tempTime12{1};     % year
            % date month
            for zr=2:3
                tptempTime1{zr} = tempTime12{zr};
                if length(tptempTime1{zr,1})~=2
                    tptempTime1{zr} = strcat('0',tptempTime1{zr,1});
                end
            end
            if  ~isempty(strfind(tempTime,'下午'))
                tempTime2ch{1} = num2str(str2double(tempTime2ch{1})+12);
                tempTime2 = time2str(tempTime2ch);  % save time2
            end

            tempTime1 = date2str(tptempTime1);  % save time1
        else                                    % English-format
            tempTime1 = strrep(tempTime,tempTime2,'');
            tempTime1 = textscan(tempTime1,'%s','delimiter',',');
            tempTime1 = tempTime1{1,1}{2};
            tptempTime1{3,1} = tempTime1(1:2);          % date
            tptempTime1{2,1} = tempTime1(4:end-6);      % month
            tptempTime1{1,1} = tempTime1(end-4:end-1);  % year
            % convert month to num
            tptempTime1{2,1} = month2num(tptempTime1{2,1});
            tempTime1 = date2str(tptempTime1);          % save time1
        end
    catch
        tempTime1 = '';
        tempTime2 = '';
    end
    clipExport{i,6} = tempTime1;            % save time1
    clipExport{i,7} = tempTime2;            % save time2
end

%% delete lines with no clippings

tempNoClip = cell(sizeClip,1);
[tempNoClip{:}] = deal(clipExport{:,3});
tempNoClipIndex = strcmp(tempNoClip,'');
tempNoClipIndex = setdiff(1:sizeClip,find(tempNoClipIndex==1));

sizeClip = length(tempNoClipIndex);
tempNoClip = cell(sizeClip,7);
for k=1:sizeClip
    [tempNoClip{k,:}] = deal(clipExport{tempNoClipIndex(k),:});
end
clipExport = tempNoClip;

%% clipping filter

clipFilterKey = {bookname, author, clipstyle};
for k=1:3
    try
        if ~isempty(clipFilterKey{k})
            sizeClip = size(clipExport,1);
            tempFilterClip = cell(sizeClip,1);
            if k==1                         % bookname
                [tempFilterClip{:}] = deal(clipExport{:,1});
            elseif k==2                     % author
                [tempFilterClip{:}] = deal(clipExport{:,2});
            else                            % clipstyle
                [tempFilterClip{:}] = deal(clipExport{:,4});
            end
            clipExport = clipFilter(clipExport,tempFilterClip,...
                clipFilterKey{k});
        end
    catch
        warning('Clipping filter wrong.');
        return;
    end
end

%% varargout

if nargout==1, varargout{1} = clipExport; end

%% export txt-file

fileWrite = fopen(clipExportFile,'a+','n',encoding);
formarSpec = {'> %s\n\n',...
    '<p style="text-align:right;padding:0 0">%s # %s, %s</p>\n'};
sizeClip = size(clipExport,1);
for i=1:sizeClip
    fprintf(fileWrite, '\n');
    fprintf(fileWrite, formarSpec{1}, clipExport{i,3});
    fprintf(fileWrite, formarSpec{2}, clipExport{i,5}, ...
        clipExport{i,6}, clipExport{i,7});
end
fprintf('Clipping Export Success!\n%s\\%s\n',pwd,clipExportFile);
fclose(fileWrite);

%% subfunction

    % convert hh mm ss to hh-mm-ss.
    function timestr = time2str(timehms)
        for g=1:3
            if length(timehms{1})~=2
                timehms{g} = strcat('0',timehms{g});
            end
        end
        timestr = strcat(timehms{1},':',timehms{2},':',timehms{3});
    end

    % convert yy mm dd to yy-mm-dd.
    function datestr = date2str(dateymr)
        datestr = strcat(dateymr{1},'-',dateymr{2},'-',dateymr{3});
    end

    % convert month-str to No.-str.
    function monthstr = month2num(monthorigin)
        switch monthorigin
            case 'January', monthstr = '01';
            case 'February', monthstr = '02';
            case 'March', monthstr = '03';
            case 'April', monthstr = '04';
            case 'May', monthstr = '05';
            case 'June', monthstr = '06';
            case 'July', monthstr = '07';
            case 'August', monthstr = '08';
            case 'September', monthstr = '09';
            case 'October', monthstr = '10';
            case 'November', monthstr = '11';
            case 'December', monthstr =  '12';
            otherwise, monthstr = monthorigin;
        end
    end

    % clipping filter.
    function clipExport = clipFilter(clipExport,tempFilterClip,filter)
        tempFilterClipIndex = strfind(tempFilterClip,filter);
        tempFilterClipIndex = find(~cellfun(@isempty,tempFilterClipIndex));

        sizeFilterClip = length(tempFilterClipIndex);
        tempFilterClip = cell(sizeFilterClip,7);
        for fk=1:sizeFilterClip
            [tempFilterClip{fk,:}] = ...
                deal(clipExport{tempFilterClipIndex(fk),:});
        end
        clipExport = tempFilterClip;
    end

end