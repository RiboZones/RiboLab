function [ NewMap ] = UnScrambleMap( MapObj ,SegmentEdges )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

numFragments=size(SegmentEdges,1);

FullSpace=[MapObj.X,MapObj.Y]';
Space=FullSpace;
NewPoints=[];
NewOther=[];
OldOther=MapObj.Other;

StillNotChosen = true(1,size(FullSpace,2));

NewMap=Map2D([MapObj.Name,'_UnScrambled']);
NewMap.ItemNames=MapObj.ItemNames;

for i=1:numFragments
    [ UnScrambled, NotChosen, Space  ] = UnScramble( Space ,SegmentEdges(i,1) ,...
        SegmentEdges(i,2) );
    %sum(Space(1,:)<inf)
    NewPoints = [NewPoints, FullSpace(:,UnScrambled)];
    NewOther = [NewOther; OldOther(UnScrambled)];
        
    StillNotChosen = StillNotChosen & NotChosen;
end


NewPoints = [NewPoints,FullSpace(:,StillNotChosen)];
NewOther = [NewOther;OldOther(StillNotChosen)];


NewMap.X=NewPoints(1,:)';
NewMap.Y=NewPoints(2,:)';
NewMap.Other=NewOther;

end

