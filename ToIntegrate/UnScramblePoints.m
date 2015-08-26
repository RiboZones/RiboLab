function [ NewPoints ] = UnScramblePoints( FullSpace ,SegmentEdges )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

numFragments=size(SegmentEdges,1);
Space=FullSpace;
NewPoints=[];
StillNotChosen = true(1,size(FullSpace,2));

for i=1:numFragments
    [ UnScrambled, NotChosen, Space  ] = UnScramble( Space ,SegmentEdges(i,1) , SegmentEdges(i,2) );
    sum(Space(1,:)<inf)
    NewPoints = [NewPoints, FullSpace(:,UnScrambled)];
    StillNotChosen = StillNotChosen & NotChosen;
end


NewPoints = [NewPoints,FullSpace(:,StillNotChosen)];

end

