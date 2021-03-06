classdef ConAnalSaveState < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        GeneList
        PDBfile1
        PDBfile2
        PDB1
        PDB2
        AlignmentFile
        SaveFile
        AlignmentMethod
        PDBchain1
        PDBchain2
        ConservationFilter
        PeptideFilter
        ReferenceFrame
        Center
        ShellBoundaries
        VariabilityBins
        ContactDistance
        Output
    end
    
    methods
        function CASS=ConAnalSaveState(handles)
            UserData=get(handles.output,'UserData');
            CASS.Name=UserData.Output.Name;

        end
        
        function CASSsaveBasic(CASS,handles)
            UserData=get(handles.output,'UserData');
            CASS.AlignmentFile=UserData.alignment_file;
            CASS.PDBfile1=UserData.pdb_file;
            CASS.PDBfile2=UserData.pdb2_file;
            CASS.PDB1=UserData.pdb;
            CASS.PDB2=UserData.pdb2;
            CASS.Output=UserData.Output;
            CASS.GeneList.gene_list=UserData.gene_list;
%             CASS.GeneList.gene_list_path=UserData.gene_list_path;
            CASS.GeneList.gene_list_file=UserData.gene_list_file;
            CASS.SaveFile=UserData.save_file;
        end
        
        function CASSsaveAdvanced(CASS,handles)
            CASS.Name=get(handles.pdb_file_text,'String');
            CASS.AlignmentMethod=get(handles.AlignMethod,'Value');
            CASS.PDBchain1=get(handles.ChainIDedit,'Value');
            CASS.PDBchain2=get(handles.ChainID2edit,'Value');
            CASS.ConservationFilter={get(handles.filter_level,'Value'),...
                get(handles.filter_cutoff,'String')};
            CASS.PeptideFilter=get(handles.peptide_filter,'String');
            CASS.ReferenceFrame=get(handles.alignment_radio,'Value');
            CASS.Center={get(handles.Center_menu,'Value'),...
                [str2double(get(handles.CenterX,'String')),...
                str2double(get(handles.CenterY,'String')),...
                str2double(get(handles.CenterZ,'String'))]};
            CASS.ShellBoundaries={get(handles.shell_boundaries_menu,'Value'),...
                get(handles.custom_shells,'String')};
            CASS.VariabilityBins={get(handles.variability_bins_menu,'Value'),...
                get(handles.custom_bins,'String')};
            CASS.ContactDistance=handles.map_cutoff;
        end
        
        function CASSrestoreBasic(CASS,handles)
            
            CAUD=ConAnalUserData(CASS.Name);
            
%             if ispc()
%                 slash=strfind(CASS.AlignmentFile,'\');
%             else
%                 slash=strfind(CASS.AlignmentFile,'/');
%             end
%             if ~isempty(slash)
%                 CAUD.alignment_path=CASS.AlignmentFile(1:slash(end));
             CAUD.alignment_file=CASS.AlignmentFile;%(slash(end)+1:end);
%             else
%                 CAUD.alignment_path=[];
%                 CAUD.alignment_file=[];
%             end
            
%             if ispc()
%                 slash=strfind(CASS.PDBfile1,'\');
%             else
%                 slash=strfind(CASS.PDBfile1,'/');
%             end
%             if ~isempty(slash)
%                 CAUD.pdb_path=CASS.PDBfile1(1:slash(end));
              CAUD.pdb_file=CASS.PDBfile1;%(slash(end)+1:end);
%             else
%                 CAUD.pdb_path=[];
%                 CAUD.pdb_file=[];
%             end
%             
%             if ispc()
%                 slash=strfind(CASS.PDBfile2,'\');
%             else
%                 slash=strfind(CASS.PDBfile2,'/');
%             end
%             if ~isempty(slash)
%                 CAUD.pdb2_path=CASS.PDBfile2(1:slash(end));
              CAUD.pdb2_file=CASS.PDBfile2;%(slash(end)+1:end);
%             else
%                 CAUD.pdb2_path=[];
%                 CAUD.pdb2_file=[];
%             end
            CAUD.pdb=CASS.PDB1;
            CAUD.pdb2=CASS.PDB2;
            CAUD.Output=CASS.Output;
            CAUD.gene_list=CASS.GeneList.gene_list;
%             CAUD.gene_list_path=CASS.GeneList.gene_list_path;
            CAUD.gene_list_file=CASS.GeneList.gene_list_file;
%             if ispc()
%                 slash=strfind(CASS.SaveFile,'\');
%             else
%                 slash=strfind(CASS.SaveFile,'/');
%             end
%             if ~isempty(slash)
%                 CAUD.save_file_path=CASS.SaveFile(1:slash(end));
            CAUD.save_file=CASS.SaveFile;%(slash(end)+1:end);
%             else
% %                 CAUD.save_file_path=[];
%                 CAUD.save_file=[];
%             end
            set(handles.output,'UserData',CAUD)
        end
        
        function CASSrestoreAdvanced(CASS,handles)
            set(handles.AlignMethod,'Value',CASS.AlignmentMethod);
            set(handles.ChainIDedit,'Value',CASS.PDBchain1);
            set(handles.ChainID2edit,'Value',CASS.PDBchain2);
            set(handles.filter_level ,'Value',CASS.ConservationFilter{1});
            set(handles.filter_cutoff,'String',CASS.ConservationFilter{2});
            set(handles.peptide_filter,'String',CASS.PeptideFilter);
            if CASS.ReferenceFrame
                set(handles.alignment_radio,'Value',CASS.ReferenceFrame);
            else
                set(handles.pdb_radio,'Value',~CASS.ReferenceFrame);
            end
            set(handles.Center_menu,'Value',CASS.Center{1});
            set(handles.CenterX,'String',num2str(CASS.Center{2}(1)));
            set(handles.CenterY,'String',num2str(CASS.Center{2}(2)));
            set(handles.CenterZ,'String',num2str(CASS.Center{2}(3)));
            set(handles.shell_boundaries_menu,'Value',CASS.ShellBoundaries{1});
            set(handles.custom_shells,'String',CASS.ShellBoundaries{2});
            set(handles.variability_bins_menu,'Value',CASS.VariabilityBins{1});
            set(handles.custom_bins,'String',CASS.VariabilityBins{2});
            handles.map_cutoff=CASS.ContactDistance;
        end
    end
    
end