function [model] = modelf81(freq)
%MODELF81 - Returns a structure of F81 model
%\paragraph{The F81 model}
%The F81 model was described by Felsenstein (1981). It is like the JC model in 
%assuming that all possible changes occur at the same rate, but allows the base 
%frequencies to be unequal. If the base frequencies are all set to 0.25 manually, 
%this model is equivalent to the JC model. When this model is selected, you 
%will be free to vary the bt and the base frequency parameters, but the $\kappa$ 
%parameter will be inactivated. $\kappa$ is set to 1.0 under this model.
%
%Transition-transversion ratio:
%$$R=\frac{\pi_A \pi_G + \pi_C \pi_T}{\pi_R \pi_Y}$$	
%
%Evolutionary distance:
%$$d=(1-\pi_A^2-\pi_C^2-\pi_G^2-\pi_T^2)\mu t$$
%
%
% Syntax: [Q,F,R] = modelf81(freq)
%
% Inputs:
%    freq - Equilibrium frequency parameters, e.g. [.1 .2 .3 .4]
%
% Outputs:
%    model.R   - Rate matrix
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (nargin<1)
	error('freq must be provide')
end
i_assertfreq(freq);
model=model_nt('f81','freq',freq);
