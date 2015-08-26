classdef OligoOutput < handle 
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        File
        Name
        Index
        AnalysisRange
        Windows
        curve
        theta        
    end
    
    methods
        function Output=OligoOutput(File,Name,Index,AnalysisRange,Windows)
            Output.File=File;
            Output.Name=Name;
            Output.Index=Index;
            Output.AnalysisRange=AnalysisRange;
            Output.Windows=Windows;
        end
        
        function CreateCurve(Output,Data)
            Output.curve=Curve(Output.Name,Data);
        end
        
        function CreateTheta(Output)
            Output.theta=Theta(Output.curve);
        end
        
        function NewRange(Output,newrange)
            Output.AnalysisRange=newrange;
        end
        
        function WriteToFile(obj,File)
            %%
                fid=fopen(File,'wt');
                fprintf(fid, '%s\t',obj.Name);
                fprintf(fid, ' Index ID %u\t from file\t %s',obj.Index,obj.File);
                fwrite(fid, sprintf('\n\n'));
                fprintf(fid, 'Settings \n');
                fprintf(fid, 'AnalysisRange\t%0.1f\t%0.1f \n',...
                    obj.AnalysisRange(1),obj.AnalysisRange(2));
                 fprintf(fid, 'Lower Window\t%0.1f\t%0.1f\nUpper Window\t%0.1f\t%0.1f \n',...
                    obj.Windows{1},obj.Windows{2});
                fprintf(fid,['\nLower baseline\tA=%6.2ET+%0.3g' ...
                    ,'  \tR%c = %0.3f\n'], obj.curve.Beta{1}(2),obj.curve.Beta{1}(1),char(178),obj.curve.R_square{1});
                fprintf(fid,['Upper baseline\tA=%6.2ET+%0.3g' ...
                    ,'  \tR%c = %0.3f\n'], obj.curve.Beta{2}(2),obj.curve.Beta{2}(1),char(178),obj.curve.R_square{2});
                fprintf(fid,'\nTm (data)        \t%4.1f %cC\n',obj.theta.Tm,char(176));
                if ~isempty(obj.theta.TmS)
                    fprintf(fid,'Tm (smoothed data)\t%4.1f %cC\n',obj.theta.TmS,char(176));
                end
                fprintf(fid,'\n\n');
                fprintf(fid,'VantHoff Analysis\t\n');
                fprintf(fid,'DeltaG\t%6.1f\t%c\t%6.1f\tkcal/mol\t@37%cC\n',...);
                    obj.theta.VantHoff.Thermodynamic_Values.deltaG,...
                    char(177),obj.theta.VantHoff.Statistics.G_confidence,char(176));
                fprintf(fid,'DeltaH\t%6.1f\t%c\t%6.1f\tkcal/mol\n',...
                    obj.theta.VantHoff.Thermodynamic_Values.deltaH,...
                    char(177),obj.theta.VantHoff.Statistics.H_confidence);
                fprintf(fid,'DeltaS\t%6.1f\t%c\t%6.1f\t cal/mol\n',...
                    obj.theta.VantHoff.Thermodynamic_Values.deltaS,...
                    char(177),obj.theta.VantHoff.Statistics.S_confidence);
                fprintf(fid,'R%c\t%6.4f\nRMSE\t%6.4f\n',char(178),...
                    obj.theta.VantHoff.Statistics.R_squared,...
                    obj.theta.VantHoff.Statistics.RMSE);
                fprintf(fid,'Model\tlnKeq=%6.2E(1/T)+%6.2E\n',...
                    obj.theta.VantHoff.Statistics.Beta(2),...
                    obj.theta.VantHoff.Statistics.Beta(1));
                fprintf(fid,'Tm (model)\t%4.1f %cC\n',obj.theta.VantHoff.Tm,char(176));               
                
                fprintf(fid,'\n\nNonlinear Analysis\t\n');
                fprintf(fid,'DeltaG\t%6.1f\t%c\t%6.1f\tkcal/mol\t@37%cC\n',...);
                    obj.theta.NonLinear.Thermodynamic_Values.deltaG,...
                    char(177),obj.theta.NonLinear.Statistics.G_confidence,char(176));
                fprintf(fid,'DeltaH\t%6.1f\t%c\t%6.1f\tkcal/mol\n',...
                    obj.theta.NonLinear.Thermodynamic_Values.deltaH,...
                    char(177),obj.theta.NonLinear.Statistics.H_confidence);
                fprintf(fid,'DeltaS\t%6.1f\t%c\t%6.1f\t cal/mol\n',...
                    obj.theta.NonLinear.Thermodynamic_Values.deltaS,...
                    char(177),obj.theta.NonLinear.Statistics.S_confidence);
                fprintf(fid,'R%c\t%6.4f\nRMSE\t%6.4f\n',char(178),...
                    obj.theta.NonLinear.Statistics.R_squared,...
                    obj.theta.NonLinear.Statistics.RMSE);
                
                fprintf(fid,'Tm (model)\t%4.1f %cC\n\n',obj.theta.NonLinear.Tm,char(176));

                fprintf(fid,'Temp\t      Abs\t      A(smooth)\t      Theta\t      Theta(smooth)\tTheta(predL)\tTheta(predN)\n');
                fprintf(fid,'%4.1f\t      %4.4f\t      %4.4f\t      %4.4f\t      %4.4f\t        %4.4f\t        %4.4f\n',...
                    [obj.curve.X,obj.curve.Y,obj.curve.YS,obj.theta.theta,...
                    obj.theta.thetaS,obj.theta.VantHoff.Statistics.Y_hat,...
                    obj.theta.NonLinear.Statistics.Y_hat]');
                fclose(fid);

                %dlmwrite(filename,indices{i}, 'delimiter', '+',...
                   
                %%
            end       
    end
    
end

