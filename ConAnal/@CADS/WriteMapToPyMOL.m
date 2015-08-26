function [ FileNames ] = WriteMapToPyMOL(CADS_object,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
SavePDBmode=false();

numDataSets=length(CADS_object);
FileNames={};

if nargin > 1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'PDBfile'
                PDBfilename=varargin{2*ind};
            case 'SavePDB'
                SavePDBmode=varargin{2*ind};
        end
    end
end

for dataset_ind=1:numDataSets
    numModels=length(CADS_object.Species);
    for model_ind=1:numModels
        if exist('PDBfilename','var')
            [pdb_path,pdb_name]=fileparts(PDBfilename);
            filename=fullfile(pdb_path,[pdb_name,'.pml']);
        else
            filename=[CADS_object(dataset_ind).Name,'_',CADS_object(dataset_ind).Species{model_ind}, '.pml'];
            filename(isspace(filename))='_';
            pdb_name=filename;
        end
        Map=vertcat(CADS_object(dataset_ind).Results(model_ind).FilteredMap.Y);
        num_objects=size(Map,1);
        if num_objects > 1
            
            FileNames=[FileNames,{[pdb_name,'.pml']}];
            
            fid=fopen(filename,'wt');
            fprintf(fid, ['load ',CADS_object(dataset_ind).PDB(model_ind).ID,'.pdb','\n']);
            %         fprintf(fid, ['enable ',CADS_object(dataset_ind).Settings.PyMOL.ObjectNames{model_ind}, '\n']);
            %         fprintf(fid, ['enable ',CADS_object(dataset_ind).Settings.PyMOL.Target{model_ind}, '\n']);
            fprintf(fid, ['disable ',CADS_object(dataset_ind).PDB(model_ind).ID,'\n']);

            fprintf(fid,'\n');
            %     fwrite(fid, sprintf('\n'));                                % terminate this line
            %     fclose(fid);
            
            
            %         g=regexp([Map{:,2}],'([0-9]+)','tokens');
            
            for object_ind=1:num_objects
                contactsA=regexp(cellstr(Map{object_ind,2}),'(?<name>[^-]+)_(?<chain>[^_]*)_[\s]*(?<number>[\w]+)','names');
                contactsB=regexp(cellstr(Map{object_ind,3}),'(?<name>[^-]+)_(?<chain>[^_]*)_[\s]*(?<number>[\w]+)','names');
                
                v=[contactsB{:}];
                chains={v.chain};
                chainList=unique(chains);
                numChains=length(chainList);
                resiStr=cell(numChains,1);
                for i=1:numChains
                    rescontactnumbers=sprintf('%s+',v(ismember(chains,chainList{i})).number);
                    rescontactnumbers(end)='';
                    resiStr{i}=['(resi ',rescontactnumbers,' and chain ',chainList{i},') or '];
                end
                ContactedResiduesString=[resiStr{:}];
                ContactedResiduesString(end-3:end)='';
                ContactedResiduesString=['(',ContactedResiduesString,')'];
                
                %             resin=g{object_ind}{1};
                %             restype=Map{object_ind,2}(1);
                fprintf(fid, ['create ',CADS_object(dataset_ind).Settings.PyMOL.CoreNames{model_ind},'_',...
                    contactsA{1}.chain,'_',contactsA{1}.name,contactsA{1}.number,...
                    ', ','(',CADS_object(dataset_ind).Settings.PyMOL.ObjectNames{model_ind},...
                    ' and resi ',contactsA{1}.number,' and chain ',contactsA{1}.chain,')',...
                    ' or ','(',CADS_object(dataset_ind).Settings.PyMOL.ObjectNames{model_ind},...
                    ' and ', ContactedResiduesString,')','\n']);
                fprintf(fid, ['as spheres, ',CADS_object(dataset_ind).Settings.PyMOL.CoreNames{model_ind},...
                    '_',contactsA{1}.chain,'_',contactsA{1}.name,contactsA{1}.number,' and resi ', contactsA{1}.number,...
                    ' and chain ',contactsA{1}.chain,'\n']);
                fprintf(fid, ['color yellow, ',CADS_object(dataset_ind).Settings.PyMOL.CoreNames{model_ind},...
                    '_',contactsA{1}.chain,'_',contactsA{1}.name,contactsA{1}.number,' and resi ', contactsA{1}.number,...
                    ' and chain ',contactsA{1}.chain,'\n']);
                
                fprintf(fid, ['as sticks, ',CADS_object(dataset_ind).Settings.PyMOL.CoreNames{model_ind},...
                    '_',contactsA{1}.chain,'_',contactsA{1}.name,contactsA{1}.number,' and ',...
                    ContactedResiduesString,'\n']);
                fprintf(fid, ['util.cbaw ',CADS_object(dataset_ind).Settings.PyMOL.CoreNames{model_ind},...
                    '_',contactsA{1}.chain,'_',contactsA{1}.name,contactsA{1}.number,' and ',...
                    ContactedResiduesString,'\n']);
                if SavePDBmode
                    fprintf(fid, ['save ',CADS_object(dataset_ind).Settings.PyMOL.CoreNames{model_ind},...
                        '_',contactsA{1}.chain,'_',contactsA{1}.name,contactsA{1}.number,'.PDB, ',...
                        CADS_object(dataset_ind).Settings.PyMOL.CoreNames{model_ind},...
                        '_',contactsA{1}.chain,'_',contactsA{1}.name,contactsA{1}.number,'\n']);
                end
                fprintf(fid,'\n');
                fprintf(fid, ['zoom all ','\n']);

            end
            fclose(fid);
        end
    end
end




end

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
%
% end

