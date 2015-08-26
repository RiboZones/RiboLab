function [model] = modelgtr(rmatrix,freq)
%MODELGTR - Returns a structure of model GTR
%
% Syntax: [model] = modelgtr(rmatrix,freq)
%
% Inputs:
%    rmatrix   - Rate matrix parameters, e.g. [1.0 1.33333 1.0 1.0 1.333333 1.0]
%    freq      - Equilibrium frequency parameters, e.g. [.1 .2 .3 .4]
%
% Outputs:
%    model.R      - Rate matrix
%    morel.freq   - Equilibrium frequency parameters, 1x4
%
% NOTE: rmatrix allows the user to set 6 values for the general reversable models 
% rate matrix. This is only valid when either the REV model has been selected.
% where rmatrix are size decimal numbers for the rates of transition from A to C,
% A to G, A to T, C to G, C to T and G to T respectively. The matrix is symmetrical 
% so the reverse transitions equal the ones set (e.g. C to A equals A to C) and 
% therefore only six values need be set. These values will be scaled such that 
% the last value (G to T) is 1.0 and the others are set relative to this.
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (nargin<2),
rmatrix=[1.0 1.33333 1.0 1.0 1.333333];
freq=[.1 .2 .3 .4];
disp('Using example parameters, rmatrix and freq.')
end
freq=i_assertfreq(freq);

model=model_nt('gtr','rmatrix',rmatrix,'freq',freq);