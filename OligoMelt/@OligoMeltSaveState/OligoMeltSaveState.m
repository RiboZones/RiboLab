classdef OligoMeltSaveState < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        File
        Index
        AnalysisRange
        Windows
        method
        dataMode
        molecularity
        concentration
        
    end
    
    methods
        function OMSS=OligoMeltSaveState(handles)
            UserData=get(handles.output,'UserData');
            OMSS.Name=UserData.Name;
        end
        
        function OMSSbasic(OMSS,handles)
            UserData=get(handles.output,'UserData');
            OMSS.File=UserData.File;            
            OMSS.Index=UserData.Index;
            OMSS.AnalysisRange=UserData.AnalysisRange;            
            OMSS.Windows=UserData.Windows;            
        end
        
        function OMSSadvanced(OMSS,handles)
            OMSS.method=get(handles.methodPopup,'Value');
            OMSS.dataMode=get(handles.DataMode,'Value');
            OMSS.molecularity=get(handles.molecularityMenu,'Value');
            OMSS.concentration=get(handles.concentration,'String');
        end
        
        function OMSSrestore(OMSS,handles)
            UserData.Name=OMSS.Name;
            UserData.File=OMSS.File;
            UserData.Index=OMSS.Index;
            UserData.AnalysisRange=OMSS.AnalysisRange;
            UserData.Windows=OMSS.Windows;
            set(handles.datasetpopup,'Value',UserData.Index)
            
            set(handles.output,'UserData',UserData);
            set(handles.methodPopup,'Value',OMSS.method);
            if OMSS.dataMode
                set(handles.DataMode,'Value',OMSS.dataMode);
            else
                set(handles.residualMode,'Value',~OMSS.dataMode);
            end
            set(handles.molecularityMenu,'Value',OMSS.molecularity);
            set(handles.concentration,'String',OMSS.concentration);
        end
    end  
end

