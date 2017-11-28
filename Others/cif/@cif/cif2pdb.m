function [pdb] = cif2pdb(cif_obj,pdb_obj)
%cifdat=cif_obj.cifdat;

pdb=[];

%HEADER
%pdb.Header
%Title
%Compound
pdb.Compound = cif_compound(cif_obj);
%Source
pdb.Source = cif_source(cif_obj);
%ExperimentData
%Authors
%RevisionDate: [1x2 struct]
%Journal: [1x1 struct]
%Remark2: [1x1 struct]
%Remark3: [1x1 struct]
%Remark4: [2x59 char]
%Remark100: [3x59 char]
%Remark200: [49x59 char]
%Remark280: [9x59 char]
%Remark290: [48x59 char]
%Remark300: [6x59 char]
%Remark350: [32x59 char]
%Remark375: [8x59 char]
%Remark465: [50x59 char]
%Remark500: [55x59 char]
%Remark620: [11x59 char]
%Remark800: [13x59 char]
%Remark999: [9x59 char]
%DBReferences: [1x3 struct]
%SequenceConflicts: [1x1 struct]
%Sequence: [1x3 struct]
%ModifiedResidues: [1x4 struct]
%Heterogen: [1x7 struct]
%HeterogenName: [1x2 struct]
%Formula: [1x3 struct]
%Helix: [1x6 struct]
%Sheet: [1x15 struct]
%Link: [1x12 struct]
%Site: [1x1 struct]
%Cryst1: [1x1 struct]
%OriginX: [1x3 struct]
%Scale: [1x3 struct]
%Model:
pdb.Model = cif_model(cif_obj);




%Connectivity: [1x46 struct]
%Master: [1x1 struct]
%SearchURL: 'http://www.rcsb.org/pdb/downloadFile.do?fileFormat=pdb&compression=NO&structureId=3iab'

end