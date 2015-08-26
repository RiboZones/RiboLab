function exportdismatrix(D,aln,header)
%EXPORTDISTANCEMATRIX - Export distance matrix to file

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if nargin<3
    header = [];
end;

if nargin<2
   nb=length(D);
   for ii = 1:nb
      names{ii} = ['Seq' int2str(ii)];
   end
   aln.seqnames=names;
end


ButtonName=questdlg('Do you want to save distance matrix?', ...
                    'Save as', ...
                    'Text','Excel','Word','Text');
switch ButtonName,
    case 'Text', 
       writematrix(D,aln);
    case 'Excel',
      colnames = aln.seqnames;
      xlswrite(D,header,colnames);
    case 'Word',
      colnames = aln.seqnames;
      table2word(colnames,D);
end