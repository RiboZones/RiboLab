function [p] = likeratiotest(deltaL, df)
%LIKERATIOTEST - Likelihood ratio test based on chi-square statistics
%
%deltaL   - difference of Log Likelihood values (>=0)
%df       - degrees of freedom
%                                                
%p -        significance level

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

p=chi2calc(2.0*deltaL,df);


function [p] = chi2calc(x,df)
%CHI2CALC - Returns the probability of a chi-square value
%
%   function with V degrees of freedom at the values in X.
%   The chi-square density function with DF degrees of freedom,
%   is the same as a gamma density function with parameters V/2 and 2.
%
%   The size of P is the common size of X and V. A scalar input   
%   functions as a constant matrix of the same size as the other input.    
%
%   This program calculates the chi-square significance values for given 
%   degrees of freedom and the tail probability (type I error rate) for 
%   given observed chi-square statistic and degree of freedom.
p=1-chi2cdf(x,df);

% find critical value
% critical = chi2inv(1-alpha, df);