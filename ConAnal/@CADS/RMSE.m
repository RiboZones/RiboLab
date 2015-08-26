function [rmse, residuals, Keep] = RMSE(CADS_obj,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

try 
    method=CADS_obj(1).Settings.Structure.RMSEmethod;
catch
    CADS_obj(1).Settings.Structure.RMSEmethod='C-alpha';
end

switch method
    case 'C-alpha'
        selectedatoms=2;
    case 'backbone'
        selectedatoms=1:4;
end

numDataSets=length(CADS_obj);
Keep=cell(numDataSets,1);
rmse=cell(numDataSets,1);
residuals=cell(numDataSets,1);
A=cell(numDataSets,1);
BackBonePositions=cell(numDataSets,1);
Positions=cell(numDataSets,1);
Res=cell(numDataSets,1);

for i=1:numDataSets
    
    num_models=length(CADS_obj(i).Results); 
    numSubsets=length(CADS_obj(i).Subsets);
    BackBonePositions{i}=cell(num_models,1);
    Missing=cell(num_models,1);

    for model=1:num_models
        A{i}{model,1}=ismember(CADS_obj(i).Keep(model).Alignment',CADS_obj(i).Keep(model).PDB');
    end
    KeepCols=sum(cell2mat(A{i}),2)==num_models;
    
    for model=1:num_models
        Res{i}(model)=Residues(CADS_obj(i).Results(model).Name);
        Res{i}(model).GroupResidues(CADS_obj(i).Results(model).Protein.FAM)
        BackBonePositions{i}{model}=cell(numSubsets,1);
        for subset=1:numSubsets
            [~,index]=ismember(CADS_obj(i).Keep(model).Alignment(intersect(find(KeepCols),...
                CADS_obj(i).Subsets{subset}))',Res{i}(model).ResidueNumber');
            Missing{model}{subset}=index==0;
            index(index==0)=[];
            Keep{model}{subset}=index;
            Positions{model}{subset}=Res{i}(model).Position(Keep{model}{subset});
            
            for j=1:length(Positions{model}{subset})
                numats=size(Positions{model}{subset}{j});
                if numats(1)>1
                    BBP=Positions{model}{subset}{j}(selectedatoms,:);
                else
                    BBP=[NaN,NaN,NaN];
                end
                
                BackBonePositions{i}{model}{subset}=[BackBonePositions{i}{model}{subset};...
                    BBP];
            end
            
        end
    end
    
    
    if num_models==2
        for subset=1:numSubsets
            remove=or(Missing{1}{subset},Missing{2}{subset});
            if size(BackBonePositions{i}{1}{subset},1)>size(BackBonePositions{i}{2}{subset},1)
                BackBonePositions{i}{1}{subset}(remove,:)=[];
            else
                BackBonePositions{i}{2}{subset}(remove,:)=[];
            end
            Keep{i}{subset}(remove)=[];
            rmse{i}{subset}=sqrt(mean(sum((BackBonePositions{i}{1}{subset}-BackBonePositions{i}{2}{subset}).^2,2)));
            residuals{i}{subset}=sqrt(sum((BackBonePositions{i}{1}{subset}-BackBonePositions{i}{2}{subset}).^2,2))';
     
        end
        L=length(CADS_obj(i).Keep(1).Alignment);
        R=nan(L,1);
        [K,I]=sort(cell2mat(Keep{i}));
        r=cell2mat(residuals{i});
        R(K)=r(I);
        CADS_obj(i).Results(1).Residuals=R;
        CADS_obj(i).Results(2).Residuals=R;
        CADS_obj(i).Results(1).RMSE=rmse{i};
        CADS_obj(i).Results(2).RMSE=rmse{i};
        
        
        
    else
        BBP=[BackBonePositions{i}{:}];
         for subset=1:numSubsets
            X=reshape(cell2mat(BBP(subset,:)'),size(BBP{subset,1},1),[]);
            BBP_bar{subset}=[mean(X(:,1:num_models),2),mean(X(:,(1:num_models)+num_models),2),...
                mean(X(:,(1:num_models)+2*num_models),2)];
         end
        error('not done yet')
        
    end

  
    
end