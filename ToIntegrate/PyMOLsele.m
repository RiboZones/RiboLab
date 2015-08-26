function [ output_args ] = PyMOLsele(List_Res, ObjName, filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin <2 || isempty(ObjName)
    ObjName='all';
end
List_Res=List_Res(List_Res~=0);
command=['sele ',[ObjName,' and '],'resi '];
selected=sprintf('%d+',List_Res);
selected(end)=[];

disp([command,selected])

end

% function WriteToFile(results,ID,append,CustomName)
%             num_objects=length(results.Pattern);
%             command=cell(1,num_objects);
%             if nargin==4
%                 ID=CustomName(1:end-4);
%             end
%             filename=[ID '.pml'];
%             if ~append
%                 fid=fopen(filename,'wt');
%                 fprintf(fid, ['load ' ID '.pdb']);
%                 fwrite(fid, sprintf('\n'));                                % terminate this line
%                 fclose(fid);
%             end
%             for i=1:num_objects         
%                 fid=fopen(filename,'at');
%                 command{i}=['create ' results.Pattern_chain '_' ...
%                     num2str(results.Pattern{i}(1)) ', ' 'chain ' ...
%                     results.Pattern_chain ' and resi '];
%                 fprintf(fid, command{i});
%                 fprintf(fid,'%d',results.Pattern{i}(1));
%                 if length(results.Pattern{i})>1
%                     fprintf(fid,'+%d',results.Pattern{i}(2:end));
%                 end
%                 command{i}=[' or chain ' results.Match_chain ' and resi '];
%                 fprintf(fid, command{i});
%                 fprintf(fid,'%d',results.Match{i}(1));
%                 if length(results.Match{i})>1
%                     fprintf(fid,'+%d',results.Match{i}(2:end));
%                 end
%                 fprintf(fid,'\r\n');  
%                 fclose(fid);
%             end