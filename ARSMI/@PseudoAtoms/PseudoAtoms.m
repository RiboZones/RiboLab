%% DOCUMENT TITLE
% INTRODUCTORY TEXT
%%
classdef PseudoAtoms < handle
    %PseudoAtoms reduces model to pseudoatoms
    %   uses center of mass
    
    properties (SetAccess = private)
        Name
        NamesOfPseudoAtoms
        Position
        Distances
        tempFactor
    end
    %% SECTION TITLE
    % DESCRIPTIVE TEXT
    
    methods
        function PA = PseudoAtoms(Name)
            PA.Name=Name;
        end
        
        function CenterOfMass(PA,residues,method)
            if nargin < 3
                method='Whole';
            end
            num_Residues=length(residues.Position);
            R=cell(1,num_Residues);
%             Names_PseudoAtoms=cell(1,num_Residues);
            
                        ANS=residues.Atoms;

            % Delete atoms not wanted in mass calculations
            for index=1:num_Residues
                switch method
                    case 'Base only'
                        Keep= isBase(ANS(index,:)) | isMagnesium(ANS(index,:));
                    case 'Nucleoside'
                        Keep= isBase(ANS(index,:)) | isSugar(ANS(index,:));
%                     case 'Side chain'
%                         Keep= ~isBackbone(ANS(index,:));
                    case 'Whole'
                        Keep= isAnything(ANS(index,:));
                    case 'Sugar'
                        Keep= isSugar(ANS(index,:));
                    case 'Phosphate'
                        Keep= isPhosphate(ANS(index,:));
                    case 'Magnesium'
                        Keep= isMagnesium(ANS(index,:));
                    case 'isN1orN9'
                        Keep= isPhosphate(ANS(index,:)) | isSugar(ANS(index,:)) | isN1orN9(ANS(index,:));
                    otherwise
                        error('No valid Center of Mass Method specified.')
                end
               
                r=residues.Position{index}(Keep,:);
                elements={ANS(index,:).chemSymbol};
                elements=elements(Keep);
                
                % Calculate the mass of each remaining atom
                mass=AtomicMass(elements);
                
                % Determine the center of mass
                R{index}=sum(mass .* r,1) ./ sum(mass,1);
                
                %
                %Names_PseudoAtoms{index}=residues.NamesOfResidues{index};
                
                % Determine average tempFactor
                PA.tempFactor{index}=mean(residues.tempFactor{index}(Keep,:));
            end
            % Output block
            
            if ~isempty(residues.ResidueName)
                PA.NamesOfPseudoAtoms=residues.ResidueName;
%             elseif ~isempty(residues.ResidueName)
%                 PA.NamesOfPseudoAtoms=residues.ResidueName;
            end
            PA.Position=R;
        end
        
        %
        function DistanceBetweenPA(PA)
            R=reshape(cell2mat(PA.Position),3,[])';
            num_Res=length(PA.Position);
            x=repmat(R(:,1),[1 num_Res]);
            y=repmat(R(:,2),[1 num_Res]);
            z=repmat(R(:,3),[1 num_Res]);
            deltax=x-x';
            deltay=y-y';
            deltaz=z-z';
            PA.Distances=sqrt(deltax.^2+deltay.^2+deltaz.^2);
        end
        % Supports the addition of PseudoAtoms objects
        function addobj(PA,PA1,PA2)
            PA.NamesOfPseudoAtoms=[PA1.NamesOfPseudoAtoms ...
                PA2.NamesOfPseudoAtoms];
            PA.Position=[PA1.Position PA2.Position];
            PA.DistanceBetweenPA();
        end
    end
end

%
function mass=AtomicMass(Names_Atoms)
num_atomres=length(Names_Atoms);
mass=zeros(num_atomres,3);
for j=1:num_atomres
    switch Names_Atoms{j}
        case 'H'
            mass(j,:)=1*ones(1,3);
        case 'C'
            mass(j,:)=12*ones(1,3);
        case 'N'
            mass(j,:)=14*ones(1,3);
        case 'O'
            mass(j,:)=16*ones(1,3);
        case 'P'
            mass(j,:)=31*ones(1,3);
        case 'S'
            mass(j,:)=32*ones(1,3);
        case 'SE'
            mass(j,:)=79*ones(1,3);
        case 'MG'
            mass(j,:)=24.3*ones(1,3);
        case 'K'
            mass(j,:)=39.1*ones(1,3);
        case 'NA'
            mass(j,:)=23.0*ones(1,3);
        case 'FE'
            mass(j,:)=55.8*ones(1,3);
        case 'ZN'
            mass(j,:)=65.4*ones(1,3);
        case 'OS'
            mass(j,:)=190.23*ones(1,3);
        case 'CL'
            mass(j,:)=35.45*ones(1,3);
        case 'CD'
            mass(j,:)=112.41*ones(1,3);
        otherwise
            warning('unknown atoms found')
            mass(j,:)=zeros(1,3);
    end
end
end

function I=isAnything(Atoms)
realatoms=0;
cs={Atoms.chemSymbol};
for i=1:length(Atoms)
    if ~isempty(cs{i})
        realatoms=realatoms+1;
    end
end
I= true(1,length(Atoms(1:realatoms)));
end
function I=isBase(Atoms)
realatoms=0;
cs={Atoms.chemSymbol};
for i=1:length(Atoms)
    if ~isempty(cs{i})
        realatoms=realatoms+1;
    end
end
I=  ismember({Atoms(1:realatoms).chemSymbol},{'N','C','O'}) & ismember({Atoms(1:realatoms).remoteInd},...
    {'1','2','3','4','5','6','7','8','9'}) & strcmp({Atoms(1:realatoms).branch},'');
end

function I=isN1orN9(Atoms)
realatoms=0;
cs={Atoms.chemSymbol};
for i=1:length(Atoms)
    if ~isempty(cs{i})
        realatoms=realatoms+1;
    end
end
A=strcat({Atoms(1:realatoms).chemSymbol},{Atoms(1:realatoms).remoteInd});
if ismember('N9',A)
    I=ismember(A,'N9');
else
    I=ismember(A,'N1');
end
end

function I=isPhosphate(Atoms)
realatoms=0;
cs={Atoms.chemSymbol};
for i=1:length(Atoms)
    if ~isempty(cs{i})
        realatoms=realatoms+1;
    end
end
I=ismember({Atoms(1:realatoms).remoteInd},{'P'}) | ismember({Atoms(1:realatoms).branch},{'P'}) | ...
    (ismember({Atoms(1:realatoms).chemSymbol},{'P'}) & ismember({Atoms(1:realatoms).remoteInd},{''}));
end

function I=isSugar(Atoms)
realatoms=0;
cs={Atoms.chemSymbol};
for i=1:length(Atoms)
    if ~isempty(cs{i})
        realatoms=realatoms+1;
    end
end
I=ismember({Atoms(1:realatoms).branch},{''''}) | ismember({Atoms(1:realatoms).branch},{'*'});
end

function I=isBackbone(Atoms)
realatoms=0;
cs={Atoms.chemSymbol};
for i=1:length(Atoms)
    if ~isempty(cs{i})
        realatoms=realatoms+1;
    end
end
I=  (ismember({Atoms(1:realatoms).chemSymbol},{'N'}) & ismember({Atoms(1:realatoms).remoteInd}, {''})) | ...
    (ismember({Atoms(1:realatoms).chemSymbol},{'C'}) & ismember({Atoms(1:realatoms).remoteInd},{'A'})) | ...
    (ismember({Atoms(1:realatoms).chemSymbol},{'C'}) & ismember({Atoms(1:realatoms).remoteInd}, {''})) | ...
    (ismember({Atoms(1:realatoms).chemSymbol},{'O'}) & ismember({Atoms(1:realatoms).remoteInd},{ ''}));
end

function I=isMagnesium(Atoms)
realatoms=0;
cs={Atoms.chemSymbol};
for i=1:length(Atoms)
    if ~isempty(cs{i})
        realatoms=realatoms+1;
    end
end
I=ismember({Atoms(1:realatoms).chemSymbol},{'MG'});
end
