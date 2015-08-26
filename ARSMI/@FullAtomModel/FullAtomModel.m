%% Class Definition: FullAtomModel
% FullAtomModel is basically an object that stores the relevent information
% in a PDB file. PDB files are parsed into structures, not objects. This
% class is to give flexibility to the full atom model.
%%
classdef FullAtomModel < handle
    %FULLATOMMODEL Contains a parsed pdb file
    % Contains just relevant information from the pdb structure
    
    %% Properties section
    % This section defines the properties of the FullAtomModel class
    
    properties (SetAccess = private)
        Name                                                               % The name should be the pdb ID, or custom name of choice
        Model                                                              % This contains the model, structured just like in a pdb structure
        UniqueResSeq
        ChainID
    end
    
    %% Methods section
    % Here the various functions that can operate on a FullAtomModel are
    % defined
    
    methods
        %%
        % *Instantiation function*
        function FAM = FullAtomModel(name)                                 % This creates a new instance of FullAtomModel
            if nargin < 1                                                  % Assign a name if one is specified, otherwise call it un-named
                name='un-named';
            end
            FAM.Name  = name;                                              % The Model property will automatically be set to an empty matrix []
        end
        
        %%
        % *Puts actual information into the model from a pdb structure*
        function PopulateFAM(FAM,pdb)
            if isfield(pdb.Model,'HeterogenAtom')                          % If HeterogenAtoms are found in the pdb structure, include them
                FAM.Model=[pdb.Model.Atom pdb.Model.HeterogenAtom];
            else
                FAM.Model = [pdb.Model.Atom];                                % Otherwise, just include what is in Model. X-ray is assumed, not NMR
            end
            FAM.renumberRes();
        end
        
        %%
        % *Takes a subset of a FullAtomModel*
        function CutFAM(FAM,subset,fam_orig)
            if nargin < 3                                                  % If a second FAM is not supplied, cut the first one
                FAM.Model=FAM.Model(subset);
                if ~isempty(FAM.UniqueResSeq)
                    FAM.UniqueResSeq=FAM.UniqueResSeq(subset);
                end
                if ~isempty(FAM.ChainID)
                    FAM.ChainID=FAM.ChainID(subset);
                end
            else
                FAM.Model=fam_orig.Model(subset);                          % If a second FAM is supplied, copy a subset of it into the first one
                if ~isempty(fam_orig.UniqueResSeq)
                    FAM.UniqueResSeq=fam_orig.UniqueResSeq(subset);
                end
                if ~isempty(fam_orig.ChainID)
                    FAM.ChainID=fam_orig.ChainID(subset);
                end
            end
            
        end
        
        function renumberRes(FAM)
            resnum=cellstr(num2str([FAM.Model.resSeq]'));
            reschain=cellstr([FAM.Model.chainID]');
%             resiCode=cell(length(FAM.Model),1);
%             for i=1:length(FAM.Model)
%                 if isempty(FAM.Model(i).iCode)
%                     resiCode{i}=' ';
%                 else
%                     resiCode{i}=FAM.Model(i).resiCode;
%                 end
%             end
            resiCode={FAM.Model.iCode}';
            FAM.UniqueResSeq=strcat(reschain,'_',resnum,resiCode);
            FAM.ChainID=reschain;
        end
        
    end
end