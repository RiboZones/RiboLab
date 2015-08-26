function NewDomainDef=ReadDomainDefTemplate(file)

%Domains = importdata(file,',');
fid = fopen(file);
Domains = textscan(fid, '%s');
fclose(fid);

a = regexp(Domains{1}(2:end),'(?<Edges>[^,]+),D(?<Name>[^,]+),(?<Number>[^,]+)' , 'names');
DomainsA=[a{:}];

NewDomainDef=repmat(struct('Name',{{}},'Edges',{{}},'mol_ind',1,'Number',{[]}),length(a),1);

for i=1:length(DomainsA)
    NewDomainDef(i).Name = DomainsA(i).Name;
    b=regexp(DomainsA(i).Edges,';','split');
    for j = 1:length(b)
        c = regexp(b(j),'(?<MolName>[^:]+):\((?<edge1>[\w\d]+)\-(?<edge2>[\w\d]+)\)','names');
        NewDomainDef(i).Edges=[NewDomainDef(i).Edges, {[c{1}.MolName,':',c{1}.edge1]},{[c{1}.MolName,':',c{1}.edge2]}];
    end
    NewDomainDef(i).Number = DomainsA(i).Number;
end