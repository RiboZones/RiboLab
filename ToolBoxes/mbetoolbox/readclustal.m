function [aln] = readclustal(filename,seqtype,geneticcode)
%READFASTA - Reads data from a FASTA formatted file into a MATLAB structure
%A file with a FASTA format begins with a right angle bracket (>) and a single 
%line description.
%
% Syntax:  [aln] = readclustal('filename',seqtype,geneticcode)
%
% Inputs:
%    filename    - FASTA formatted file (ASCII text file).
%    seqtype     - Type of sequences. 1 - non-coding nucleotide; 2 - coding
%                  nucleotide; 3 - protein
%    geneticcode - Genetic code. 1 - Standard; 2 - Vertebrate Mitochondrial; 
%                  3 - Yeast Mitochondrial; 4 - Mold, Protozoan, Coelenterate 
%                  Mitochondrial, and Mycoplasma/Spiroplasma; 5 - Invertebrate 
%                  Mitochondrial; 6 - Ciliate, Dasycladacean, and Hexamita 
%                  Nuclear; 0 - non-coding
%
% Outputs:
%    aln    - alignment structure
%
% Examples:
%
% >> [aln] = readclustal('input.aln',1,0)   % for non-coding DNA/RNA
% >> [aln] = readclustal('input.aln',2,1)   % for protein-coding DNA
% >> [aln] = readclustal('input.aln',3,1)   % for protein           
%
% See also: READPHYLIP, READFASTA

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 8/23/2006


if nargin < 1
    [filename, pathname] = uigetfile( ...
       {'*.clustal;*.aln', 'CLUSTAL Format Files (*.clustal, *.aln)';
        '*.*',  'All Files (*.*)'}, ...
        'Pick a CLUSTAL file');
	if ~(filename), aln=[]; return; end
	filename=[pathname,filename];

end

if nargin < 3
	[seqtype, geneticcode]=selectSeqTypeAndGeneticCode;
	if (isempty(seqtype)|isempty(geneticcode)), aln=[]; return; end
end
disp(['Reading ',filename]);

txt = textread(filename,'%s','delimiter','\n','whitespace','');

% check header line, confirm that it's a ClustalW file
if ~strncmpi(txt{1},'CLUSTAL',7)
    warning('Header does not match CLUSTAL format')
end

% remove header line  
txt(1) = [];

% remove empty lines
while isempty(txt{1})
    txt(1) = [];
end

% find first empty string in cell array, which occurs after the first
% consensus line
mt = find(cellfun('isempty',txt));

% eliminate empty lines
txt(mt) = [];

% the first consensus line is in mt(1)-1
cons_loc = mt(1)-1;

% there are cons_loc-1 sequences
num_seq = cons_loc-1;

alnstr='';
names={};

for s = 1:num_seq,
    % make the name into a MATLAB-acceptable variable name
    name = cleantext(strtok(txt{s}),{'|','_';'.',''});
    names{s}=name;
    seqstr='';
    xxx='';
    for r = s:cons_loc:size(txt,1),
        idx=find(txt{r}==' ');
        idx=idx(1);
        % make sure that there aren't sequence numbers at the end
        xxx = [xxx strtrim(strtok(txt{r}(idx:end),'0123456789'))];              
    end
    seqstr=strvcat(seqstr,char(xxx));
    alnstr=[alnstr;seqstr];
end


aln=struct;
aln.seqtype = seqtype;
aln.geneticcode = geneticcode;
aln.seqnames = names;
aln.seq=nt2int(alnstr);
%aln.seq=upper(alnstr);
%aln=encodealn(aln);




















function txt = cleantext(txt,subs)
% CLEANTEXT converts string by removing or substituting characters
% C_TEXT = CLEANTEXT(T) replaces any characters which can't be used in
%   MATLAB variable names with an underscore, '_'.  CLEANTEXT also removes
%   all whitespace characters.  It prepends the string with 'var_', if the
%   first character left in the string isn't a letter.
% C_TEXT = CLEANTEXT(T,SUBSTITUTE) will replace the characters in the T
%   with characters specified in SUBSTITUTE.  SUBSTITUTE should be a cell
%   array.  The first element in each row is a string containing
%   the characters to be replaced.  The second element in each row is the
%   character used as the replacement.  If the second element is an empty
%   string, then the original characters are removed.
%
%  Example:
%
%  t = 'invalidname.123<>   ';
%  ct = cleantext(t);
%  ct2 = cleantext(t,{'<>.','_'});

if nargin <2,
    subs = {'~`!@#$%^&*()-=+|\{}[]:;''"<>,./? ','_'};
end


% remove all whitespace characters.
txt(isspace(txt)) = '';

for outer = 1:size(subs,1),
    if numel(subs{outer,2}) > 1,
        error('Each replacement should be a single character.')
    end
    
    for inner = 1:length(subs{outer,1}),
        if isempty(subs{outer,2})
            txt(txt == subs{outer,1}(inner)) = '';
        else
            txt(txt == subs{outer,1}(inner)) = subs{outer,2};        
        end
    end
end


% if the first character isn't a letter, prepend 'var_'
%if ~isletter(txt(1))
%    txt = ['var_' txt];
%end
