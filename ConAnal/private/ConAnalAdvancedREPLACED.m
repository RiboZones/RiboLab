function [ CAOut ] = ConAnalAdvanced( CADS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

newcenter=[-32.3240,123.0920,161.9990];
% shellboundaries=[0 10+realmin,20+realmin,30+realmin,40+realmin,...
%     50+realmin,60+realmin,70+realmin,80+realmin,90+realmin,100+realmin,...
%     110+realmin,120+realmin,130+realmin,140+realmin,Inf];
shellboundaries=[0, 20+realmin,40+realmin,60+realmin,80+realmin,...
    100+realmin,120+realmin,140+realmin,Inf];

variability_bins='standard';
Alignment=CADS.Alignment;

cSequence=seqconsensus(Alignment,'gaps','all');
Variability=ShannonEntropy(Alignment);
variability=Variability;
%cSequenceCut=cSequence;

names=fieldnames(CADS.PDB);
Proteins(length(names))=Protein('blank');
CAOut(length(names))=ConAnalOutput();
% Map=cell(1,length(names));
MapUC=cell(1,length(names));

for model=1:length(names)
    FAM=FullAtomModel([CADS.Name,'_',names{model}]);                                       % Instantiate
    FAM.PopulateFAM(CADS.PDB.(names{model}));
    Proteins(model)=Protein(FAM.Name);
    Proteins(model).PopulateProtein(FAM);
    Proteins(model).ReCenter(newcenter);
    Proteins(model).DistanceFromCenter();
    Proteins(model).binShells(shellboundaries);
    Proteins(model).addConsensusSequence(cSequence);
    Proteins(model).addVariability(variability);
    H=figure('Name',['Protein Variability (',Proteins(model).Name,')'],'NumberTitle','off');
    set(H,'Units','Normalized')
    set(H,'Position',[.1 .2 .2 .7])
    Proteins(model).PlotVariability(variability_bins,CADS.keep.PDB.(names{model}));
    CAOut(model)=ConAnalOutput(Proteins(model),Alignment,Variability);    
   
    drawnow
    
    pdb1 = PDBentry([names{model},'Subject']);
    pdb2 = PDBentry([names{model},'Target']);
    pdb1.PDBfromStruct(CADS.PDB.(names{model}),'newID1')
    pdb2.PDBfromStruct(CADS.Map.(names{model}),'newID2')
%     Map{model} = MapContacts(pdb1,pdb2,[],3.4);
%     CAOut(model).AddContactMap(Map{model});
    MapUC{model}=MapContacts(pdb1,pdb2,[],3.4,CADS.keep.Alignment.(names{model})(CAOut(model).Variability<=1));
    CAOut(model).AddContactMapFiltered(MapUC{model},0);

end
    
    
    
    
end




