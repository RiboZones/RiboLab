function NewHelicDef=ReadHelixDefTemplate(file)

%Helices = importdata(file);
fid=fopen(file,'r','n','UTF-8');
txt=fscanf(fid,'%c');
Helices=textscan(txt,'%[^\n\r]','delimiter','\n');
fclose(fid);

a = regexp(Helices{1}(2:end),'(?<Edges>[^,]+),(?<Name>[Hh].*)' , 'names');
HelicesA=[a{:}];

NewHelicDef=repmat(struct('Name',{{}},'Edges',{{}},'mol_ind',1),length(a),1);

for i=1:length(HelicesA)
    NewHelicDef(i).Name = HelicesA(i).Name;
    b=regexp(HelicesA(i).Edges,';','split');
    for j = 1:length(b)
        c = regexp(b(j),'(?<MolName>[^:]+):\((?<edge1>[\w\d]+)\-(?<edge2>[\w\d]+)\)','names');
        NewHelicDef(i).Edges=[NewHelicDef(i).Edges, {[c{1}.MolName,':',c{1}.edge1]},{[c{1}.MolName,':',c{1}.edge2]}];
    end
end