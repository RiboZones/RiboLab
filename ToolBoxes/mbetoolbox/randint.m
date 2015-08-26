% /* Function: RandInt() *************************************************
%  *

%  * Purpose:  Generates random integer matrix
%  *
%  * syntax R = randint(min,
% max, m, n, [prior])          
%  * Args:     min   - minimum integer
%  *
% max   - maximum integer
%  *           m, n  - generates (m x n) matrix
%  *
% prior - prior frequencies of the integers [1x(max-min+1)]
%  * version
% 1.0, 19:26, 25-Aug-2004, created by m.tada

% ***********************************************************************/
% This function generate a random integer array.
% Syntax is array = randint(minN, maxN, row, col, frequency_vector)
% example: a = randint(1, 4, 10, 100, [0.1, 0.2, 0.3, 0.4]) will make a 10x100 integer array of 
% interval [1, 4] with a prior distribution of P(1) = 0.1, P(2) = 0.2, P(3) = 0.4, P(4) = 0.4 
% as in your randseq.m. If you do not provide frequency_vector, it uses uniform distribution.
%
% Mitsu
