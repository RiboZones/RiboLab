function MergePML(DataSetName,FileList,Path)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numPMLs=length(FileList);
if numPMLs > 0
    fid=fopen(fullfile(Path,[DataSetName,'.pml']),'wt');
    for i=1:numPMLs
        fprintf(fid, ['@',FileList{i},'\n']);
    end
    fclose(fid);

else
   ErrorBoxGUI('title','No Results Found','string',['I didn''t find any results ',...
        'matching the criteria.']) 
end

end
