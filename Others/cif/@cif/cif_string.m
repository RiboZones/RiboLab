function [ cifStr ] = cif_string(~, path )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% imports .cif file

fid = fopen(path);

% loop = false;
% loopvar = {};


idx = 1;
cifStr = {};

if fid < 0
    error('cif:importcif:FileNotFound','.cif file cannot be found!');
end
% read in all lines
while ~feof(fid)
    cifStr{idx} = fgetl(fid); %#ok<AGROW>
    idx = idx + 1;
end
fclose(fid);
end

