function [lnL] = gammalike(alpha,ncate,s,tr,md)
%GAMMALIKE Negative gamma log-likelihood function.
%((((Langur:0.081,Baboon:0.033):0.021,Human:0.064):0.01,Rat:0.288),(Cow:0.240,Horse:0.63):0.106);


gd=gammadistrib(ncate,alpha);
fprintf('alpha=%2.4f, ncate=%d (default=16)\n',alpha,ncate)

[n,m]=size(s);
ratev=zeros(1,m);
[patt, npatt, scate] = sitepattern(s);
nop=length(npatt);

lnLpatt=zeros(1,nop);
grate=1;

for (k=1:nop),
    fprintf (['calculating lnL for pattern %d ...\n'], k)
    lnLpatt(1,k)=i_lnLbestrate(patt(:,k),tr,md,gd,grate);
end

lnLv=lnLpatt(scate);
lnL=sum(lnLv);


function [maxlnL]=i_lnLbestrate(s,tr,md,gd,grate)

%er - Expected r
ri=gd.rate;
pri=gd.prob;    % P(r_i) is the prior distribution on the rate = 1/ncate
ncate=length(ri);
rcate=zeros(1,ncate);

for (k=1:ncate),
    rcate(1,k) = siteratelike(s,tr,md,grate*ri(k)*pri(k));
end
maxlnL=sum(rcate);
