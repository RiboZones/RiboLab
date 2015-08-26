classdef ConAnalOutput < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        Protein
        Alignment
        Variability
        Ramachandran
        Map
        FilteredMap
        FilteredMapLevel
        species3D
        pdb
        chainID
        Residuals
        RMSE
        Stats
    end
    
    methods
        function CAOut=ConAnalOutput(Protein,Alignment,Variability)
            if nargin==1
                CAOut.Name=Protein;
            end
            
            
            if nargin==3
                CAOut.Protein=Protein;
                CAOut.Name=Protein.Name;
                CAOut.Alignment=Alignment;
                CAOut.Variability=Variability;
            end
        end
        
        function CreateRamachandran(CAOut,pdb,chain,plot)
            if nargin < 4
                plot='Separate';
            end
            CAOut.Ramachandran=ramachandran(pdb,'chain',chain,'glycine',...
                'true','regions','true','plot',plot);
        end
        
        %         function CreateContactMap(CAOut,CutOff,subset)
        % %             CAOut.Map= MapContacts('L2_TT','r23S','A',CutOff,subset);
        %         end
        
        function AddPDB(CAOut,pdb,chainID)
            CAOut.pdb=pdb;
            CAOut.chainID=chainID;
        end
        
        function AddContactMap(CAOut,map)
            CAOut.Map=map;
        end
        
        function AddContactMapFiltered(CAOut,map,level)
            CAOut.FilteredMap=map;
            CAOut.FilteredMapLevel=level;
        end
        
        function AddSpecies3D(CAOut,species3D)
            CAOut.species3D=species3D;
        end
        
        function PlotVariability(CAOut,variability_bins)
            if nargin < 2
                variability_bins='standard';
            end
            figure()
            CAOut.Protein.PlotVariability(variability_bins);
        end
        
        function ShowAlignment(CAOut)
            showalignment(CAOut.Alignment)
        end
        
        function ShowCladogram(CAOut)
            distances = seqpdist(CAOut.Alignment,'Method','Jukes-Cantor');
            tree = seqlinkage(distances,'UPGMA',CAOut.Alignment);
            h = plot(tree,'orient','top');
        end
        
        function ShowLogo(CAOut)
            seqlogo(CAOut.Alignment,'Alphabet','AA');
        end
        
        function PlotRamachandran(CAOut)
            if ~isfield(CAOut.pdb,'Header')
                CAOut.pdb.Header.idCode=CAOut.Name;
            end
            CAOut.CreateRamachandran(CAOut.pdb,CAOut.chainID,'Separate')
        end
        
        function PlotAverageVariability(CAOut,span,spacing)
            if nargin <3
                spacing=5;
            end
            if nargin < 2
                span=5;                
            end
            Pro=[CAOut.Protein];
            numSamples=length(Pro);
            lengths=zeros(1,numSamples);
            
            variability={Pro.variability}';
            for i=1:numSamples
                lengths(i)=length(variability{i});
            end
            maxlength=max(lengths);
            AllVariability=nan*ones(numSamples,maxlength);
            vs=nan*ones(maxlength,numSamples);
            for i=1:numSamples
                AllVariability(i,1:lengths(i))=variability{i};
            end
            AllVariability=AllVariability';
            upperoffset=spacing*(numSamples-1);
            for i=1:numSamples;
                vs(1:lengths(i),i)=smooth(AllVariability(1:lengths(i),i),span)+upperoffset-(i-1)*spacing;
            end
            plot(vs)
            xlabel('Residue number')
            y=sprintf('Shannon Entropy (+%0.1fi) [bits]',spacing);
            ylabel(y)
            strtitle=sprintf('Average Protein Variability [moving average, span=%d]',round(span));
            title(strtitle)
            legend({CAOut.Name}','Interpreter','none','Location','BestOutside')
            xlimits=xlim;
            for i=1:numSamples-1;
                line([0,xlimits(2)],[i*spacing,i*spacing],'Color','k')
            end
        end
        
        function RebuildPDB(CAOut,File)
            if nargin < 2
               File=[CAOut(1).Name,'_var.pdb']; 
            end
            resSeq=[CAOut(1).pdb.Model.Atom.resSeq];
            B=unique(resSeq);
            [~,ind]=ismember(resSeq,B);
            %OldtempFactor=[CAOut(1).pdb.Model.Atom.tempFactor];
            variability=10*CAOut(1).Protein.variability;
            NewTempFactor=variability(ind);
            PDB=CAOut(1).pdb;
            for i=1:length(resSeq)
                PDB.Model.Atom(i).tempFactor=NewTempFactor(i);
            end
            if isfield(PDB,'Header')
                PDB=rmfield(PDB,'Header');
            end
            pdbwrite(File,PDB)
        end
        
        function AD=ContactDistance(CAOut,PDB2,chain2)
            pdb1 = PDBentry('name1');
            pdb2 = PDBentry('name2');
            pdb1.PDBfromStruct(CAOut(1).pdb,'newID1')
            pdb2.PDBfromStruct(PDB2,'newID2')
            [~,AD] = MapContacts(pdb1,pdb2,chain2,inf);           
            
        end
    end
    
    
    
end

