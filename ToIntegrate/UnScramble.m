function [ UnScrambled, NotChosen, Space ] = UnScramble( FullSpace ,StartIndex , EndIndex )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Space = FullSpace;
UnScrambled=[];
%CheckIndex=StartIndex;
UnScrambled(1)=StartIndex;
NotChosen = true(1,size(FullSpace,2));
NotChosen(StartIndex)=false;

CheckPoint=Space(:,StartIndex);
if StartIndex ~= EndIndex
    Space(:,StartIndex)=[inf;inf];
    USindex=2;
else
    USindex=1;
end

CheckIndex=nearestneighbour(CheckPoint,Space);


while CheckIndex ~= EndIndex
    %Save Point
    CheckPoint=Space(:,CheckIndex);
    
    %Mark Point as Found
    NotChosen(CheckIndex)=false;
    UnScrambled(USindex)=CheckIndex;
    
    %Blank Point
    Space(:,CheckIndex)=[inf;inf];
    
    %Find new Point
    CheckIndex=nearestneighbour(CheckPoint,Space);
    USindex=USindex + 1;
end

NotChosen(CheckIndex)=false;
Space(:,CheckIndex)=[inf;inf];
UnScrambled(USindex)=CheckIndex;

end
