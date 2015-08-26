function map_struct= FlattenSplitMap(map_struct)


for i=1:size(map_struct.Y,1)
    switch size(map_struct.Y{i,3},1)
        case 1
%            map_struct=[NewMap(1);map_struct.Y(i,:)];
        case {2,3,4};
           x=map_struct.Y(i,:);
%            disp(x{3})
           x{3}=cellstr(x{3})';
           x{4}=cellstr(x{4})';
%            x{3}={x{3}{:}};
           map_struct.Y(i,:)=x;
    end
end

end