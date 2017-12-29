function [ RMSD_Struct ] = Alignment_RMSD_Simple3( cads_B, cads_A, cads_E, item_names1, item_names2, item_names3,Alignment,varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

BA=true();
BE=true();
AE=true();
%NumberingStruct=RVlab_B;

if nargin > 7
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'BA'
                BA=varargin{2*ind};
            case 'BE'
                BE=varargin{2*ind};
            case 'AE'
                AE=varargin{2*ind};
           % case 'domain'
                %switch varargin{2*ind}
                   % case 'B'
                    %    NumberingStruct=RVlab_B;
                   % case 'A'
                  %      NumberingStruct=RVlab_A;
                  %  case 'E'
                    %    NumberingStruct=RVlab_E;
                %end
        end
    end
end


% Update alignments to be sure. 
if BA || BE
    FA=UpdateAlignment_simple(cads_B,Alignment);
end
if BA || AE
    FA=UpdateAlignment_simple(cads_A,Alignment);
end
if BE || AE
    UpdateAlignment_simple(cads_E,Alignment);
end

% Comupte Alignment RMSD for original alignment
if BA
    RMSD_Struct.BA=Alignment_RMSD_Simple(cads_B,cads_A,cads_E,item_names1,item_names2,item_names3,FA);
end
if AE
    RMSD_Struct.AE=Alignment_RMSD_Simple(cads_A,cads_E,cads_B,item_names2,item_names3,item_names1,FA);
end
if BE
    RMSD_Struct.BE=Alignment_RMSD_Simple(cads_B,cads_E,cads_A,item_names1,item_names3,item_names2,FA);
end




% Plot results
figure();
hold on;
if BA
    plot(RMSD_Struct.BA.x.Species1,RMSD_Struct.BA.RMSD.renumber,'r');
    %plot(RMSD_Second.BA.x.Species1,RMSD_Second.BA.RMSD.renumber,'k--');
end
if AE
    plot(RMSD_Struct.AE.x.Species3,RMSD_Struct.AE.RMSD.renumber,'b');
   % plot(RMSD_Second.AE.x.Species3,RMSD_Second.AE.RMSD.renumber,'c--');
end
if BE
    plot(RMSD_Struct.BE.x.Species1,RMSD_Struct.BE.RMSD.renumber,'g');
    %plot(RMSD_Second.BE.x.Species1,RMSD_Second.BE.RMSD.renumber,'y--');
end
hold off;

%RMSD_Struct=[RMSD_Struct,RMSD_Second];

end


