function exportcif( ~, cifStr, new_name )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

fileID = fopen([new_name,'.cif'],'w');
for i = 1: length(cifStr)
    fprintf(fileID,'%s\n',cifStr{i});
end
fclose(fileID);
end

