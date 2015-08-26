function [t,kappa,lnL]=optimlikelidistk2p(s1,s2,flag)
%OPTIMLIKELIDISTK2P - Optimises distance and kappa under a K2P model
%
% Syntax: [t,kappa,lnL]=optimlikelidistk2p(s1,s2,flag)
%
% Inputs:
%    sl     - Sequence 1
%    s2     - Sequence 2
%    flag   - Plot surface
%
% Outputs:
%    t       - Optimised distance
%    kappa   - Optimised kappa
%    lnL     - Maximum log-likelihood
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

%[lnL,X,Y,Z] = optimlikelidistk2p(s1,s2,ax,bx,k1,k2)
%optimlikelidist

if (nargin<3), flag=0; end

estKappa = estimatekappa([s1;s2],'k2p');
options = optimset('fminsearch');
[xy,f_opt]=fminsearch(@i_likelidistk2p2,[0.5,estKappa],options,s1,s2);
t=xy(1);
kappa=xy(2); 
lnL=-f_opt;



if (flag)
	ax=0; bx=t+0.5;
	k1=0; k2=kappa+2;

	step1=(bx-ax)./50;
	T=ax:step1:bx;

	step2=(k2-k1)./50;
	KAPPA=k1:step2:k2;


	Z=zeros(length(T),length(KAPPA));
	for (i=1:length(T)),
	for (j=1:length(KAPPA)),
		Z(i,j) = i_likelidistk2p2([T(i),KAPPA(j)],s1,s2);
	end
	end
	X=T;
	Y=KAPPA;
	mesh(T,KAPPA,Z)      
	colormap(hsv)
	xlabel('Distance (substitutions/site)')
	ylabel('kappa')
	zlabel('ln(Likelihood)')
	hold;
	%lnL=i_likelidistk2p(0.2329,1.8674,s1,s2);
	%plot3(0.2329, 1.8674, lnL, 'r*')
	plot3(t,kappa,lnL,'r*')

	lnL2=i_likelidistk2p(t,kappa,s1,s2);
	plot3(t,kappa,lnL2,'g*')
end



%~*~*~*~*~*~*~*~*~*
%  SUBFUNCTIONS   *
%~*~*~*~*~*~*~*~*~*

function [lnL] = i_likelidistk2p(t,kappa,s1,s2)
     [model] = modelk2p(kappa);
     [lnL] = likelidist(t,model,s1,s2);


function [lnL] = i_likelidistk2p2(x,s1,s2)     
     t=x(1); kappa=x(2);
     if (t<=0|kappa<=0)
	lnL=inf; return;
     end
     [model] = modelk2p(kappa);
     [lnL] = -1*likelidist(t,model,s1,s2);


% [xy,f]=fminsearch('fBMEN289_9',[2.5,1])
% [xy,f_opt]=fminsearch(@fBMEN289_9,[2.5,1])
% [xy,f]=fminsearch(inline('-(2*x(1)*x(2)+2*x(1)-x(1)^2-2*x(2)^2)'),[5,1])
%
%function f=fBMEN289_9(x)
%f=-(2*x(1)*x(2)+2*x(1)-x(1)^2-2*x(2)^2);
%format long


function [kappa] = i_estimatekappa(S)
	[p,q]=countseqpq(S);
	[n,m] = size(S);

	p=p./m; q=q./m;
	w1 = 1-2*p-q;
	w2 = 1-2*q;
	r=(-log(w1)./-log(w2))-0.5;
	kappa=r*2;

	%NOTE:
	% > I find that results from fminsearch are: 1)highly dependent on
	% > initial position in parameter space and 2)not always terminated at
	% > the global minimum (known from a grid search). I have played around
	% > with the tolerances to no avail.
	% > 
	% > Have others had similar experiences with fminsearch? Any suggestions?
	% 
	% This is what makes global minimization hard to solve.
	% 
	% Imagine you are walking a terrain yourself and you follow
	% the terrain down to a deep valley. How do you know you
	% didn't miss a deeper valley on the other side of that
	% ridge 20 km west? Now make the problem exponentially worse
	% by going to n search dimensions instead of 2.
	% 
	% One strategy to improve your *chances* of finding the
	% global optimum is to introduce some carefully designed
	% element of randomness into the search, so that with
	% some probability you will in fact go past that
	% ridge. Simulated annealing and genetic algorithms are
	% two such strategies.