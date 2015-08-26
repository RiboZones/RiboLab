function [ Protein_Contact_Table ] = ProteinContactTable(CADS_obj,myMap,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

TableFormat='website';
Magnesium_mode=false();
Combine_Cols=false();
SubsetInd = 1;
% merge=true();
%
if nargin > 2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            %             case 'merge'
            %                 merge=varargin{2*ind};
            case 'TableFormat'
                TableFormat = varargin{2*ind};
            case 'Magnesium'
                Magnesium_mode = varargin{2*ind};
            case 'CombineCols'
                Combine_Cols = varargin{2*ind};
            case 'SubsetInd'
                SubsetInd = varargin{2*ind};
        end
    end
end

numPDBs=length(CADS_obj);
Protein_Contact_Table=cell(1,1);

for i=1:numPDBs
    numSpecies=length(CADS_obj(i).PDB);
    for j=1:numSpecies
        
        if regexp(myMap(j).ItemNames{1},'[\w]_')
            %assume combo maps
            try
                residue_list=regexprep(unique(vertcat(CADS_obj(i).Results(j).FilteredMap(SubsetInd).contacts{:})),'[\s]*','');
            catch
               %No contacts. Check to see if legitimate. 
               Protein_Contact_Table{j}(:,i+1)=num2cell(zeros(length(myMap(j).ItemNames),1));
               break;
            end
        else
            contacts=regexp(unique(vertcat(CADS_obj(i).Results(j).FilteredMap(SubsetInd).contacts{:})),'._[\s]*([\w]+)','tokens');
            d=[contacts{:}];
            ContactResi=vertcat(d{:});
            residue_list=ContactResi;
        end
        [inMap,I]=ismember(residue_list,myMap(j).ItemNames);
        [~,II]=sort(I(I~=0));
        r=residue_list(inMap);
        [~,III]=ismember(r(II),myMap(j).ItemNames);
        
        switch TableFormat
            case 'website'
                Protein_Contact_Table{j}(:,1)=myMap(j).ItemNames';
                %Protein_Contact_Table{j}(:,i+1)=num2cell(zeros(length(myMap(j).ItemNames),1));
                if Magnesium_mode
                    if Combine_Cols
                        aa=num2cell(zeros(length(myMap(j).ItemNames),1));
                        if ~isempty(II)
                            %aa(III,1)=num2cell(2*ones(length(r(II)),1));
                            %No longer need the 2.
                            aa(III,1)=num2cell(ones(length(r(II)),1));
                        end
                        if i == 1
                            Protein_Contact_Table{j}(:,2)=aa;
                        else
                            newcol=logical(cell2mat(aa));
                            oldcol=logical(cell2mat(Protein_Contact_Table{j}(:,2)));
                            updatecol=newcol & ~oldcol;
                            Protein_Contact_Table{j}(updatecol,2)=aa(updatecol);
                        end                                  
                    else
                        Protein_Contact_Table{j}(:,i+1)=num2cell(zeros(length(myMap(j).ItemNames),1));
                        if sum(III>0)
                            Protein_Contact_Table{j}(III,i+1)=num2cell(2*ones(length(r(II)),1));
                        end
                    end
                else
                    Protein_Contact_Table{j}(:,i+1)=num2cell(zeros(length(myMap(j).ItemNames),1));
                    if sum(III>0)
                        Protein_Contact_Table{j}(III,i+1)=num2cell(ones(length(r(II)),1));
                    end
                end
            case 'paper'
                Protein_Contact_Table{j}(:,1)=r;
                CADS_obj(i).Results(j).FilteredMap(1).Y
        end
        
    end
end


% if merge
%     Protein_Contact_Table=vertcat(Protein_Contact_Table{:});
% end




end
