classdef Protein < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        FAM
        NewCenter
        Distances
        cSequence
        variability
        shell
    end
    
    methods
        function Pro = Protein(name)                                 
            if nargin < 1                                                  
                name='un-named';
            end
            Pro.Name  = name;                                              
        end
        
        function Pro=PopulateProtein(Pro,FAM)
            Pro.FAM=FAM;
        end
        
        function Pro=ReCenter(Pro,newcenter)
            Pos(:,1)=[Pro.FAM.Model.X]';
            Pos(:,2)=[Pro.FAM.Model.Y]';
            Pos(:,3)=[Pro.FAM.Model.Z]';
            Pro.NewCenter=Pos-repmat(newcenter,[length(Pos),1]);
        end
        
        function Pro=DistanceFromCenter(Pro)
            Pro.Distances=sqrt(Pro.NewCenter(:,1).^2+Pro.NewCenter(:,2).^2+Pro.NewCenter(:,3).^2);
        end
        
        function res=isShell(Pro,shell)
            if isempty(Pro.Distances)
                r=sqrt(Pro.NewCenter(:,1).^2+Pro.NewCenter(:,2).^2+Pro.NewCenter(:,3).^2);
            else
                r=Pro.Distances;
            end
            found_inside=r <= shell(1);
            res_inside=unique([Pro.FAM.Model(found_inside).resSeq]);
            found_shell= r > shell(1) & r <= shell(2);
            res_shell=unique([Pro.FAM.Model(found_shell).resSeq]);
            res_border=intersect(res_inside,res_shell);
            res=setdiff(res_shell,res_border);
        end
        
        function Pro=addConsensusSequence(Pro,cSequence)
            Pro.cSequence=cSequence;
        end
        
        function Pro=addVariability(Pro,variability)
            Pro.variability=variability;
        end
        
        function Pro=RebuildPDB(Pro)
            % add code to add variability information into pdb file
        end
        
        function [Pro,minDistances]=binShells(Pro,bins)
            [~,bin] = histc(Pro.Distances,bins);
%           [UresSeq, I]=unique([Pro.FAM.Model.resSeq]);
            [UresSeq, I]=unique(Pro.FAM.UniqueResSeq);

            Shell=zeros(1,length(I)); 
            minDistances=zeros(1,length(I));
            Shell(1)=min(bin(1:I(1)));
            for i=2:length(UresSeq)
                Shell(i)=min(bin(I(i-1)+1:I(i)));
                minDistances(i)=min(Pro.Distances(I(i-1)+1:I(i)));
            end
            Pro.shell=Shell;
        end
        
        d=OnionPlot(Pro,bins,keep,double)
        
        function PlotVariability(Pro,bins,keep)
            if nargin < 2
                bins=7;
            end
            
            if strcmp(bins,'standard')
                bins=[0, realmin, 1+realmin, 2+realmin, Inf];
                standard=true;
            else
                standard=false;
            end
            if ~isempty(Pro.shell)
                if nargin <3
                    keep=Pro.shell>0;
                end
                numshells=length(unique(Pro.shell(keep)));
                Shells=unique(Pro.shell(keep));
                G=cell(1,numshells);
                H=cell(1,numshells);
                shells=cell(1,numshells);
                numres=zeros(1,numshells);
                for i=1:numshells
                    var=Pro.variability(keep);
                    G{i}=var(Pro.shell(keep)==Shells(i));
                    numres(i)=length(G{i});
                    if length(bins)==1
                        warning('This feature is currently invalid. Do not use.')
                        [H{i}, ~]=hist(G{i},bins);
                    else
                        H{i}=histc(G{i},bins);
                        H{i}(end)=[];
                    end
                    if size(H{i},1)~=1
                        H{i}=H{i}';
                    end
%                   shells{i}=['Shell ',num2str(i+minShell-1)];
                    %double wide
                    shells{i}=['Shell ',num2str(2*(Shells(i))-1),...
                        '+',num2str(2*(Shells(i)))];
                end
                
                if length(bins)==1
                    numbins=bins;
                else
                    numbins=length(bins)-1;
                end
                z=cell2mat(H)';
                d=reshape(z,numbins,numshells);
                d=d./repmat(numres,numbins,1);
                
                subplot(1,2,1),h=bar(d,.6);
                %recolor for ribosome shell
                usedShells=Shells ;
                for i=1:length(h)
                    %                     switch usedShells(i)
                    %                         case {1,2}
                    %                             set(h(i),'FaceColor',[1 0 0]);
                    %                         case {3,4}
                    %                             set(h(i),'FaceColor',[0 1 0]);
                    %
                    %                         case {5,6}
                    %                             set(h(i),'FaceColor',[0 0 1]);
                    %
                    %                         case {7,8}
                    %                             set(h(i),'FaceColor',[.4784 .0627 .8941]);
                    %
                    %                         otherwise
                    %                             set(h(i),'FaceColor',[.8706 .4902 0]);
                    %                     end%
                    %double thickness
                    switch usedShells(i)
                        case 1
                            set(h(i),'FaceColor',[1 0 0]);
                        case 2
                            set(h(i),'FaceColor',[0 1 0]);
                            
                        case 3
                            set(h(i),'FaceColor',[0 0 1]);
                            
                        case 4
                            set(h(i),'FaceColor',[.5 0 1]);
                    
                        case 5
                            set(h(i),'FaceColor',[1 .5 0]);
                            
                        otherwise
                            set(h(i),'FaceColor',[.5 .5 .5]);
                    end

                end                             
                legend(shells)
            else            
                numres=length(Pro.variability);
                H=histc(Pro.variability,bins);
                H(end)=[];
                numbins=length(bins)-1;
                d=H/numres;
                subplot(1,2,1),bar(d,.6);              
            end       
            ylim([0,1])
            title(Pro.Name,'Interpreter','none')
            if standard
                set(gca,'XTickLabel',{'Universally conserved',...
                    'Highly Conserved','Conserved','Variable'})
            else
                binName=cell(1,numbins);
                for i=1:numbins
                    binName{i}=[num2str(bins(i)),' - ',num2str(bins(i+1))];
                end
                xlabel('Shannon Entropy [bits]')
                set(gca,'XTickLabel',binName)
            end
            ylabel('Frequeny of occurence')
            if ~isempty(Pro.shell)
                [~,I]=unique(Pro.FAM.UniqueResSeq);
                resSeq=[Pro.FAM.Model(I).resSeq];
                X=resSeq(keep);
            else
                X=1:length(Pro.variability);
                keep=true(1,length(Pro.variability));
            end
            
            subplot(1,2,2),plot(X,Pro.variability(keep))
            xlabel('Residue number')
            ylabel('Shannon Entropy [bits]')
            ylim([-.1,4.4])
            title(Pro.Name,'Interpreter','none')
        end
    end 
end

