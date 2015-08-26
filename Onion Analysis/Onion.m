classdef Onion < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    % Onion was originally deseigned for spherical shells. It is now being
    % updated to support layers of arbitrary deseignation. We will use
    % ribosomal phases. Because of this, Onion isn't a good name anymore.
    % We may want to rename this if making a version 2.0 sometime.
    
    properties (SetAccess = public)
        Name = 'un-named'
        Structure % class(PDBentry)
        Position = struct('cart',[],'spherical',[]);
        Model    = struct('Layers',cell(1),'Shells',cell(1));
        Counts   = struct('NA',[],'AA',[],'Mg',[],'BP',[],'Aform',[],'AAcontact',[]);
        Density  = struct('AA',[],'Mg',[],'BP',[],'Aform',[],'SS',[],...
            'SeqCon',[],'RMSD',[],'AAcontact',[]);
        Settings = struct('center',[],'layers',[],'ignore_chains',[],...
            'bp_file',[],'bt_file',[],'main_chain',[],'alignment',[]);
        IncludeRes={};
    end
    
    methods
        function onion_obj = Onion(name,model,newcenter,layers,...
                IgnoreChains,bp_file,bt_file,main_chain,alignment)
            if nargin >= 1
                onion_obj.Name  = name;
            end
            
            if nargin >= 2
                onion_obj.PopulateOnion(model)
            else
                onion_obj.Structure=PDBentry(onion_obj.Name);
            end
            
            if nargin >= 3 && ~isempty(newcenter)
                onion_obj.Settings.center=newcenter;
            else
                onion_obj.Settings.center=[0,0,0];
            end
            onion_obj.Recenter();
            
            if nargin >= 4 && ~isempty(layers)
                if length(layers) == 1
                    newlayers=0:layers:max(onion_obj.Position.spherical(:,3));
                    newlayers=[newlayers,newlayers(end)+layers,Inf];
                    onion_obj.Settings.layers=newlayers;
                else
                    onion_obj.Settings.layers=layers;
                end
                if nargin >= 5 && ~isempty(IgnoreChains)
                    onion_obj.Settings.ignore_chains=IgnoreChains;
                end
                onion_obj.BuildLayers()
            end
            
            if nargin >= 6 && ~isempty(bp_file)
                onion_obj.Settings.bp_file=bp_file;
            end
            
            if nargin >= 7 && ~isempty(bt_file)
                onion_obj.Settings.bt_file=bt_file;
            end
            
            if nargin >= 8 && ~isempty(main_chain)
                onion_obj.Settings.main_chain=main_chain;
            end
            
            if nargin >= 9 && ~isempty(alignment)
                onion_obj.Settings.alignment=alignment;
            end
        end
        
        function Rename(onion_obj,name)
            onion_obj.Name=name;
        end
        function PopulateOnion(onion_obj,model)
            if nargin == 1
                onion_obj.Structure=PDBentry(onion_obj.Name);
                [~,pdb]=ImportPDBs();
                onion_obj.Structure.PDB=pdb;
                %onion_obj.FAM=FAMs{1};
            else
                for i=1:length(onion_obj)
                    switch class(model)
                        case 'cell'
                            onion_obj.Structure=PDBentry(onion_obj.Name);
                            onion_obj(i).Structure.PDB=model{i};
                            %onion_obj(i).FAM=FullAtomModel(onion_obj(i).Name);
                            %onion_obj(i).FAM.PopulateFAM(model{i});
                        case 'struct'
                            onion_obj.Structure=PDBentry(onion_obj.Name);
                            onion_obj(i).Structure.PDB=model(i);
                            %onion_obj(i).FAM=FullAtomModel(onion_obj(i).Name);
                            %onion_obj(i).FAM.PopulateFAM(model(i));
                        case 'PDBentry'
                            onion_obj(i).Structure=model(i);
                            %onion_obj(i).FAM=FullAtomModel(model(i).Name);
                            %onion_obj(i).FAM.PopulateFAM(model(i).PDB);
                        case 'FullAtomModel'
                            %onion_obj(i).FAM=model(i);
                            onion_obj.Structure=PDBentry(onion_obj.Name);
                            onion_obj(i).Structure.PDB=model(i);
                        otherwise
                            onion_obj.Structure=PDBentry(onion_obj.Name);
                            [~,pdb]=ImportPDBs(model{i});
                            onion_obj(i).Structure.PDB=pdb;
                            %onion_obj(i).FAM=FAMs{1};
                    end
                    onion_obj(i).Structure.Process
                end
            end
        end
        
        function Recenter(onion_obj,newcenter)
            Pos=cell(1,length(onion_obj));
            for i=1:length(onion_obj)
                if nargin == 2
                    onion_obj(i).Settings.center=newcenter{i};
                end
                Pos{i}(:,1)=[onion_obj(i).Structure.PDB.Model.Atom.X]';
                Pos{i}(:,2)=[onion_obj(i).Structure.PDB.Model.Atom.Y]';
                Pos{i}(:,3)=[onion_obj(i).Structure.PDB.Model.Atom.Z]';
                onion_obj(i).Position.cart=Pos{i}-repmat(onion_obj(i).Settings.center,[length(Pos{i}),1]);
                [theta,phi,r]=cart2sph(onion_obj(i).Position.cart(:,1),onion_obj(i).Position.cart(:,2),...
                    onion_obj(i).Position.cart(:,3));
                onion_obj(i).Position.spherical=[theta,phi,r];
            end
        end
        
        function BuildLayers(onion_obj,layers,IgnoreChains)
            for i=1:length(onion_obj)
                if nargin > 1
                    onion_obj(1).Settings.layers=layers{i};
                    if nargin > 2
                        onion_obj(i).Settings.ignore_chains=IgnoreChains{i};
                    end
                end
                
                %onion_obj(i).FAM.renumberRes()
                Res=Residues(onion_obj(i).Name);
                Res.GroupResidues(onion_obj(i).Structure,onion_obj(i).Position.spherical);
                
                if ~isempty(onion_obj(i).Settings.ignore_chains)
                    %Lr=[Res.ListOfResiduesU{:}];
                    %Lr1=Lr(1:length(Res.ListOfResiduesU{1}):end);
                    keep=~ismember(Res.ResidueChain,onion_obj(i).Settings.ignore_chains);
                    Res.CutRes(keep);
                end
                resSeq=[Res.UniqueResSeq{:}];
                [~, ResCutoffs]=unique(resSeq);
                sortedCutoffs=sort(ResCutoffs);
                %                 Res.CutRes(I);
                
                Pos=cell2mat(Res.Position);
                Distance=Pos(:,3);
                [~,bin] = histc(Distance,onion_obj(1).Settings.layers);
                
                numres=length(sortedCutoffs);
                j=1;
                Shell=zeros(1,numres);
                for k=1:numres
                    Shell(k)=min(bin(j:sortedCutoffs(k)));
                    j=sortedCutoffs(k)+1;
                end
                TheoreticalMaxBin=length(onion_obj(1).Settings.layers)-1;
                
                if max(bin)==TheoreticalMaxBin
                    maxbin=max(bin)-1;
                else
                    maxbin=max(bin);
                end
                
                %                 bin=bin';
                onion_obj(i).Model.Layers=cell(1,maxbin);
                onion_obj(i).Model.Shells=cell(1,maxbin);
                for m=1:maxbin
                    onion_obj(i).Model.Layers{m}=Residues([Res.Name,'_',num2str(m)]);
                    onion_obj(i).Model.Layers{m}.CutRes(Shell==m,Res);
                    onion_obj(i).Model.Shells{m}=m*ones(sum(Shell==m),1);
                end
            end
        end
        
        function BuildLayersBySubset(onion_obj,subsets,IgnoreChains)
            for i=1:length(onion_obj)
                if nargin > 1
                    onion_obj(1).Settings.layers=subsets{i};
                    if nargin > 2
                        onion_obj(i).Settings.ignore_chains=IgnoreChains{i};
                    end
                end
                
                Res=Residues(onion_obj(i).Name);
                Res.GroupResidues(onion_obj(i).Structure,onion_obj(i).Position.spherical);
                
                if ~isempty(onion_obj(i).Settings.ignore_chains)
                    keep=~ismember(Res.ResidueChain,onion_obj(i).Settings.ignore_chains);
                    Res.CutRes(keep);
                end
                resSeq=regexprep(Res.ItemNames,'\s','');
                
                maxbin = length(subsets{i});
                
                onion_obj(i).Model.Layers=cell(1,maxbin);
                onion_obj(i).Model.Shells=cell(1,maxbin);
                for m=1:maxbin
                    onion_obj(i).Model.Layers{m}=Residues([Res.Name,'_',num2str(m)]);
                    onion_obj(i).Model.Layers{m}.CutRes(ismember(resSeq,subsets{i}{m}),Res);
                    onion_obj(i).Model.Shells{m}=m*ones(sum(ismember(resSeq,subsets{i}{m})),1);
                end
            end
            onion_obj(i).BuildLayersByProximity();
            
        end
        function BuildLayersByProximity(onion_obj)
            %This function is intended to divide up auxillary chains such
            %as proteins and salts based on proximity to the main chain,
            %which was split up with the BySubset feature.
            Map=cell(length(onion_obj),1);
            for i=1:length(onion_obj)
                %calculate Target based on what is already in the model.
                Res=Residues(onion_obj(i).Name);
                Res.GroupResidues(onion_obj(i).Structure);
                resSeq=Res.ItemNames;
                ModeledRes = [onion_obj(i).Model.Layers{:}];
                KeepRes = vertcat(ModeledRes.ItemNames);
                [~,KeepResInd]= ismember(KeepRes,resSeq);
                Res.CutRes(KeepResInd(KeepResInd>0),Res);
                
                [Map{i},~,Data]=MapContacts(onion_obj(i).Structure,...
                    Res,[],[],setdiff(resSeq,KeepRes));
                
                numHits=size(Map{i}.Y,1);
                layers=zeros(numHits,1);
                numLayers = length(onion_obj(i).Model.Layers);
                
                for h=1:numHits
                    for m=1:numLayers
                        if sum(ismember(Map{i}.contacts{h},onion_obj(i).Model.Layers{m}.ItemNames)) > 0
                            layers(h)=m;
                            break;
                        end
                    end
                end
                
                for m=1:numLayers
                    Res2=Residues([ Data.RES.name1.Name,'_',num2str(m)]);
                    Res2.CutRes(layers==m, Data.SubsetRes1);
                    onion_obj(i).Model.Layers{m}= onion_obj(i).Model.Layers{m} + Res2;
                    onion_obj(i).Model.Shells{m}= m * ones(length(onion_obj(i).Model.Layers{m}.ItemNames),1);
                end
            end
        end
        function ComputeAAdensity(onion_obj)
            for i=1:length(onion_obj)
                numLayers=length(onion_obj(i).Model.Layers);
                AA_count=zeros(1,numLayers);
                NA_count=zeros(1,numLayers);
                for j=1:length(onion_obj(i).Model.Layers)
                    Protein_index=isProtein(onion_obj(i).Model.Layers{j}.ResidueName);
                    Nucleic_acid_index=isNucleicAcid(onion_obj(i).Model.Layers{j}.ResidueName);
                    AA_count(j)=sum(Protein_index);
                    NA_count(j)=sum(Nucleic_acid_index);
                end
                onion_obj(i).Counts.AA=AA_count;
                onion_obj(i).Counts.NA=NA_count;
                onion_obj(i).Density.AA=round(100*AA_count./NA_count)/100;
            end
        end
        function PlotAAdensity(onion_obj,force)
            if nargin < 2
                force=0;
            end
            figure()
            hold all
            for i=1:length(onion_obj)
                if isempty(onion_obj(i).Density.AA) || force
                    onion_obj(i).ComputeAAdensity
                end
                plot(onion_obj(i).Density.AA,'LineWidth',5)
            end
            hold off
            %legend({onion_obj.Name},'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('Amino Acid density')
            title('Amino Acid density vs. Shell')
        end
        function ComputeAAContactDensity(onion_obj)
            for i=1:length(onion_obj)
                numLayers=length(onion_obj(i).Model.Layers);
                AA_count=zeros(1,numLayers);
                NA_count=zeros(1,numLayers);
                Map=cell(length(onion_obj),1);
                for j=1:length(onion_obj(i).Model.Layers)
                    %Protein_index=isProtein(onion_obj(i).Model.Layers{j}.ResidueName);
                    %AA_count(j)=sum(Protein_index);
                    [Map{i},~,Data]=MapContacts(onion_obj(i).Structure,onion_obj(i).Structure,...
                        [],3.4,onion_obj(i).IncludeRes,...
                        'AtomFilterType',{'rna','protein'});
                    
                    Keep=ismember(vertcat(Map{i}.Y{:,1}),onion_obj(i).Model.Layers{j}.ItemNames);
                    AA_count(j)=length(vertcat(Map{i}.Y{Keep,3}));
                    
                    Nucleic_acid_index=isNucleicAcid(onion_obj(i).Model.Layers{j}.ResidueName);
                    NA_count(j)=sum(Nucleic_acid_index);
                end
                onion_obj(i).Counts.AAContacts=AA_count;
                onion_obj(i).Counts.NA=NA_count;
                onion_obj(i).Density.AAcontact=round(100*AA_count./NA_count)/100;
            end
        end
        function PlotAAContactDensity(onion_obj,force)
            if nargin < 2
                force=0;
            end
            figure()
            hold all
            for i=1:length(onion_obj)
                if isempty(onion_obj(i).Density.AAcontact) || force
                    onion_obj(i).ComputeAAContactDensity
                end
                plot(onion_obj(i).Density.AAcontact,'LineWidth',5)
            end
            hold off
            %legend({onion_obj.Name},'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('Amino Acid Contact density')
            title('Amino Acid Contact density vs. Shell')
        end
        
        function CandRes=ComputeMGdensity(onion_obj)
            for i=1:length(onion_obj)
                numLayers=length(onion_obj(i).Model.Layers);
                NA_count=zeros(1,numLayers);
                for j=1:length(onion_obj(i).Model.Layers)
                    Nucleic_acid_index=isNucleicAcid(onion_obj(i).Model.Layers{j}.ResidueName);
                    NA_count(j)=sum(Nucleic_acid_index);
                end
                [MG_count,CandRes]=MgPcoord(onion_obj(i));
                onion_obj(i).Counts.NA=NA_count;
                onion_obj(i).Counts.Mg=MG_count;
                onion_obj(i).Density.Mg=MG_count./NA_count;
            end
        end
        function PlotMGdensity(onion_obj,force)
            if nargin < 2
                force=0;
            end
            figure()
            hold all
            for i=1:length(onion_obj)
                if isempty(onion_obj(i).Density.Mg) || force
                    onion_obj(i).ComputeMGdensity();
                end
                plot(onion_obj(i).Density.Mg,'LineWidth',5)
            end
            hold off
            %legend({onion_obj.Name},'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('Mg density')
            title('Mg density vs. Shell')
        end
        
        function ComputeMGvsProtein(onion_obj,force)
            if nargin < 2
                force=0;
            end
            for i=1:length(onion_obj)
                if isempty(onion_obj(i).Density.Mg) || force
                    onion_obj(i).ComputeMGdensity();
                end
                if isempty(onion_obj(i).Density.AA) || force
                    onion_obj(i).ComputeAAdensity();
                end
            end
        end
        
        function PlotMGvsProtein(onion_obj,force)
            if nargin < 2
                force=0;
            end
            figure()
            hold all
            for i=1:length(onion_obj)
                if isempty(onion_obj(i).Density.Mg) || isempty(onion_obj(i).Density.AA) || force
                    onion_obj(i).ComputeMGvsProtein(force);
                end
                plot(onion_obj(i).Density.AA(onion_obj(i).Density.Mg>0),...
                    1./onion_obj(i).Density.Mg(onion_obj(i).Density.Mg>0),'.','MarkerSize',20)
            end
            set(gca,'XLim',[0,4])
            hold off
            %legend({onion_obj.Name}, 'Interpreter', 'none','Location','Best')
            xlabel('Amino acid density')
            ylabel('Mg dilution')
            title('Mg dilution vs. Amino acid density')
        end
        
        function PlotCounts(onion_obj,force)
            if nargin < 2
                force=0;
            end
            for i=1:length(onion_obj)
                if isempty(onion_obj(i).Counts.Mg) || isempty(onion_obj(i).Counts.AA)...
                        || isempty(onion_obj(i).Counts.NA) || force
                    onion_obj(i).ComputeMGvsProtein(force)
                end
            end
            figure();
            for i=1:length(onion_obj)
                hold all
                plot(onion_obj(i).Counts.Mg,'LineWidth',5)
            end
            hold off
            %legend({onion_obj.Name}, 'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('# of Mg')
            title('#Mg vs. Shell')
            figure();
            for i=1:length(onion_obj)
                hold all
                plot(onion_obj(i).Counts.AA,'LineWidth',5)
            end
            hold off
            %legend({onion_obj.Name}, 'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('# of Amino acid residues')
            title('#Amino acid residues vs. Shell')
            figure();
            for i=1:length(onion_obj)
                hold all
                plot(onion_obj(i).Counts.NA,'LineWidth',5)
            end
            hold off
            %legend({onion_obj.Name}, 'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('# of Nucelotides')
            title('#Nucleotides vs. Shell')
        end
        
        function ComputeBPdensity(onion_obj)
            try
                %             if length(onion_obj)==1
                %                 bpfile={bpfile};
                %             end
                for i=1:length(onion_obj)
                    [ Processed_BPs ] = Process_FR3D( onion_obj(i).Settings.bp_file, [],'FilterTypes',{'cww'});
                    BasePairs=[strcat(cellstr([Processed_BPs.Data.BP1_Chain]'),'_',{Processed_BPs.Data.BP1_Num}'),...
                        strcat(cellstr([Processed_BPs.Data.BP2_Chain]'),'_',{Processed_BPs.Data.BP2_Num}')];
                    S=vertcat(onion_obj(i).Model.Shells{:});
                    r=[onion_obj(i).Model.Layers{:}];
                    R=vertcat(r(:).ItemNames);
                    keep=ismember(BasePairs,regexprep(R,'\s',''));
                    [~,index]=ismember(BasePairs(keep(:,1)|keep(:,2),:),regexprep(R,'\s',''));
                    index=index(index~=0);
                    
                    range=minmax(S(index(:))');
                    onion_obj(i).Counts.BP=[nan(1,range(1)-1),hist(S(index(:)),range(1):range(2))];
                    onion_obj(i).Density.BP=onion_obj(i).Counts.BP./...
                        onion_obj(i).Counts.NA(1:range(2))*100;
                end
            catch
            end
        end
        
        function PlotBPdensity(onion_obj,force)
            if nargin < 2
                force=0;
            end
            
            figure()
            hold all
            for i=1:length(onion_obj)
                if isempty(onion_obj(i).Density.BP) || force
                    onion_obj(i).ComputeBPdensity();
                end
                %plot(onion_obj(i).Density.BP)
                plot(onion_obj(i).Density.BP,'LineWidth',5)
            end
            hold off
            %legend({onion_obj.Name}, 'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('Base pairing [%]')
            title('Base pairing vs. Shell')
        end
        
        function ComputeAform(onion_obj)
            try
                %             if length(onion_obj)==1
                %                 btfile={btfile};
                %             end
                for i=1:length(onion_obj)
                    [ResNames,Angles]=ExtractBackboneTorsions(onion_obj(i).Settings.bt_file,...
                        'alpha','gamma','delta','zeta');
                    keepa=Angles(:,1)>=260 & Angles(:,1)<=330;
                    keepy=Angles(:,2)>=35 & Angles(:,2)<=75;
                    keepd=Angles(:,3)>=68 & Angles(:,3)<=93;
                    keepz=Angles(:,4)>=255 & Angles(:,4)<=325;
                    keepA=keepa & keepy & keepd & keepz;
                    ResNames=ResNames(keepA);
                    S=vertcat(onion_obj(i).Model.Shells{:});
                    r=[onion_obj(i).Model.Layers{:}];
                    R=vertcat(r(:).ItemNames);
                    keepB=ismember(ResNames,regexprep(R,'\s',''));
                    ResNames=ResNames(keepB);
                    [~,index]=ismember(ResNames,regexprep(R,'\s',''));
                    range=minmax(S(index(:))');
                    onion_obj(i).Counts.Aform=[nan(1,range(1)-1),hist(S(index(:)),range(1):range(2))];
                    onion_obj(i).Density.Aform=onion_obj(i).Counts.Aform./...
                        onion_obj(i).Counts.NA(1:range(2))*100;
                end
            catch
            end
        end
        
        function PlotAform(onion_obj,force)
            if nargin < 2
                force=0;
            end
            
            figure()
            hold all
            for i=1:length(onion_obj)
                if isempty(onion_obj(i).Density.Aform) || force
                    onion_obj(i).ComputeAform()
                end
                plot(onion_obj(i).Density.Aform,'LineWidth',5)
            end
            hold off
            %legend({onion_obj.Name}, 'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('RNA Conformation in A form [%]')
            title('RNA Conformation in A form vs. Shell')
        end
        
        function ComputeSS(onion_obj,IgnoreChains)
            for i=1:length(onion_obj)
                %alpha-Helices
                [~,Ind]=sort(cellstr([onion_obj(i).Structure.PDB.Helix.initChainID]'));
                Helix=onion_obj(i).Structure.PDB.Helix(Ind);
                
                H_seqs=[[Helix.initSeqNum]',[Helix.endSeqNum]'];
                H_ranges=cell(1,length(H_seqs));
                for j=1:length(H_seqs)
                    H_ranges{j}=colon(H_seqs(j,1),H_seqs(j,2));
                end
                H_L=[Helix.endSeqNum]-[Helix.initSeqNum] + 1;
                C=cellstr([Helix.initChainID]');
                [~,I(:,1),J]=unique(C,'first');
                [~,I(:,2)]=unique(C,'last');
                
                
                numChains=size(I,1);
                chains=cell(numChains,1);
                Exchains=cell(numChains,1);
                H_S=zeros(1,numChains);
                for k=1:numChains
                    H_S(k)=sum(H_L(I(k,1):I(k,2)));
                    chains{k}=C(I(k,1));
                    Exchains{k}=repmat(chains{k},H_S(k),1);
                end
                
                Chains=vertcat(Exchains{:});
                Res=cell2mat(H_ranges)';
                if nargin > 1
                    keep=~ismember(Chains,IgnoreChains);
                    Chains=Chains(keep);
                    Res=Res(keep);
                end
                %warning('No support for iCodes right now!')
                Ahelices=cellstr([[Chains{:}]',repmat('_',size(num2str(Res),...
                    1),1),repmat(' ',size(num2str(Res),1),4-size(num2str(Res),...
                    2)),num2str(Res)]);
                Ahelices=Ahelices(ismember(Ahelices,onion_obj(i).Structure.UniqueResSeq));
                
                
                %beta-sheets
                [~,Ind]=sort(cellstr([onion_obj(i).Structure.PDB.Sheet.initChainID]'));
                Sheet=onion_obj(i).Structure.PDB.Sheet(Ind);
                
                Sseqs=[[Sheet.initSeqNum]',[Sheet.endSeqNum]'];
                S_ranges=cell(1,length(Sseqs));
                for jj=1:length(Sseqs)
                    S_ranges{jj}=colon(Sseqs(jj,1),Sseqs(jj,2));
                end
                
                %warning('No support for iCodes right now!')
                S_L=[Sheet.endSeqNum]-[Sheet.initSeqNum] + 1;
                C=cellstr([Sheet.initChainID]');
                
                [~,II(:,1)]=unique(C,'first');
                [~,II(:,2)]=unique(C,'last');
                
                numChains=size(II,1);
                chains=cell(numChains,1);
                Exchains=cell(numChains,1);
                B_S=zeros(1,numChains);
                for k=1:numChains
                    B_S(k)=sum(S_L(II(k,1):II(k,2)));
                    chains{k}=C(II(k,1));
                    Exchains{k}=repmat(chains{k},B_S(k),1);
                end
                
                Chains=vertcat(Exchains{:});
                S_Res=cell2mat(S_ranges)';
                if nargin > 1
                    keep=~ismember(Chains,IgnoreChains);
                    Chains=Chains(keep);
                    S_Res=S_Res(keep);
                end
                %warning('No support for iCodes right now!')
                Bsheets=cellstr([[Chains{:}]',repmat('_',size(num2str(S_Res),...
                    1),1),repmat(' ',size(num2str(S_Res),1),4-size(num2str(S_Res),...
                    2)),num2str(S_Res)]);
                Bsheets=Bsheets(ismember(Bsheets,onion_obj(i).Structure.UniqueResSeq));
                
                % Compute Counts
                shells=vertcat(onion_obj(i).Model.Shells{:});
                r=[onion_obj(i).Model.Layers{:}];
                R=vertcat(r(:).ItemNames);
                %                 keepA=ismember(Ahelices,R);
                %                 keepB=ismember(Bsheets,R);
                [~,A_index]=ismember(Ahelices,R);
                [~,B_index]=ismember(Bsheets,R);
                A_index=A_index(A_index~=0);
                B_index=B_index(B_index~=0);
                
                A_range=minmax(shells(A_index(:))');
                B_range=minmax(shells(B_index(:))');
                range=minmax([A_range,B_range]);
                if sum(isinf(range)) == 0
                    onion_obj(i).Density.SS=hist([shells(A_index(:));shells(B_index(:))],1:range(2))  ./...
                        onion_obj(i).Counts.AA(1:range(2))*100;
                end
            end
            
        end
        
        function PlotSSpercent(onion_obj,force)
            if nargin < 2
                force=0;
            end
            
            figure()
            hold all
            for i=1:length(onion_obj)
                if isempty(onion_obj(i).Density.SS) || force
                    onion_obj(i).ComputeSS()
                end
                plot(onion_obj(i).Density.SS,'LineWidth',5)
            end
            hold off
            %legend({onion_obj.Name}, 'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('Protein Structure:\alpha-helix/\beta-sheet[%]')
            title('Secondary Structure vs. Shell')
        end
        
        function Plot(onion_obj,force)
            if nargin < 2
                force=0;
            end
            
            onion_obj.PlotCounts(force)
            onion_obj.PlotSequenceConservation(force)
            
            onion_obj.PlotBPdensity(force)
            onion_obj.PlotAform(force)
            
            onion_obj.PlotMGdensity()
            onion_obj.PlotMGvsProtein()
            onion_obj.PlotAAdensity(force)
            onion_obj.PlotAAContactDensity(force)
            onion_obj.PlotSSpercent(force)
        end
        
        function ComputeSequenceConservation(onion_obj,main_chain,alignment)
            
            for i=1:length(onion_obj)
                if nargin == 1
                    %onion_obj(i).Settings.main_chain=onion_obj(i).Structure.ChainID{1};
                end
                if nargin >= 2
                    onion_obj(i).Settings.main_chain=main_chain{i};
                end
                if nargin >= 3
                    onion_obj(i).Settings.alignment=alignment{i};
                end
                
                %% Calculate Shells for main_chain
                Keep = ismember(onion_obj(i).Structure.ChainID,onion_obj(i).Settings.main_chain);
                if ~isempty(onion_obj(i).IncludeRes)
                    Keep_n=intersect(onion_obj(i).Structure.UniqueResSeq(Keep),onion_obj(i).IncludeRes);
                    Keep=ismember(onion_obj(i).Structure.UniqueResSeq,Keep_n);
                end
                if ~iscell(onion_obj(i).Settings.layers)
                    
                    R=onion_obj(i).Position.spherical(Keep,3);
                    [~,bin] = histc(R,onion_obj(i).Settings.layers+realmin);
                    
                elseif iscell(onion_obj(i).Settings.layers)
                    R = onion_obj(i).Structure.UniqueResSeq(Keep);
                    numLayers=length(onion_obj(i).Settings.layers);
                    bin=zeros(length(R),1);
                    for j=1:numLayers
                        bin(ismember(R,onion_obj(i).Model.Layers{j}.ItemNames))=j;
                    end
                else
                    error('unsupported layer type');
                end
                [UresSeq, I]=unique(onion_obj(i).Structure.UniqueResSeq(Keep));
                %This part now requires higher matlab, unless want to make
                %it use legacy unique.
                shell=zeros(1,length(I));
                %shell(1)=min(bin(1:I(1)));
                for j=1:length(UresSeq)-1
                    shell(j)=min(bin(I(j):I(j+1)-1));
                end
                shell(j+1)=min(bin(I(j)+1:end));
                shell(shell==0)=[];
                
                %% calculate variability for alignment
                alignment=onion_obj(1).Settings.alignment;
                unaligned=strfind(alignment(2).Sequence,'-');
                alignment(1).Sequence(unaligned)=[];
                alignment(2).Sequence(unaligned)=[];
                variability=Seq_entropy(alignment);
                if length(shell)~=length(alignment(1).Sequence)
                    shell(unaligned)=[];
                end
                
                %% calculate frequency of identity per shell
                Shells=unique(shell);
                numshells=length(Shells);
                G=cell(1,numshells);
                H=cell(1,numshells);
                numres=zeros(1,numshells);
                for k=1:numshells
                    G{k}=variability{1}(shell==Shells(k));
                    numres(k)=length(G{k});
                    H{k}=sum(G{k}==0);
                end
                onion_obj(i).Density.SeqCon=[nan(1,min(Shells)-1),...
                    100*cell2mat(H)./ numres];
            end
        end
        
        function PlotSequenceConservation(onion_obj,force)
            if nargin == 1
                force=0;
            end
            
            figure()
            hold all
            for i=1:length(onion_obj)
                if isempty(onion_obj(i).Density.SeqCon) || force
                    onion_obj(i).ComputeSequenceConservation()
                end
                plot(onion_obj(i).Density.SeqCon,'LineWidth',5)
            end
            hold off
            %legend({onion_obj.Name}, 'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('Sequence Identity [%]')
            title('Seqeunce Identity vs. Shell')
        end
        
        function ComputeRMSDbyShell(onion_obj)
            for i=1:length(onion_obj)
                if nargin >= 2
                    onion_obj(i).Settings.main_chain=main_chain{i};
                end
                if nargin >= 3
                    onion_obj(i).Settings.alignment=alignment{i};
                end
            end
        end
        
        function PlotRMSDbyShell(onion_obj,force)
            
            
        end
        
        function PlotConservationByShell(onion_obj,Alignment,species3D)
            if nargin == 1
                force=0;
            end
            
            figure()
            hold all
            for i=1:length(onion_obj)
                %                 if isempty(onion_obj(i).Density.SeqCon) || force
                %                     onion_obj(i).ComputeSequenceConservation()
                %                 end
                %                 plot(onion_obj(i).Density.SeqCon,'LineWidth',5)
                SE{i}=Seq_entropy(Alignment{i},'Gaps',1);
                
                %Calculate Shells for main_chain
                R=onion_obj(i).Position.spherical(ismember(...
                    onion_obj(i).Structure.ChainID,onion_obj(i).Settings.main_chain),3);
                [~,bin] = histc(R,onion_obj(i).Settings.layers+realmin);
                [UresSeq, I]=unique(onion_obj(i).Structure.UniqueResSeq(ismember(...
                    onion_obj(i).Structure.ChainID,onion_obj(i).Settings.main_chain)));
                shell=zeros(1,length(I));
                shell(1)=min(bin(1:I(1)));
                for j=2:length(UresSeq)
                    shell(j)=min(bin(I(j-1)+1:I(j)));
                end
                
                %calculate variability for alignment
                alignment=Alignment{i};
                magicnum=species3D{i};%for tt;
                unaligned=strfind(alignment(magicnum).Sequence,'-');
                for ii=1:length(alignment)
                    alignment(ii).Sequence(unaligned)=[];
                end
                %                 unaligned=strfind(alignment(2).Sequence,'-');
                %                 alignment(1).Sequence(unaligned)=[];
                %                 alignment(2).Sequence(unaligned)=[];
                %                 variability=Seq_entropy(alignment);
                if length(shell)~=length(alignment(1).Sequence)
                    shell(unaligned)=[];
                end
                
                %calculate frequency of identity per shell
                Shells=unique(shell);
                numshells=length(Shells)-1;
                G=cell(1,numshells);
                H=cell(1,numshells);
                numres=zeros(1,numshells);
                for k=1:numshells
                    G{k}=mean(SE{i}(shell==Shells(k)));
                    %                     numres(k)=length(G{k});
                    %                     H{k}=sum(G{k}==0);
                end
                meanSE=[nan(1,min(Shells)-1),...
                    cell2mat(G)];
                plot(meanSE)
            end
            hold off
            %legend({onion_obj.Name}, 'Interpreter', 'none','Location','Best')
            xlabel('Shell')
            ylabel('Shannon Entropy [bits]')
            title('Averages Shannon Entropy vs. Shell')
            
        end
        
        function NetCharge=ComputeChargeDensity(onion_obj)
            NetCharge(1,length(onion_obj))=struct('NoMono',[],'Mono',[]);
            for i=1:length(onion_obj)
                NetCharge(i).NoMono=zeros(1,length(onion_obj(i).Model.Layers));
                NetCharge(i).Mono=zeros(1,length(onion_obj(i).Model.Layers));
                figure()
                hold on
                for j=1:length(onion_obj(i).Model.Layers)
                    numPos=sum(ismember(onion_obj(i).Model.Layers{j}.ResidueName,{'LYS','ARG','HIS'}));
                    numNeg=sum(ismember(onion_obj(i).Model.Layers{j}.ResidueName,{'ASP','GLU'}));
                    numMg =sum(ismember(onion_obj(i).Model.Layers{j}.ResidueName,{'MG'}));
                    numMVc=sum(ismember(onion_obj(i).Model.Layers{j}.ResidueName,{'K','NA'}));
                    numPi =sum(ismember(onion_obj(i).Model.Layers{j}.ResidueName,{'A','G','C','U'}));
                    NetCharge(i).NoMono(j)=((numPos-numNeg)/2 + numMg)/numPi*100;
                    NetCharge(i).Mono(j)=((numPos+numMVc-numNeg)/2 + numMg)/numPi*100;
                    
                end
                plot(NetCharge(i).NoMono,'b')
                plot(NetCharge(i).Mono,'r')
                hold off
            end
        end
        
        function Onion_Table=OnionTable(onion_obj,ItemNames,varargin)
            ModelType = 'coarse';
            PreFix=[];
            WriteFile=false();
            
            if nargin > 2
                for ind=1:length(varargin)/2
                    switch varargin{2*ind-1}
                        case 'ModelType'
                            ModelType = varargin{2*ind};
                        case 'PreFix'
                            PreFix = varargin{2*ind};
                        case 'WriteFile'
                            WriteFile = varargin{2*ind};
                    end
                end
            end
            
            
            if nargin < 3
                ModelType = 'coarse';
            end
            numOnions=length(onion_obj);
            Onion_Table=cell(length(ItemNames),2);
            for i=1:numOnions
                switch ModelType
                    case 'coarse'
                        resobjs=[onion_obj(i).Model.Layers{:}];
                        resnums=vertcat(resobjs.ResidueNumber);
                        reschains=vertcat(resobjs.ResidueChain);
                        R=cellstr([[reschains{:}]',char(resnums{:})]);
                        
                        
                        [inMap,I]=ismember(R,regexprep(ItemNames,'_',''));
                        [~,II]=sort(I(I~=0));
                        
                        shells=vertcat(onion_obj(i).Model.Shells{:});
                        s=shells(inMap);
                        r=R(inMap);
                        
                    case 'fine'
                        
                        Ploc=find(ismember({onion_obj(i).Structure.PDB.Model.Atom.AtomName},'P'));
                        Pres=onion_obj(i).Structure.UniqueResSeq(Ploc);
                        Cloc=find(ismember({onion_obj(i).Structure.PDB.Model.Atom.AtomName},{'C5*','C5''','CA'}));%% Added CA for protein support
                        Cres=onion_obj(i).Structure.UniqueResSeq(Cloc);
                        
                        FullList=union(Pres,Cres);
                        Distance=zeros(1,length(FullList));
                        AtomList=zeros(1,length(FullList));
                        
                        [~,Ipr]=ismember(Pres,FullList);
                        Distance(Ipr)=onion_obj(i).Position.spherical(Ploc,3);
                        AtomList(Ipr)=Ploc;
                        
                        [AppendList,Ial]=setdiff(Cres,Pres);
                        [~,Icr]=ismember(AppendList,FullList);
                        Distance(Icr)=onion_obj(i).Position.spherical(Cloc(Ial),3);
                        AtomList(Icr)=Cloc(Ial);
                        
                        R_all=regexprep(onion_obj(i).Structure.UniqueResSeq,'_[\s]*','');
                        R=R_all(AtomList);
                        
                        [inMap,I]=ismember(R,regexprep(ItemNames,'_',''));
                        [~,II]=sort(I(I~=0));
                        r=R(inMap);
                        s=Distance(inMap);
                end
                
                
                [~,III]=ismember(r(II),regexprep(ItemNames,'_',''));
               
                if isempty(PreFix)
                    %Onion_Table(:,1)=ItemNames';
                else
                    xx=ItemNames{III(1)};%% assume one chain per onion, true right now, assume one letter per chain, also true.
                    %Onion_Table(III,1)=regexprep(ItemNames(III),[xx(1),'_'],PreFix{i})';
                    Onion_Table(III,1)=regexprep(ItemNames(III),['^',xx(1),'(_)*'],PreFix{i})';
                end
                Onion_Table(III,2)=num2cell(s(II))';
            end
            
            %removecol=false(1,size(Onion_Table,1));
            for j=1:size(Onion_Table,1)
                if ~isempty(Onion_Table{j,1}) && isempty(Onion_Table{j,2})
                    Onion_Table{j,2}='\N';
                elseif isempty(Onion_Table{j,1}) && isempty(Onion_Table{j,2})
                    %removecol(j)=true;
                    Onion_Table{j,1}=ItemNames{j};
                    Onion_Table{j,2}='\N';
                end
            end
            %Onion_Table(removecol,:)=[];
            
            if WriteFile
                onionname=regexprep(regexprep([onion_obj(:).Name],':[\s]*','_'),'Onion','Onion & ');
                xlswrite([onionname(1:end-2),'.xlsx'],vertcat({'resNum','DataCol'},Onion_Table));
                
            end
        end
    end
end



function index=isProtein(Names)
AminoAcids={'ALA','ARG','ASN','ASP','CYS','GLN','GLU','GLY','HIS',...
    'ILE','LEU','LYS','MET','PHE','PRO','SER','THR','TRP','TYR','VAL'};
index=ismember(Names,AminoAcids);
end

function index=isNucleicAcid(Names)
NucleicAcids={'A','G','C','U'};
index=ismember(Names,NucleicAcids);
end

function [numMg,CandRes]=MgPcoord(onion_obj)
Res=[onion_obj.Model.Layers{:}];
PosAllAtoms=onion_obj.Position.cart';
numMg=zeros(1,length(Res));
CandRes=cell(1,length(Res));

%determine phosphate position
ii=1;
while isempty(onion_obj.Model.Layers{ii}.ItemNames) || ...
        sum(isNucleicAcid(onion_obj.Model.Layers{ii}.ResidueName))==0;
    ii=ii+1;
end
NAindex=find(isNucleicAcid(onion_obj.Model.Layers{ii}.ResidueName));

p=[onion_obj.Model.Layers{ii}.Atoms(NAindex(end),:).remoteInd];
pb=[onion_obj.Model.Layers{ii}.Atoms(NAindex(end),:).branch];
if isempty(pb)
    pb='empty';
end
if strcmp(p(2:3),'PP') || strcmp(pb(1:2),'PP') || strcmp(p(1:2),'PP')
    flag=1;
elseif strcmp(p(end-1:end),'PP') || strcmp(pb(end-1:end),'PP')
    flag=2;
else
    %     error('check phosphate oxygens')
    return
end

for i=1:length(Res)
    if sum(ismember(Res(i).ResidueName,{'C','G','U','A'}))
        PosRESs=Res(i).Position(ismember(Res(i).ResidueName,{'C','G','U','A'}));
        %band aid solution, only use 2nd and 3rd atoms
        for j=1:length(PosRESs)
            switch flag
                case 1
                    PosRESs{j}=PosRESs{j}([2,3],:);
                case 2
                    PosRESs{j}=PosRESs{j}(end-1:end,:);
            end
        end
        PosRESs=cell2mat(PosRESs);
        [RESX,RESY,RESZ]=sph2cart(PosRESs(:,1),PosRESs(:,2),PosRESs(:,3));
        PosRES=[RESX,RESY,RESZ]';
        nnP=nearestneighbour(PosRES,PosAllAtoms,'r', 2.6);
        if size(PosRES,2) < 2
            nnP=nnP';
        end
        %         hits=find(nnP(1,:)>0);
        %         FoundMg=[];
        
        Candidates=unique(nnP(:));
        Candidates=Candidates(Candidates>0);
        CandRes{i}=[onion_obj.Structure.PDB.Model.Atom(Candidates(ismember(...
            {onion_obj.Structure.PDB.Model.Atom(Candidates).resName},{'MG'}...
            ))).resSeq];
        numMg(i)=length(CandRes{i});
        
        %         for j=1:length(hits)
        %             if sum(ismember({onion_obj.FAM.Model(nnP(nnP(:,hits(j))>0,hits(j))).resName},{'MG'}));
        %                 FoundMg=[FoundMg;nnP(ismember({onion_obj.FAM.Model(nnP(nnP(:,hits(j))>0,hits(j))).resName},{'MG'}),j)];
        %                 %numMg(i)=numMg(i)+1;
        %             end
        %         end
        %         numMg(i)=length(unique(FoundMg));
    end
    %     if sum(ismember(Res(i).NamesOfResidues,{'MG'}))
    %         PosMGs=[Res(i).Position{ismember(Res(i).NamesOfResidues,{'MG'})}];
    %         PosMGs=reshape(PosMGs,3,length(PosMGs)/3)';
    %         [MgX,MgY,MgZ]=sph2cart(PosMGs(:,1),PosMGs(:,2),PosMGs(:,3));
    %         PosMg=[MgX,MgY,MgZ]';
    %
    %         nnP=nearestneighbour(PosMg,PosAllAtoms,'r', 2.41);
    %         if size(PosMg,2) < 2
    %             nnP=nnP';
    %         end
    %         hits=find(nnP(1,:)>0);
    %         for j=1:length(hits)
    %             if sum(ismember({onion_obj.FAM.Model(nnP(nnP(:,hits(j))>0,...
    %                     hits(j))).resName},{'C','G','U','A'}));
    %                 numMg(i)=numMg(i)+1;
    %             end
    %         end
    %     end
end
end




























