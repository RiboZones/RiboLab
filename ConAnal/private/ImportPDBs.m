function FAMs=ImportPDBs(file)

if nargin > 0
    
    if ispc()
        slash=strfind(file,'\');
    else
        slash=strfind(file,'/');
    end
    if ~isempty(slash)
        cd(file(1:slash(end)-1));
    else
        cd(file);
    end
    PathName=file(1:slash(end));
    FileName=file(slash(end)+1:end);   
    ID=FileName(1:end-4);                                                      % If no backslashes were found, the ID would just be the file name without the .pdb
    
    if exist([ID,'.mat'],'file') == 2
        load([ID,'.mat'])
        else
            pdb=importdata(file);
            save([ID,'.mat'],'pdb','-v6')
        end
        FAM=FullAtomModel(ID);                                                 % Instantiate
        FAM.PopulateFAM(pdb);                                                  % Populate the model with data from the pdb sructure
        FAMs={FAM};
else
    [FileName,PathName] = uigetfile({'*.pdb'},'Select the PDF File',...
        'MultiSelect', 'on');
    if ~isequal(FileName,0) && ~isequal(PathName,0)
        h=PleaseWait();
        if ~iscellstr(FileName)
            FileName={FileName};
        end
        FAMs=cell(1,length(FileName));
        for i=1:length(FileName)
            ID=FileName{i}(1:end-4);                                                      % If no backslashes were found, the ID would just be the file name without the .pdb
            file=strcat(PathName,FileName{i});
            if exist([ID,'.mat'],'file') == 2
                load([ID,'.mat'])
            else
                pdb=importdata(file);
                save([ID,'.mat'],'pdb','-v6')
            end
            FAM=FullAtomModel(ID);                                                 % Instantiate
            FAM.PopulateFAM(pdb);                                                  % Populate the model with data from the pdb sructure
            FAMs{i}=FAM;
        end
        delete(h)
    else
        disp('no files selected')
        FAMs='none';
    end
end