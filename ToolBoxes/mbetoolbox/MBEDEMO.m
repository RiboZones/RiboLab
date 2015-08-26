%% MBEToolbox DEMO
%
% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/3/2006

clc;
disp(' ')
disp(' ')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%                            %%')
disp('%% Welcome to MBEToolbox DEMO %%')
disp('%%                            %%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp(' ')
disp('(1) DEMO 1 - Alignment file IO')
disp('(2) DEMO 2 - Basic sequence statistics')
disp('(3) DEMO 3 - Genetic distances estimation')
disp('(4) DEMO 4 - Phylogenetic inferences')
disp('(5) DEMO 5 - New features in version 2')
disp('(6) EXIT')
disp(' ')
pickI = input('Please select: ');

switch (pickI)
    case (1)
         playshow mbe_demo1;
    case (2)
         playshow mbe_demo2;
    case (3)
         playshow mbe_demo3;
    case (4)
         playshow mbe_demo4;
    case (5)
         playshow mbe_demo5;
end