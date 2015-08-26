function [acc] = accserial(str,prefix)
%ACCSERIAL - Converts 'AY349692-AY349699' to 'AY349692,AY349693,...,AY349699'


if (nargin<1),
	str='AY349692-AY349699';
end
if (nargin<2),
	prefix = i_getprefix(str);
end

% Remove non-numerics
str(str>'9')=[];
acc = abs(sscanf(str,'%d'));

for (k=acc(1):acc(2)-1),
      fprintf('%s%d,',prefix,k);
end
      fprintf('%s%d\n',prefix,acc(2));



function [prefix] = i_getprefix(s)
	id=regexp(s,'[a-zA-Z0][1-9]');
	if (isempty(id)),
	      prefix='';
	else
	      prefix=s(1:id(1));
	end	
