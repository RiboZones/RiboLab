function NewHelicDef=ReadHelixDef2(file)

test = fileread(file);

a = regexp(test, '([\w]+);(\w):\(([\w]+)-([\w]+)\),?([\w])?:?\(?([\w]+)?-?([\w]+)?\)?[\s]+', 'tokens');

NewHelicDef=repmat(struct('Name',{{}},'Edges',{{}},'mol_ind',1),length(a),1);

for i=1:length(a)
    NewHelicDef(i).Name = a{i}{1};
    for j=[3,4]
        if ~isempty(a{i}{j})
            NewHelicDef(i).Edges=[NewHelicDef(i).Edges, strcat(a{i}{2},'_',a{i}{j})];
        end
    end
    for j=[6,7]
        if ~isempty(a{i}{j})
            NewHelicDef(i).Edges=[NewHelicDef(i).Edges, strcat(a{i}{5},'_',a{i}{j})];
        end
    end
end

