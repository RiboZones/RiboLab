function  prop = aaTrifonov(aa) 
%AATRIFONOV - 
if nargin == 0, 
	prop = 'AAProp_ TrifonovConsensus';
	return
end

if numel(aa) == 1, 
	ndx = double(lower(aa)) - 96;
	data = [2; ...% A : Alanine 
		NaN;... % B : Aspartic Acid or Asparagine 
		15;... % C : Cysteine 
		4;... % D : Asparatic Acid 
		6;... % E : Glutamic Acid 
		16;... % F : Phenylalanine 
		1;... % G : Glycine 
		17;... % H : Histidine 
		12;... % I : Isoleucine 
		NaN;... % J : unused 
		13;... % K : Lysine 
		8;... % L : Leucine 
		18;... % M : Methionine 
		10;... % N : Asparagine  
		NaN;... % O : unused 
		7;... % P : Proline 
		14;... % Q : Glutamine 
		11;... % R : Arginine 
		5;... % S : Serine 
		9;... % T : Threonine 
		NaN;... % U : unused 
		3;... % V : Valine 
		20;... % W : Tryptophan 
		NaN;... % X : unused 
		19;... % Y : tyrosine 
		NaN]; % Z : Glutamic Acid or Glutamine 

    try
        prop = data(ndx);
    catch
        prop = NaN;
    end

else
   prop = zeros(numel(aa),1);
    for n = 1:numel(aa),
        prop(n) = aaTrifonov(aa(n));
    end
end
