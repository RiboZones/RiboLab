function Proteins = BuildProteins(newcenter,shell_boundaries,...
    variability_bins,cSequence,variability,File)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    variability_bins='standard';
end

if ~isempty(newcenter)
    if exist('File','var')
        FAMs=ImportPDBs(File);
    else
        FAMs=ImportPDBs();
    end    
    numProteins=length(FAMs);
    if strcmp(shell_boundaries,'ribosome')
        shellboundaries=[0 10+realmin,20+realmin,30+realmin,40+realmin,...
            50+realmin,60+realmin,70+realmin,80+realmin,90+realmin,100+realmin,...
            110+realmin,120+realmin,130+realmin,140+realmin,Inf];
    else
        shellboundaries=shell_boundaries;
    end
else
    numProteins=1;
end
    
for i=1:numProteins   
    if ~isempty(newcenter)
        Proteins(i)=Protein(FAMs{i}.Name);
        Proteins(i).PopulateProtein(FAMs{i});
        if nargin > 0
            Proteins(i).ReCenter(newcenter);
        end
        Proteins(i).DistanceFromCenter();
        if nargin < 5
            [ cSequence, variability ] = importTBL(FAMs{i}.Name);
        else
            InPDB=unique([Proteins(i).FAM.Model.resSeq]);
            variability=variability{i}(InPDB);
            cSequence=cSequence{i}(InPDB);
        end
        Proteins(i).binShells(shellboundaries);
    else
        %recycle shell_boundaries for name
        Proteins(i)=Protein(shell_boundaries);
        variability=variability{i};
        cSequence=cSequence{i};
    end    
    Proteins(i).addConsensusSequence({cSequence});
    Proteins(i).addVariability({variability});
    h=figure('Name',['Protein Variability (',Proteins(i).Name,')'],'NumberTitle','off');
    set(h,'Units','Normalized')
    set(h,'Position',[.1 .2 .2 .7])
    Proteins(i).PlotVariability(variability_bins);
end

