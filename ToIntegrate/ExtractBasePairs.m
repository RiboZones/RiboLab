function [ BasePairs ] = ExtractBasePairs(file)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
fid=fopen(file);
C=textscan(fid,'%f%s%s%s','Delimiter',',','HeaderLines',1);
fclose(fid);

c2=regexp(C{2}(:),':','split');

c2=[c2{ismember(str2double(C{3}),[1,2])}]';

bp1=c2(1:2:end);
bp2=c2(2:2:end);

bp1=regexp(bp1,'_.','split');
bp2=regexp(bp2,'_','split');

a=[bp1{:}];
b=[bp2{:}];

chain1=a(1:2:end)';
chain2=b(2:2:end)';

res1=a(2:2:end)';
res2=b(1:2:end)';
res2=regexp(res2(:),'\d+','match');

BasePairs=[strcat(cellstr([chain1{:}]'),'_',num2str(str2double(res1))),...
    strcat(cellstr([chain2{:}]'),'_',num2str(str2double([res2{:}]')))];

%fix residues with iCodes
indices1=find(isnan(str2double(res1)));
if ~isempty(indices1)
    iCodeRes1=res1(indices1);
    for i=1:length(iCodeRes1)
        padding=length(BasePairs{1})-1-length(iCodeRes1{i});
        BasePairs{indices1(i),1}=cell2mat([chain1{indices1(i)},'_',repmat(' ',1,padding),res1(indices1(i))]);
    end
end

indices2=find(isnan(str2double([res2{:}]')));
if ~isempty(indices2)
    iCodeRes2=res2(indices2);
    for i=1:length(iCodeRes2)
        padding=length(BasePairs{1})-1-length(iCodeRes2{i});
        BasePairs{indices2(i),2}=cell2mat([chain2{indices2(i)},'_',repmat(' ',1,padding),res2(indices2(i))]);
    end
end