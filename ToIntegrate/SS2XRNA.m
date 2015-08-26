function SS2XRNA( DataSetName, SVG_file, BPseq_file, SSType, ShiftBase, ShiftDirection )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    SSType='BPseq';
end
if nargin < 5
    ShiftBase=Inf;
end

if nargin < 6
    ShiftDirection=0;
end


RiboLabMap = Map2D(DataSetName);
RiboLabMap.AddMap(SVG_file);

numNucs=length(RiboLabMap.ItemNames);

switch SSType
    case 'BPseq'
        XRNAstruct = BPseq2XRNA_BasePairs( BPseq_file , ShiftBase, ShiftDirection);
    case 'FR3D'
        XRNAstruct = FR3D2XRNA_BasePairs( BPseq_file );
    otherwise
        error('Type not supported');
end
numHelices=length(XRNAstruct);

fid=fopen([DataSetName,'.xrna'],'wt');

fprintf(fid, ['<ComplexDocument Name=''',DataSetName,'''>','\n']);
fprintf(fid, ['<SceneNodeGeom CenterX=''',num2str(-mean(RiboLabMap.X)),''' CenterY=''',num2str(-mean(RiboLabMap.Y)),''' />','\n']);
fprintf(fid, ['<Complex Name=''',DataSetName,'''>','\n']);
fprintf(fid, ['<RNAMolecule Name=''',DataSetName,'''>','\n']);
fprintf(fid, ['<NucListData StartNucID=''1'' DataType=''NucChar.XPos.YPos''>','\n']);
for i=1:numNucs
    fprintf(fid, [RiboLabMap.Other(i).LabelText,' ',num2str(RiboLabMap.X(i)),...
        ' ',num2str(RiboLabMap.Y(i)),'\n']);
end

fprintf(fid, ['</NucListData>','\n']);
fprintf(fid, ['<Nuc RefIDs=''1-',num2str(numNucs),''' Color=''000000'' FontID=''0'' FontSize=''4'' />','\n']);
fprintf(fid, ['<Nuc RefIDs=''1-',num2str(numNucs),''' IsSchematic=''false'' SchematicColor=''0'' SchematicLineWidth=''1.5'' SchematicBPLineWidth=''1.0'' />','\n']);
fprintf(fid, ['<Nuc RefIDs=''1-',num2str(numNucs),''' SchematicBPGap=''2.0'' SchematicFPGap=''2.0'' SchematicTPGap=''2.0'' />','\n']);
fprintf(fid, ['<Nuc RefIDs=''1-',num2str(numNucs),''' IsNucPath=''false'' NucPathColor=''000000'' NucPathLineWidth=''0.0'' />','\n']);

for j=1:numHelices
    fprintf(fid, ['<BasePairs nucID=''',XRNAstruct(j).nucID,''' length=''',num2str(XRNAstruct(j).length),...
        ''' bpNucID=''',XRNAstruct(j).bpNucID,''' />','\n']);
end

fprintf(fid, ['</RNAMolecule>','\n']);
fprintf(fid, ['</Complex>','\n']);
fprintf(fid, ['</ComplexDocument>','\n']);
fprintf(fid,'\n');
fclose(fid);

end

