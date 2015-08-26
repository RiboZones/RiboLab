function [ResNames,Angles] = ExtractBackboneTorsions(file,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sele_angles=false(1,7);

if nargin >1
    for ind=1:length(varargin)
        switch lower(varargin{ind})
            case 'alpha'
                sele_angles(1)=true;
            case 'beta'
                sele_angles(2)=true;
            case 'gamma'
                sele_angles(3)=true;
            case 'delta'
                sele_angles(4)=true;
            case 'epsilon'
                sele_angles(5)=true;
            case 'zeta'
                sele_angles(6)=true;
            case 'chi'
                sele_angles(7)=true;
        end
    end
else
    sele_angles(1)=true;
end

fid=fopen(file);
C=textscan(fid,'%s%s%s%s%f%f%f%f%f%f%f','Delimiter',',','HeaderLines',1);
fclose(fid);

chain=C{2};
res=C{3};
ResNames=strcat(cellstr([chain{:}]'),'_',res);
Angles=cell2mat(C(find(sele_angles)+4));
Angles(Angles<0)=Angles(Angles<0)+360;
% hist(Angles)
end
