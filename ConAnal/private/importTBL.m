function [ cSequence, variability ] = importTBL(Name)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    FileName=[Name,'.tbl'];
    if ispc
        PathName=[pwd '\'];
        
    else
        PathName=[pwd '/'];
    end
else
    [FileName,PathName] = uigetfile({'*.tbl';'*.*'},'Select the TBL File',...
        'MultiSelect', 'off');
end

if ~isequal(FileName,0) && ~isequal(PathName,0)
    if ~iscellstr(FileName)
        FileName={FileName};
    end
    cSequence=cell(1,length(FileName));
    variability=cell(1,length(FileName));
    
    for i=1:length(FileName)
        file=strcat(PathName,FileName{i});
        tbl=importdata(file);
        cSequence{i}=strvcat(tbl.textdata(4:end,2)')';
        variability{i}=tbl.data;
    end
end
end

