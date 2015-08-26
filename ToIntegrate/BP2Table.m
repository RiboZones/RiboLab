function Table=BP2Table(BP,varargin)

discard_backbone=true();
TableFormat='paper';
Protein_Col=false();
Merge=true();

if nargin > 1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'IncludeItems'
                IncludeItems=varargin{2*ind};
            case 'Discard_BackBone'
                discard_backbone=varargin{2*ind};
            case 'TableFormat'
                TableFormat=varargin{2*ind};
            case 'Map'
                MyMap=varargin{2*ind};
            case 'ItemList'
                ItemList=varargin{2*ind};
            case 'ProteinCol'
                Protein_Col=varargin{2*ind};
            case 'Merge'
                Merge=varargin{2*ind};
        end
    end
end


numBP=length(BP);

switch TableFormat
    
    case 'paper'
        
        typelist=cell(numBP,1);
        for i=1:numBP
            KeepRes=true(1,length(BP(i).Data));
            PairedItems=strtrim({BP(i).Data(KeepRes).BP1_Num;BP(i).Data(KeepRes).BP2_Num}');
            if exist('IncludeItems','var')
                inSet=ismember(PairedItems,IncludeItems);
                KeepRows=inSet(:,1)' & inSet(:,2)';
            else
                KeepRows=true(size(PairedItems,1),1)';
            end
            
            typelist{i}=unique(lower({BP(i).Data(KeepRows).BP_Type}));
            if discard_backbone
                typelist{i}=setdiff(typelist{i},{'c35','c53'});
            end
            [~,I]=ismember(lower({BP(i).Data.BP_Type}),typelist{i});
            
            table=cell(length(typelist{i}),1);
            for j=1:length(typelist{i})
                %         table{j}(:,1)={BP(i).Data(I==j & KeepRows).BP1_Chain}';
                table{j}(:,1)={BP(i).Data(I==j & KeepRows).BP1_Num}';
                table{j}(:,2)={BP(i).Data(I==j & KeepRows).BP2_Num}';
                %         table{j}(:,3)={BP(i).Data(I==j & KeepRows).BP1_Name}';
                %         table{j}(:,4)={BP(i).Data(I==j & KeepRows).BP2_Name}';
                table{j}(:,3)=strcat({BP(i).Data(I==j & KeepRows).BP1_Name},...
                    '-',{BP(i).Data(I==j & KeepRows).BP2_Name})';
                bpt={BP(i).Data(I==j & KeepRows).BP_Type}';
                for k=1:length(bpt)
                    table{j}{k,4}=[upper(bpt{k}(2)),'/',upper(bpt{k}(3))];
                    switch lower(bpt{k}(1))
                        case 'c'
                            switch bpt{k}(2)
                                case {'3','5'}
                                    table{j}{k,5}='backbone';
                                otherwise
                                    table{j}{k,5}='cis-basepair';
                            end
                        case 't'
                            table{j}{k,5}='trans-basepair';
                        case 's'
                            switch bpt{k}(2)
                                case '_'
                                    table{j}{k,4}=['S/',bpt{k}(3)];
                                    switch bpt{k}(5)
                                        case 'R'
                                            table{j}{k,5}='base-sugar';
                                        case 'P'
                                            table{j}{k,5}='base-phosphate';
                                    end
                                case 'W'
                                    table{j}{k,4}=['SW/',bpt{k}(4)];
                                    switch bpt{k}(6)
                                        case 'R'
                                            table{j}{k,5}='base-sugar';
                                        case 'P'
                                            table{j}{k,5}='base-phosphate';
                                    end
                                otherwise
                                    table{j}{k,5}='stacking';
                            end
                        case 'p'
                            table{j}{k,5}='stacking';
                            table{j}{k,4}='perp';
                        case 'h'
                            table{j}{k,4}=['H/',bpt{k}(3)];
                            switch bpt{k}(5)
                                case 'R'
                                    table{j}{k,5}='base-sugar';
                                case 'P'
                                    table{j}{k,5}='base-phosphate';
                            end
                        case 'w'
                            table{j}{k,4}=['W/',bpt{k}(3)];
                            switch bpt{k}(2)
                                case '_'
                                    switch bpt{k}(5)
                                        case 'R'
                                            table{j}{k,5}='base-sugar';
                                        case 'P'
                                            table{j}{k,5}='base-phosphate';
                                    end
                                case 'a'
                                    table{j}{k,5}='water';
                                    table{j}{k,4}='water';
                            end
                        case 'z'
                            table{j}{k,5}='protein';
                            table{j}{k,4}=['rRNA/',bpt{k}(2:end)];
                        otherwise
                            table{j}{k,5}='other';
                    end
                end
                %         table{j}(:,4)={BP(i).Data(I==j & KeepRows).BP_Type}';
                %         table{j}(:,4)={BP(i).Data(I==j & KeepRows).BP_Type(1)}';
                
                %         table{j}(:,4)={BP(i).Data(I==j & KeepRows).BP2_Chain}';
                if isvarname(typelist{i}{j})
                    Table.(typelist{i}{j})=table{j};
                elseif exist('Table','var') && isfield(Table,'Other')
                    Table.Other=[Table.Other;table{j}];
                else
                    Table.Other=table{j};
                end
            end
            
            bptA={BP(i).Data.BP_Type}';
            if discard_backbone
                notbackbone=~ismember(bptA,{'c35','c53'})';
                KeepRows=KeepRows & notbackbone;
            end
            bptA=bptA(KeepRows);
            Table.All(:,1)={BP(i).Data(KeepRows).BP1_Num}';
            Table.All(:,2)={BP(i).Data(KeepRows).BP2_Num}';
            Table.All(:,3)=strcat({BP(i).Data(KeepRows).BP1_Name},...
                '-',{BP(i).Data(KeepRows).BP2_Name})';
            %         Table.All(:,4)={BP(i).Data(KeepRows).BP_Type}';
            
            for k=1:length(bptA)
                Table.All{k,4}=[upper(bptA{k}(2)),'/',upper(bptA{k}(3))];
                switch lower(bptA{k}(1))
                    case 'c'
                        switch bptA{k}(2)
                            case {'3','5'}
                                Table.All{k,5}='backbone';
                            otherwise
                                Table.All{k,5}='cis-basepair';
                        end
                    case 't'
                        Table.All{k,5}='trans-basepair';
                    case 's'
                        switch bptA{k}(2)
                            case '_'
                                Table.All{k,4}=['S/',bptA{k}(3)];
                                switch bptA{k}(5)
                                    case 'R'
                                        Table.All{k,5}='base-sugar';
                                    case 'P'
                                        Table.All{k,5}='base-phosphate';
                                end
                            case 'W'
                                Table.All{k,4}=['SW/',bptA{k}(4)];
                                switch bptA{k}(6)
                                    case 'R'
                                        Table.All{k,5}='base-sugar';
                                    case 'P'
                                        Table.All{k,5}='base-phosphate';
                                end
                            otherwise
                                Table.All{k,5}='stacking';
                        end
                    case 'p'
                        Table.All{k,5}='stacking';
                        Table.All{k,4}='perp';
                    case 'h'
                        Table.All{k,4}=['H/',bptA{k}(3)];
                        switch bptA{k}(5)
                            case 'R'
                                Table.All{k,5}='base-sugar';
                            case 'P'
                                Table.All{k,5}='base-phosphate';
                        end
                    case 'w'
                        Table.All{k,4}=['W/',bptA{k}(3)];
                        switch bptA{k}(2)
                            case '_'
                                switch bptA{k}(5)
                                    case 'R'
                                        Table.All{k,5}='base-sugar';
                                    case 'P'
                                        Table.All{k,5}='base-phosphate';
                                end
                            case 'a'
                                Table.All{k,5}='water';
                                Table.All{k,4}='water';
                        end
                    case 'z'
                        Table.All{k,5}='protein';
                        Table.All{k,4}=['rRNA/',bpt{k}(2:end)];
                        
                    otherwise
                        Table.All{k,5}='other';
                end
            end
        end
        
    case 'website'
        tables=cell(numBP,1);
        for i=1:numBP
            if (iscell(Protein_Col) || Protein_Col)
                tables{i}(1,:)={'pairIndex','resIndex1','resIndex2','bp_type','ProteinName'};
                tables{i}(2,:)={'int','int','int','varchar(6)','varchar(6)'};
            else
                tables{i}(1,:)={'pairIndex','resIndex1','resIndex2','bp_type'};
                tables{i}(2,:)={'int','int','int','varchar(6)'};
            end
            
            c1={BP(i).Data.BP1_Chain};c2={BP(i).Data.BP2_Chain};
            d1={BP(i).Data.BP1_Num};d2={BP(i).Data.BP2_Num};
            e1={c1{:};d1{:}}'; e2={c2{:};d2{:}}';
            if ~isempty(BP(i).Data)
                ResListA=strcat(e1(:,1), e1(:,2));
                ResListB=strcat(e2(:,1), e2(:,2));
                [~,I1]=ismember(ResListA,regexprep(ItemList,'_',''));
                [~,I2]=ismember(ResListB,regexprep(ItemList,'_',''));
                Keep = (I1~=0) & (I2~=0);
                numLines=sum(Keep);
                tables{i}(3:numLines+2,1)=strtrim(cellstr(num2str((1:numLines)')));
                tables{i}(3:numLines+2,2)=strtrim(cellstr(num2str(I1(Keep)-1)));
                tables{i}(3:numLines+2,3)=strtrim(cellstr(num2str(I2(Keep)-1)));
                tables{i}(3:numLines+2,4)={BP(i).Data(Keep).BP_Type};
                if iscell(Protein_Col)
                    tables{i}(3:numLines+2,5)=repmat({Protein_Col{i}},numLines,1);
                end
            end
            
        end
        if Merge
            Table=vertcat(tables{:});
            %Remove headers. Maybe later don't even put them in.
            Table(ismember(Table(:,1),{'int','pairIndex'}),:)=[];
            % Reindex
            for j = 1:size(Table,1)
                Table{j,1}=num2str(j);
            end
        else
            Table=tables;
        end
    case 'CustomData'
        tables=cell(numBP,1);
        for i=1:numBP
            if (Protein_Col)
                %tables{i}(1,:)={'pairIndex','resIndex1','resIndex2','bp_type','ProteinName'};
                %tables{i}(2,:)={'int','int','int','varchar(6)','varchar(6)'};
            else
                tables{i}(1,:)={'pairIndex','Residue_i','Residue_j','Int_Type'};
            end
            
            c1={BP(i).Data.BP1_Chain};c2={BP(i).Data.BP2_Chain};
            d1={BP(i).Data.BP1_Num};d2={BP(i).Data.BP2_Num};
            e1={c1{:};d1{:}}'; e2={c2{:};d2{:}}';
            if ~isempty(BP(i).Data)
                ResListA=strcat(e1(:,1), e1(:,2));
                ResListB=strcat(e2(:,1), e2(:,2));
                [~,I1]=ismember(ResListA,regexprep(ItemList,'_',''));
                [~,I2]=ismember(ResListB,regexprep(ItemList,'_',''));
                Keep = (I1~=0) & (I2~=0);
                numLines=sum(Keep);
                tables{i}(2:numLines+1,1)=strtrim(cellstr(num2str((1:numLines)')));
                tables{i}(2:numLines+1,2)=strtrim(ResListA(Keep));
                tables{i}(2:numLines+1,3)=strtrim(ResListB(Keep));
                tables{i}(2:numLines+1,4)={BP(i).Data(Keep).BP_Type};
                if iscell(Protein_Col)
                    tables{i}(2:numLines+1,5)=repmat({Protein_Col{i}},numLines,1);
                end
            end
            
        end
        if Merge
            Table=vertcat(tables{:});
            %Remove headers. Maybe later don't even put them in.
            Table(ismember(Table(:,1),{'int','pairIndex'}),:)=[];
            % Reindex
            for j = 1:size(Table,1)
                Table{j,1}=num2str(j);
            end
        else
            Table=tables;
        end
end
end