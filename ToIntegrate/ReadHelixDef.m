function NewHelicDef=ReadHelixDef(file)

test = fileread(file);

a = regexp(test, '([\w]+):([\w]+)-([\w]+),?([\w]+)?-?([\w]+)?[\s]+', 'tokens');

NewHelicDef=repmat(struct('Name',{{}},'Edges',{{}}),length(a),1);

for i=1:length(a)
    NewHelicDef(i).Name = a{i}{1};
    for j=1:4
        if ~isempty(a{i}{j+1})
            NewHelicDef(i).Edges{j} = a{i}{j+1};
        end
    end
    
end






