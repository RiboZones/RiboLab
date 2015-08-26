function [tree] = mbe_neighbor(aln,outgrno)

if (nargin<2), outgrno=1; end
if (isstruct(aln)), seq=aln.seq; else seq=aln; end
[n,m]=size(seq);
if (outgrno>m), error('NOUTGROUP should smaller than M.'); end


cmd = 'mbe_neighbor.m';
dirstr = fileparts(which(cmd));
cd(dirstr);
if (ispc), sep='\'; else sep='/'; end
infile = [dirstr,sep,'infile'];

[D]=chooseDistance(aln);
i_writematrix(D,aln,infile,' ');


if (neighbor(outgrno)~=0),
      tree=[];
else
      tree=i_readouttree;
end



function [answer] = i_readouttree
	fid = fopen('outtree', 'r');
	answer = fscanf(fid, '%s');    % It has two rows now.
	fclose(fid);
	x=find(answer==';');
	if ~(isempty(x))
		answer=answer(1:x(1));
	end


function i_writematrix(D,aln,filename,delimiter)
%WRITEMATRIX - Writes data in tabular form to the file system.
%It writes a space delimited file with variable names in the first row, case 
%names in the first column and data in columns under each variable name.
%
% Syntax:  writematrix(D,aln,filename,delimiter)
%
% Inputs:
%    D           - Data 
%    aln         - Alignment structure
%    filename    - Complete path to the desired file
%    delimiter   - (optional) It can be any of the following: ' ', '\t', ',', 
%                  ';', '|' or their corresponding string names 'space', 
%                  'tab', 'comma', 'semi', 'bar'. If it is not given, the 
%                  default is set to be ' ' (space).
%
% See also:

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

% Modified from:
% B.A. Jones 10-4-94
% Copyright 1993-2002 The MathWorks, Inc.
% $Revision: 2.15 $  $Date: 2002/01/17 21:32:03 $

data=D;
varnames=char(aln.seqnames);
casenames=varnames;

if nargin < 4
   delimiter = '   ';
else
   switch delimiter
   case {'tab', '\t'}
      delimiter = sprintf('\t');
   case 'space'
      delimiter = ' ';
   case 'comma'
      delimiter = ',';
   case 'semi'
      delimiter = ';';
   case 'bar'
      delimiter = '|';
   otherwise
      delimiter = delimiter(1);
   end
end

ld = length(delimiter);
if nargin<3, casenames = ''; end
lc = size(casenames,2);

eval('isempty(filename);','filename=[];');
if nargin < 4 | isempty(filename)

    [F,P,I] = uiputfile( ...
       {'*.txt', 'Text (Tab delimited) (*.txt)';
        '*.csv', 'CSV (Comma delimited) (*.csv)';
        '*.*',  'All Files (*.*)'});
	if ~(F), return; end

	if (I==1)
		if (isempty(find(F=='.'))),
		F=[F,'.txt'];
		end
		delimiter = sprintf('\t');
	elseif (I==2)
		if (isempty(find(F=='.'))),
		F=[F,'.csv'];
		end
		delimiter = sprintf(',');
	end

   % [F,P]=uiputfile('*');
   filename = [P,F];
end

[nobs, nvars] = size(data);

if ~ischar(casenames) & ~isempty(casenames)
   error('CASENAMES must be a character array.');
end
if ~ischar(varnames) & ~isempty(varnames)
   error('VARNAMES must be a character array.');
end

[ncasenames, maxl] = size(casenames);

for i = 1:ncasenames
   j = maxl;
   while (casenames(i,j) == ' ')
      j = j-1;
      if j == 0, break, end
   end
   if (j > 0)
      a = findstr(casenames(i,1:j), ' ');
      casenames(i,a) = '_';
   end
end

[nvarnames, maxl] = size(varnames);

for i = 1:nvarnames
   j = maxl;
   while (varnames(i,j) == ' ')
      j = j-1;
      if j == 0, break, end
   end
   if (j > 0)
      a = findstr(varnames(i,1:j), ' ');
      varnames(i,a) = '_';
   end
end

lv = maxl;

if nvars ~= nvarnames
   error('Requires the number of variable names to equal the number of data columns.');
end

if isempty(casenames)
   digits = floor(log10(nobs))+1;
   caseformat = ['%',int2str(digits),'d'];
   casenames = (reshape(sprintf(caseformat,(1:nobs)),digits,nobs))';
elseif ncasenames~=nobs
   error('The number of case names must equal the number of data rows.');
end

marker1 = delimiter(ones(nvars,1),:);

varnames = [marker1 varnames]';
varnames = varnames(:)';
marker1 = setstr(32);
marker1 = marker1(ones(1,lc));
varnames = [marker1 varnames];

if strcmp(computer,'MAC2')
   lf = setstr(13);
else
   lf = setstr(10);
end

varnames = [varnames(:)' lf];

for rows = 1:nobs
   sr = [casenames(rows,:) delimiter];
   for cols = 1:nvars
      %s = num2str(data(rows,cols));
      s=sprintf('%2.6f',data(rows,cols));
      sr = [sr s];
      if cols ~= nvars
         ps = max(1,lc+cols*(ld+lv)+ld-length(sr));
         if isequal(delimiter,'   ')
            sr = [sr delimiter(ones(1,ps))];
         else
            sr = [sr delimiter];
         end
      end
   end
   if rows == 1
      maxl = length(sr);
      l = length(sr);
      lines = sr;
   else
      blank = ' ';
      l = length(sr);
       deltal = l - maxl;
      if deltal > 0
           lines = [lines blank(ones(rows-1,1),ones(deltal,1))];
        maxl = l;
      elseif deltal < 0
         sr = [sr blank(1,ones(-deltal,1))];
      end
      lines = [lines;sr];
   end
end
lines = [lines lf(ones(nobs,1),1)];

fid = fopen(filename,'wt');

if fid == -1
   disp('Unable to open file.');
   return
end

fprintf(fid,'  %d\n',nobs);
fprintf(fid,'%s',lines');
fclose(fid);





% ======================================================
% ======================================================
% ======================================================
% ======================================================
% ======================================================
% ======================================================







