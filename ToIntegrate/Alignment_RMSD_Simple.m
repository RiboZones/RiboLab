function [ RMSD_Aln ] = Alignment_RMSD_Simple( cads_1, cads_2, cads_3, item_names1, item_names2, item_names3, FullAlignment)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    cads_3=cads_1;
end
if nargin < 4
    FullAlignment=cads_1.Alignment;
end

FindSpecies1=regexprep(lower(cads_1(1).Species),'[\s_]','');
FindSpecies2=regexprep(lower(cads_2(1).Species),'[\s_]','');
FindSpecies3=regexprep(lower(cads_3(1).Species),'[\s_]','');

LookSpecies=lower(regexprep({cads_1(1).Alignment.Header},'[\s_]',''));
[~,Species_Ind1]=ismember(FindSpecies1,LookSpecies);
[~,Species_Ind2]=ismember(FindSpecies2,LookSpecies);
[~,Species_Ind3]=ismember(FindSpecies3,LookSpecies);

KeepAln1=~ismember(cellstr(cads_1(1).Alignment(Species_Ind2).Sequence')','-');
KeepAln2=~ismember(cellstr(cads_2(1).Alignment(Species_Ind1).Sequence')','-');
KeepAln3A=~ismember(cellstr(cads_3(1).Alignment(Species_Ind1).Sequence')','-');
KeepAln3B=~ismember(cellstr(cads_3(1).Alignment(Species_Ind2).Sequence')','-');
KeepAln3 = KeepAln3A & KeepAln3B;
Aln_Struct=FullAlignment([Species_Ind1,Species_Ind2]);
ii=0;
jj=0;
AlnMap=cell(2,length(Aln_Struct(1).Sequence));
for iii=1:length(Aln_Struct(1).Sequence)
    if Aln_Struct(1).Sequence(iii) ~= '-'
        ii=ii+1;
        AlnMap{1,iii}=item_names1{ii};
    else
        AlnMap{1,iii}='';
    end
    if Aln_Struct(2).Sequence(iii) ~= '-'
        jj=jj+1;
        AlnMap{2,iii}=item_names2{jj};
    end
    
end

RemoveAln3_A=ismember(cellstr(cads_1(1).Alignment(Species_Ind3).Sequence')','-');
RemoveAln3_B=ismember(cellstr(cads_2(1).Alignment(Species_Ind3).Sequence')','-');


RL1=item_names1(KeepAln1 & ~ RemoveAln3_A);
RL2=item_names2(KeepAln2 & ~ RemoveAln3_B);
% RemoveResi=cads_1.RiboLabMap.ItemNames(KeepAln1 & RemoveAln3_A);
RL3=item_names3(KeepAln3);



for i=1:length(cads_1)
    Res1{i}=Residues(cads_1(i).Name);
    Res1{i}.GroupResidues(cads_1(i));
end
ResCom1=plus(Res1{:});

for i=1:length(cads_2)
    Res2{i}=Residues(cads_2(i).Name);
    Res2{i}.GroupResidues(cads_2(i));
end
ResCom2=plus(Res2{:});

if nargin >= 3
    for i=1:length(cads_3)
        Res3{i}=Residues(cads_3(i).Name);
        Res3{i}.GroupResidues(cads_3(i));
    end
    ResCom3=plus(Res3{:});
else
    ResCom3=ResCom1;
end

PA1=PseudoAtoms(ResCom1.Name);
PA2=PseudoAtoms(ResCom2.Name);

PA1.CenterOfMass(ResCom1,'isN1orN9');
PA2.CenterOfMass(ResCom2,'isN1orN9');

[~,I1]=ismember(RL1,regexprep(ResCom1.ItemNames,'\s',''));
[~,I2]=ismember(RL2,regexprep(ResCom2.ItemNames,'\s',''));
[~,I3]=ismember(RL3,regexprep(ResCom3.ItemNames,'\s',''));

all_xtals=(I1>0 & I2>0) & I3 > 0;
P1=vertcat(PA1.Position{I1(all_xtals)});
P2=vertcat(PA2.Position{I2(all_xtals)});

RMSD=sqrt(sum((P1-P2).^2,2));
RMSD_Full1 = zeros(length(KeepAln1),1);
RMSD_Full2 = zeros(length(KeepAln2),1);

% Residues which are not in the alignment get a RMSD of -2. This can later
% be changed in postprocessing.
RMSD_Full1(~KeepAln1)=-2;
RMSD_Full2(~KeepAln2)=-2;

% Residues which are not in both structures get a RMSD of -1. This can later
% be changed in postprocessing.
RMSD_Full1(ismember(item_names1,RL1(I1<=0 | I2<=0)))=-1;
RMSD_Full2(ismember(item_names2,RL2(I1<=0 | I2<=0)))=-1;

%Residues which are in both alignments and both structures get their RMSD put in.
RMSD_Full1(ismember(item_names1,RL1(all_xtals)))=RMSD;
RMSD_Full2(ismember(item_names2,RL2(all_xtals)))=RMSD;

RMSD_Aln.RL1=RL1;
RMSD_Aln.RL2=RL2;
RMSD_Aln.RMSD_Full1=RMSD_Full1;
RMSD_Aln.RMSD_Full2=RMSD_Full2;
RMSD_Aln.X=I1(all_xtals);
RMSD_Aln.x.orig=str2double(char(regexprep(ResCom1.ItemNames(I1(all_xtals)),'[A-z\d]+_','')));
RMSD_Aln.RMSD.orig=RMSD;
if sum(RemoveAln3_A) == 0
    RMSD_Aln.x.renumber=RMSD_Aln.x.orig;
    RMSD_Aln.RMSD.renumber=RMSD_Aln.RMSD.orig;
else
%     removeresi=ismember(RL1(both),RemoveResi);
%     rr=regexprep(ResCom1.ItemNames(I1(both)),'\s','');
%     oldresi=rr(~removeresi);
    oldresi=regexprep(ResCom1.ItemNames(I1(all_xtals)),'\s','');
    for i=1:length(oldresi)
        [~,I]=ismember(oldresi{i},AlnMap(1,:));
         RMSD_Aln.x.renumber(i)=str2double(regexprep(AlnMap{2,I},'[A-z\d]+_',''));
    end
end
RMSD_Aln.RMSD.renumber=RMSD_Aln.RMSD.orig;
x=find(KeepAln1 & ~RemoveAln3_A);
RMSD_Aln.x.Species1=x(all_xtals);
y=find(KeepAln2 & ~RemoveAln3_B);
RMSD_Aln.x.Species2=y(all_xtals);
z=find(KeepAln3);
RMSD_Aln.x.Species3=z(all_xtals);

% RMSD_Aln.x.Species3=find(KeepAln3);

%RMSD_Aln.x.renumber=str2num(char(regexprep(ResCom3.ItemNames(I3(I1>0 & I2>0 & I3 >0)),'[A-z\d]_','')));
%[~,III]=setdiff(RMSD_Aln.x.renumber,RMSD_Aln.x.orig);
%if isempty(III)
% RMSD_Aln.RMSD.renumber=RMSD_Aln.RMSD.orig;
%else
%
%end

