function [ RMSD_Struct ] = Alignment_RMSD_Compare_Multi( RVlab_B, RVlab_A, RVlab_E, OriginalAlignment, SecondAlignment,varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

BA=true();
BE=true();
AE=true();
NumberingStruct=RVlab_B;

if nargin > 5
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'BA'
                BA=varargin{2*ind};
            case 'BE'
                BE=varargin{2*ind};
            case 'AE'
                AE=varargin{2*ind};
            case 'domain'
                switch varargin{2*ind}
                    case 'B'
                        NumberingStruct=RVlab_B;
                    case 'A'
                        NumberingStruct=RVlab_A;
                    case 'E'
                        NumberingStruct=RVlab_E;
                end
        end
    end
end


% Update alignments with original alignment. This shouldn't be nesacary, but
%do it just in case these don't actually match or in case the alignment
%file itself has changed. 
if BA || BE
    FA=UpdateAlignments(RVlab_B,OriginalAlignment);
end
if BA || AE
    FA=UpdateAlignments(RVlab_A,OriginalAlignment);
end
if BE || AE
    UpdateAlignments(RVlab_E,OriginalAlignment);
end

% Comupte Alignment RMSD for original alignment
if BA
    RMSD_Orig.BA=Alignment_RMSD(RVlab_B,RVlab_A,NumberingStruct,FA);
end
if AE
    RMSD_Orig.AE=Alignment_RMSD(RVlab_A,RVlab_E,NumberingStruct,FA);
end
if BE
    RMSD_Orig.BE=Alignment_RMSD(RVlab_B,RVlab_E,NumberingStruct,FA);
end


% Update alignment with second alignment
if BA || BE
    SA=UpdateAlignments(RVlab_B,SecondAlignment);
end
if BA || AE
    SA=UpdateAlignments(RVlab_A,SecondAlignment);
end
if BE || AE
    UpdateAlignments(RVlab_E,SecondAlignment);
end

% Comupte Alignment RMSD for second alignment
if BA
    RMSD_Second.BA=Alignment_RMSD(RVlab_B,RVlab_A,NumberingStruct,SA);
end
if AE
    RMSD_Second.AE=Alignment_RMSD(RVlab_A,RVlab_E,NumberingStruct,SA);
end
if BE
    RMSD_Second.BE=Alignment_RMSD(RVlab_B,RVlab_E,NumberingStruct,SA);
end


% Return to original alignment in case this is persistent due to objects
% being handles
if BA || BE
    UpdateAlignments(RVlab_B,OriginalAlignment);
end
if BA || AE
    UpdateAlignments(RVlab_A,OriginalAlignment);
end
if BE || AE
    UpdateAlignments(RVlab_E,OriginalAlignment);
end


% Plot results
figure();
hold on;
if BA
    plot(RMSD_Orig.BA.x.renumber,RMSD_Orig.BA.RMSD.renumber,'r');
    plot(RMSD_Second.BA.x.renumber,RMSD_Second.BA.RMSD.renumber,'k--');
end
if AE
    plot(RMSD_Orig.AE.x.renumber,RMSD_Orig.AE.RMSD.renumber,'b');
    plot(RMSD_Second.AE.x.renumber,RMSD_Second.AE.RMSD.renumber,'c--');
end
if BE
    plot(RMSD_Orig.BE.x.renumber,RMSD_Orig.BE.RMSD.renumber,'g');
    plot(RMSD_Second.BE.x.renumber,RMSD_Second.BE.RMSD.renumber,'y--');
end
hold off;

RMSD_Struct=[RMSD_Orig,RMSD_Second];
end


