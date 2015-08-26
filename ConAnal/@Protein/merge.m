function [newProtein] = merge(proteins,keep)
%plus Addition function overloaded for the Protein class
%   Puts two or more Proteins make together

newProtein=Protein([proteins.Name]);
% newProtein.FAM=[proteins.FAM];
% newProtein.NewCenter=cell2mat({proteins.NewCenter}');
% newProtein.Distances=cell2mat({proteins.Distances}');
% newProtein.cSequence=[proteins.cSequence];
variability=[];
shell=[];
for i=1:length(proteins)
    [inAlignment,ind]=ismember(keep(i).PDB,keep(i).Alignment);
    variability=[variability,proteins(i).variability(ind(inAlignment))];
    shell=[shell,proteins(i).shell(keep(i).PDB(inAlignment))];
end
newProtein.variability=variability;
newProtein.shell=shell;

end