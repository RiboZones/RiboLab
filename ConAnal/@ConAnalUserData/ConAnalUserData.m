classdef ConAnalUserData < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        alignment
        alignment_file
%         alignment_path
        pdb
        pdb2
        pdb_file
        pdb2_file
%         pdb_path
%         pdb2_path
        gene_list
        gene_list_file
%         gene_list_path
        save_file
%         save_file_path
        Output
    end
    
    methods
        function CAUD=ConAnalUserData(Name)
            CAUD.Name=Name;
            CAUD.Output=ConAnalOutput();
        end
    end
    
end

