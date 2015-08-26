function    [ Mutation_Entropy, Shannon_Entropy, F ] = Entropy(CADS_object,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


for Pro_ind=1:length(CADS_object)
    
[ Mutation_Entropy, Shannon_Entropy, F, classes ] = Seq_entropy(CADS_object(Pro_ind).Alignment,...
    'classes',CADS_object(Pro_ind).Settings.Alignment.Classes,varargin{:});
CADS_object(Pro_ind).Settings.Alignment.Classes=classes;
end

