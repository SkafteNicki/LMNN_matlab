function figureSave(handle,filename,folder,format)
%% Description
% figureSave save the figure with the handle with a given filename, in a
% given folder, in a given format
% INPUT
%   - handle: handle to figure. Can be one of the following options
%       * single handle to one figure
%
%       * multiple handle to several figure. Need to be in the format h(1) =
%       handle to figure one, h(2) = handle to figure two ect. The figures
%       will be named: filename1.format, filename2.format ect.
%
%       * empty brackets [ ]. Will then save the last current figure.
%
%       * string 'all'. Will save all active figures. The figures will be 
%       named: filename1.format, filename2.format ect.
%   - filename: string with filename on. Do not include filetype in the end
%   of the name. Can also be empty brackets [ ], will then be named 'figure'.
%
%   - folder: string with folder to put the files in. If the folder do not 
%     exist, the function will create it. Can be one of the follwing options:
%       * string with absolut path to folder
%
%       * string with relative path, define from the current folder
%
%       * empty brackets [ ]. Will save to the current folder
%
%       * string 'Desktop'. Will save to the desktop.
%   
%   - format: a list of formats in curly brackets e.i format =
%   {'format1,'format2,...}. Can choose between the following formats
%       * 'fig','eps','jpeg','png','tiff','pdf','bmp','epsBW' (black and
%       white)
%
% EXEMPELS
%   figureSave([ ],[ ],[ ],[ ]);
%   Will save the current figure in .eps format with name 'figure.eps' to
%   the current folder.
%   ----
%   figureSave([ ],'test',[ ],[ ]); 
%   Will save the current figure in .eps format with name 'test.eps' to the 
%   current folder 
%   ----
%   figureSave([ ],'test','testFolder',[ ]);
%   Will save the current figure in .eps format with name 'test.eps' to the 
%   new folder called 'testFolder placed in the current folder
%   ----
%   figureSave('all',[ ],[ ],{'eps','bmp'});
%   Will save all active figures in both .eps and .bmp format with the
%   names 'figure1.eps',figure1.bmp','figure2.eps','figure2.bmp'... to the
%   current folder
%
%
% Nicki Skafte, bachelor student at Technical University of Denmark
% Email: s123182@student.dtu.dk
% Last edit: 24-06-2015

%% Function
% Check if the handle is in one of the right formats
if ischar(handle)
    if ~strcmp(handle,'all')
        error('Undefined handle to figures');
    else
        handle = findall(0,'Type','figure');
        if isempty(handle)
            error('No handles found');
        end
    end
elseif isempty(handle)
    handle = gcf;
elseif ~ishandle(handle)
    error('Undefined handle to figures');  
end

% Check if folder exist else make it
if ischar(folder)
    if strcmp(folder,'Desktop')
        folder = winqueryreg('HKEY_CURRENT_USER', ...
        'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'...
            , 'Desktop');  
    elseif exist(folder,'dir') == 0
        mkdir(folder)
    end
elseif isempty(folder)
    folder = pwd;
else
    error('Folder is not in a valid format');
end

% Check if filename exist else create own
if ~ischar(filename) && ~isempty(filename)
    error('Invalid filename');
elseif isempty(filename)
    filename = 'figure';
end

% Check for valid formats
validFormatNames = {'fig','eps','jpeg','png','tiff','pdf','bmp','epsBW'};
validFormat = {'fig','-depsc','-djpeg','-dpng','-dtiff','-dpdf','-dbmp','-deps'};
if isempty(format);
    format = {'-depsc'};
elseif any(ismember(validFormatNames,format))
    if length(format) == sum(ismember(validFormatNames,format))
        formatList = format;
        format = validFormat(ismember(validFormatNames,format));
    else
        error('Invalid format');
    end
else
    error('Invalid format');
end

% Main part
if length(format) == 1 && length(handle) == 1
    % If single format and single handle, use the build in function print, 
    % to print the figure in the right format and place
    idx = find(ismember(validFormat,format));
    file = [folder '/' filename '.' validFormatNames{idx}];
    if idx == 1;
        print(handle,file);
    else
        print(handle,validFormat{idx},file);
    end
elseif length(handle) == 1
    % If only single handle but multiple formats, call function in a
    % recursion for each of the formats
    for f = 1:length(format)
        figureSave(handle,filename,folder,formatList(f));
    end
else
    % If multiple handles and multiple formats, extend to filename with the
    % ending 1,2,3... and call the function in a recursion for each handle
    % and each format
    for h = 1:length(handle)
        for f = 1:length(format)
            newFilename = [filename num2str(h)];
            figureSave(handle(h),newFilename,folder,formatList(f));
        end
    end
end

end