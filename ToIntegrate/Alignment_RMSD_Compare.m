function [ RMSD_Struct ] = Alignment_RMSD_Compare( RV_Lab_Struct1, RV_Lab_Struct2, OriginalAlignment, SecondAlignment )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Update alignments with original alignment. This shouldn't be nesacary, but
%do it just in case these don't actually match or in case the alignment
%file itself has changed. 
UpdateAlignments(RV_Lab_Struct1,OriginalAlignment);
UpdateAlignments(RV_Lab_Struct2,OriginalAlignment);

% Comupte Alignment RMSD for original alignment
RMSD_Orig=Alignment_RMSD(RV_Lab_Struct1,RV_Lab_Struct2);

% Update alignment with second alignment
UpdateAlignments(RV_Lab_Struct1,SecondAlignment);
UpdateAlignments(RV_Lab_Struct2,SecondAlignment);

% Comupte Alignment RMSD for second alignment
RMSD_Second=Alignment_RMSD(RV_Lab_Struct1,RV_Lab_Struct2);

% Return to original alignment in case this is persistent due to objects
% being handles
UpdateAlignments(RV_Lab_Struct1,OriginalAlignment);
UpdateAlignments(RV_Lab_Struct2,OriginalAlignment);

% Plot results
hold on;plot(RMSD_Orig.x,RMSD_Orig.RMSD,'g');plot(RMSD_Second.x,RMSD_Second.RMSD,'k-');hold off;

RMSD_Struct=[RMSD_Orig,RMSD_Second];
end

