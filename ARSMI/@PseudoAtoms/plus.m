function [newPA] = plus(PA1,PA2)
%plus Addition function overloaded for the PseudoAtoms class
%  

name=strcat(PA1.Name,'_',PA2.Name);
newPA=PseudoAtoms(name);
newPA.addobj(PA1,PA2);
end

