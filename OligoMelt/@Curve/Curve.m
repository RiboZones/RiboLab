classdef Curve < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        X
        Y
        YS
        Windows
        Range
        LowerRegressionRange
        UpperRegressionRange
        Indices
        Y_hat
        Y_hatS
        Beta
        BetaS
        R_square
        R_squareS
    end
    
    methods
        function curve=Curve(Name,data)
            curve.Name=Name;
            curve.X=data(:,1);
            curve.Y=data(:,2);
        end
        
        function WindowLimits(curve,Windows)
            curve.Windows=Windows;
            curve.LowerRegressionRange = Windows{1};
            curve.UpperRegressionRange = Windows{2};
            curve.Indices.LRR = curve.X >= curve.LowerRegressionRange(1) ...
                & curve.X <= curve.LowerRegressionRange(2);
            curve.Indices.URR = curve.X >= curve.UpperRegressionRange(1) ...
                & curve.X <= curve.UpperRegressionRange(2);
        end
        
        function LinearRegression(curve)
            stats.lower=regstats(curve.Y(curve.Indices.LRR),...
                curve.X(curve.Indices.LRR),...
                'linear',{'rsquare','beta'});
            stats.upper=regstats(curve.Y(curve.Indices.URR),...
                curve.X(curve.Indices.URR),...
                'linear',{'rsquare','beta'});
            curve.Beta={stats.lower.beta,stats.upper.beta};
            curve.R_square={stats.lower.rsquare,stats.upper.rsquare};
            y_hat_lower=curve.Beta{1}(2) * curve.X + curve.Beta{1}(1);
            y_hat_upper=curve.Beta{2}(2) * curve.X + curve.Beta{2}(1);
            curve.Y_hat={y_hat_lower,y_hat_upper};
        end
        function LinearRegressionS(curve)
            span=round(0.04*length(curve.X));
            curve.YS=smooth(curve.Y,span,'moving');
            stats.lower=regstats(curve.YS(curve.Indices.LRR),...
                curve.X(curve.Indices.LRR),...
                'linear',{'rsquare','beta'});
            stats.upper=regstats(curve.YS(curve.Indices.URR),...
                curve.X(curve.Indices.URR),...
                'linear',{'rsquare','beta'});
            curve.BetaS={stats.lower.beta,stats.upper.beta};
            curve.R_squareS={stats.lower.rsquare,stats.upper.rsquare};
            y_hat_lowerS=curve.BetaS{1}(2) * curve.X + curve.BetaS{1}(1);
            y_hat_upperS=curve.BetaS{2}(2) * curve.X + curve.BetaS{2}(1);
            curve.Y_hatS={y_hat_lowerS,y_hat_upperS};
        end
        function Plot(curve,gui)
            if nargin < 2
                gui=0;
            end
            if ~gui
                figure()
            end
            %set(gca,'NextPlot','replace')
            %hold on
            if isempty(curve.Y_hatS)
                plot(curve.X,curve.Y,'b.')
                hold on
                plot(curve.X,curve.Y_hat{1},'k')
                plot(curve.X,curve.Y_hat{2},'r')
                h=legend(curve.Name,'Lower Baseline','Upper Baseline',...
                    'Location','SouthOutside');
            else
                plot(curve.X,curve.YS,'r.')
                hold on
                plot(curve.X,curve.Y_hatS{1},'k')
                plot(curve.X,curve.Y_hatS{2},'b')
                h=legend([curve.Name,' (smoothed)'],'Lower Baseline','Upper Baseline',...
                    'Location','SouthOutside');
            end
            if curve.X(1)>100
                xlabel('Temperature[K]')
            else
                xlabel('Temperature [\circC]')
            end
            ylabel('Absorbance')
            title('A(T)')
            set(h,'Interpreter','none')
            %set(h,'FontUnits','Normalized')
            hold off
        end
      
        function Preview(curve)
            plot(curve.X,curve.Y,'b.')          
            if curve.X(1)>100
                xlabel('Temperature[K]')
            else
                xlabel('Temperature [\circC]')
            end
            ylabel('Absorbance')
            h=legend(curve.Name,'Location','SouthEast');
            title('A(T)')
            set(h,'Interpreter','none')
            %set(h,'FontUnits','Normalized')
        end
    end
end

