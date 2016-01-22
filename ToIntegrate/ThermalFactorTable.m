function [ Thermal_Factor_Table ] = ThermalFactorTable(PDB_obj,ItemNames,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


if nargin > 2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
        end
    end
end

numPDBS=length(PDB_obj);
%Thermal_Factor_Table=cell(numPDBS,1);
Thermal_Factor_Table(:,1)=ItemNames{1}';
Thermal_Factor_Table(:,2)={'\N'};
for i=1:numPDBS
    res_obj(i)=Residues(PDB_obj(i).Name);
    res_obj(i).GroupResidues(PDB_obj(i));
    pa_obj(i)=PseudoAtoms(PDB_obj(i).Name);
    pa_obj(i).CenterOfMass(res_obj(i),'Whole')
    
    resnums=res_obj(i).ResidueNumber;
    reschains=res_obj(i).ResidueChain;
    residue_list=cellstr([char(reschains),char(resnums)]);
    %%residue_list=res_obj(i).ResidueNumber;
    thermal_list=pa_obj(i).tempFactor;
    
    [inMap,I]=ismember(residue_list,regexprep(ItemNames{i},'_',''));
    [~,II]=sort(I(I~=0));
    r=residue_list(inMap);
    t=thermal_list(inMap);
    [~,III]=ismember(r(II),regexprep(ItemNames{i},'_',''));
    Thermal_Factor_Table(III,2)=t(II)';
    %Thermal_Factor_Table(setdiff(1:length(ItemNames{1}),III),2)={'\N'};
end

end
