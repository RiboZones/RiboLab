%% Automatic RNA Structure Motif Identification (ARSMI)
%       This is the main function of the ARSMI program. It will parse one 
% PDB file, convert its information into various classes, and output
% results according to the desired method.
% Describe input arguments here.
%%
function [ResultsVar Model]=ARSMI(fileID,Method,Pattern,SelectedChains,FAM)
%% Input processing block
%       The user may indicate their pdb file by one of three ways. They may
% state just the PDB ID code, in which case the PDB file would need
% to be downloaded. They may enter just a file name, in which case
% MATLAB will look in their current directory for the pdb file.
% Alternatively, they could pass an entire path to the PDB file, in
% which case a new copy would be desired in the working directory.
% This code will determine the PDB ID code and the local filename,
% without a path. It then will load the PDB file from disk or the
% internet. This code also allows for supplying an optional pre-made
% FullAtomModel object.


%%
%  1. Determine if using internet or local mode
 
if length(fileID) == 4                                                     % A fileID can only be a valid PDB ID if and only if it is exactly 4 characters
    internet=true;                                                         
else
    internet=false;                                                        % The minimum file name length would be 5, *.pdb
end

%%
%  2. Determine ID and file name

if internet                                                                % In internet mode, fileID is the same as PDB ID
    ID=fileID;
    file=strcat(ID,'.pdb');                                                % A .pdb extension is needed
else
    backslash=findstr('\',fileID);                                         % Determine if a path or just a file name was given
    if backslash
        ID=fileID(backslash(end)+1:end-4);                                 % If a path was given the ID would be the information after the last backslash,
        file=fileID;                                                       %    not counting the .pdb at the end
        copyfile(file,'./');                                               % Copy the pdb file to the working directory for convenience
    else
        ID=fileID(1:end-4);                                                % If no backslashes were found, the ID would just be the file name without the .pdb
        file=fileID;
    end
end

%%
%  3. Import PDB file
if exist('FAM','var') && strcmp(class(FAM),'FullAtomModel')                % If a valid FullAtomModel has been supplied, a pdb file is not needed
    pdb='none supplied';
else
    if internet
        pdb = getpdb(ID, 'ToFile', file);                                  % Get the pdb entry from the database through the internet
    else
        pdb=importdata(file);                                              % Import a pdb file from disk
    end
end

%% Make FullAtomModel object
%       This block creates a FullAtomModel object if one was not supplied. 
% It then determines which chains to process. Finally, it pre-generates the
% dynamic names of each chain, pseudo atom, and result file.

%%
%  1. Make the FullAtomModel object if none is supplied
if ~exist('FAM','var') || ~strcmp(class(FAM),'FullAtomModel')              % If a valid FullAtomModel was not supplied, create it
    FAM=FullAtomModel(ID);                                                 % Instantiate
    FAM.PopulateFAM(pdb);                                                  % Populate the model with data from the pdb sructure
end

%%
%  2. Determine which chains to process and how many there are
if exist('SelectedChains','var') && iscellstr(SelectedChains)              % If a list of strings is supplied, use it 
    NameOfChains=SelectedChains;
else
    NameOfChains=unique({FAM.Model.chainID});                              % Otherwise, do all chains
end
num_chains=length(NameOfChains);                                           % Find the number of chains

%%
%  3. Determine field names for chains, pseudo atoms models, and results
ChainName=cell(1,num_chains);                                              % Pre-allocate these variables for speed
PseudoAtomName=cell(1,num_chains);
ResultsName=cell(1,num_chains);

for index=1:num_chains                                                     % Pre-determine the name of all chains, pseudo atoms model, and results
    ChainName{index}=strcat('Chain','_',NameOfChains{index});
    PseudoAtomName{index}=strcat('PseudoAtom_Chain_',NameOfChains{index});
    ResultsName{index}=strcat('Results_Chain_',NameOfChains{index});
end

%% Main block
%       This is the main program block. First, it generates chain objects,
% next it generates psudo atom objects, and finally it computes the
% results.

for index=1:num_chains                                                     % Start the main block loop
    %% 
    %  1. Make the chain object
    chain.(ChainName{index})=Chain(ID,NameOfChains{index});                % Instantiate
    chain.(ChainName{index}).CreateChain(FAM,NameOfChains{index});         % Build the chain
    
    %%
    %  2. Make the pseudo atom object
    pa.(PseudoAtomName{index})=PseudoAtoms(strcat(ID,'_',...               % Instantiate
        ChainName{index}));
    pa.(PseudoAtomName{index}).CenterOfMass(chain.(ChainName{index}...     % Find the center of masses
        ).residues,Method.CenterOfMass);
    pa.(PseudoAtomName{index}).DistanceBetweenPA();                        % Compute the inter-atomic distances
    
    %%
    %  3. Find results based on search method.
    results.(ResultsName{index})=Results(pa.(PseudoAtomName{index}).Name); % Instantiate
    switch Method.Search{1}
        case {'Triangle','Linear'} 
            cutoff=Method.Search{2};
            results.(ResultsName{index}).FindNearby(...                    $ Find nearby residues
                pa.(PseudoAtomName{index}),Pattern,...
                chain.(ChainName{index}).residues.ListOfResidues,cutoff);
            if length(Pattern{1}) > 1
                results.(ResultsName{index}).Triangle...                   % Restrict results using the Triangle method
                    (pa.(PseudoAtomName{index}),cutoff);
            else
                results.(ResultsName{index}).Linear...                   % Removes symmetrical results
                    (pa.(PseudoAtomName{index}));
            end
        otherwise
            warning('No valid Search Method specified. Results are blank.')
    end
    results.(ResultsName{index}).WriteToFile(ID,index-1);                  % Write the results to a PyMOL script
end
%% Output processing block
% This block just assigns variables to a Model structure, and renames the
% results. 

Model.PDB=pdb;
Model.FAM=FAM;
Model.Chains=chain;
Model.Pseudo_Atoms=pa;
ResultsVar=results;
%testgit
