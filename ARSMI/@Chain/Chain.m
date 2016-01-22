%% Class Definition: Chain
% The Chain class is the main class that the program operates on. Each
% Chain object contains the data from one chain in the pdb file. The Chain
% class is primarily composed of Residue objects. The CreateChain method
% will group all the atoms into their respective residues. 
%%
classdef Chain < handle
    %CHAIN Separates data into individual chains
    % Most pdb files have more than one chain and processing more than
    % needed wastes resources.
    
    %% Properties section
    % This section defines the properties of the Chain class
    
    properties (SetAccess = private)
        ID                                                                 % The ID should be the same as the pdb name
        Name                                                               % The name of the chain, A,B,0,etc.
        residues                                                           % This is actually a residue object and stores the actual information
        resSeq
        UniqueResSeq
    end
    
  %% Methods section
  %  Here the various functions that can operate on a Chain are defined
    
    methods
        %%
        % *Instantiation function*
        function chain = Chain(ID,NameOfChain)                             % This creates a new instance of Chain
            chain.ID=ID;                                                   % Assign The model ID code
            x=sprintf('%s_',NameOfChain{:});
            chain.Name=x(1:end-1);                                        % Assign the name of the chain inside the model
        end
        
        %%
        % *Groups atoms into their respective residues*
        function chain=CreateChain(chain,FAM,NameOfChains)
            %No longer single character chains. 
%             str_chainIDs=[FAM.Model.chainID];                              % Since Chain names are always one character, this should work
            %indices=strfind(str_chainIDs,NameOfChain);                     % Find the indices of the atoms in the chain of interest    
             %indices=regexp(upper(str_chainIDs),['[',NameOfChain,']']);
            
            %New multicharacter chains. May need optimization
            str_chainIDs=vertcat(FAM.Model.chainID);   
            indices=ismember(str_chainIDs,NameOfChains);                       
           
            fam_subset=FullAtomModel();                                    % Since, Residues operates directly on FullAtomModel, a new object is 
            fam_subset.CutFAM(indices,FAM);                                % needed containing only the chain of choice.
            chain.residues=Residues(strcat(chain.ID,'_',chain.Name));      % Creates a Residues object of name CHAINID_CHAINNAME 
            chain.residues.GroupResidues(fam_subset);                      % Group into residues
            chain.resSeq=[FAM.Model(indices).resSeq];            
            chain.UniqueResSeq=FAM.UniqueResSeq(indices);
        end
    
        %%
        % *Supports the addition of chain objects*
        function addobj(newChain,chain1,chain2)                            % The addition of the names is handled by plus.m
            newChain.residues=chain1.residues + chain2.residues;           % Just need to add the residues together
        end
    end
end
