function [Res] = plus(res1,res2,varargin)
%plus overloaded for residues
% Recursive version!
if nargin < 2
    Res=res1;
    return;
end
name=strcat(res1.Name,'_',res2.Name);
Res=Residues(name);
Res.addobj(res1,res2);

if nargin > 2
    if ~isempty(varargin)
        Res=plus(Res,varargin{1},varargin{2:end});
    end
end

end