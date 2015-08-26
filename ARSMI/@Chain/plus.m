function [newChain] = plus(chain1,chain2)
%plus Addition function overloaded for the Chain class
%   Puts two or more chains make together

newChainName=strcat(chain1.Name,'_',chain2.Name);
newChain=Chain(chain1.ID,newChainName);
newChain.addobj(chain1,chain2);
end