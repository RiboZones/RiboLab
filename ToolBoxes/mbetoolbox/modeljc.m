function [model] = modeljc()
%MODELJC - Returns a structure of model JC
%\paragraph{The JC model}
%The JC model was described by Jukes \& Cantor (1969) and is the most 
%restrictive of the four models offered by MBEToolbox.  It assumes that the 
%base frequencies are all equal and the instantaneous rate of substitution is 
%the same for all possible changes. When this model is selected, the base 
%frequencies are all set to 0.25 and kappa is set to 1.0. The only free 
%parameter that can be adjusted under this model is the $\mu t$ parameter.
%
%Transition-transversion ratio:
%$$R=0.5$$
%
%Evolutionary distance:
%$$d=\frac{3}{4}\mu t$$
%
% Syntax: [model] = modeljc
%
% Inputs:
%    none
%
% Outputs:
%    model.R      - Instantaneous rate matrix
%    model.freq   - Equilibrium frequency parameters, 1x4
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

[model] = model_nt('jc');