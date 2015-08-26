classdef Theta < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        Curve
        theta
        thetaS
        VantHoff
        NonLinear
        Tm
        TmS
    end
    
    methods
        function THETA=Theta(curve)
            THETA.Name=curve.Name;
            THETA.Curve=curve;
        end
        
        function CalculateTheta(THETA)
            THETA.theta=(THETA.Curve.Y - THETA.Curve.Y_hat{1}) ./ ...
                (THETA.Curve.Y_hat{2} - THETA.Curve.Y_hat{1});
            if ~isempty(THETA.Curve.YS)
                THETA.thetaS=(THETA.Curve.YS - THETA.Curve.Y_hatS{1}) ./...
                    (THETA.Curve.Y_hatS{2} - THETA.Curve.Y_hatS{1});
            end
        end  
        
        function auto_range=AutoRange(THETA)
            Low=find(THETA.theta>=0.15, 1 );
            High=find(THETA.theta>=0.85, 1 );
            auto_range=[THETA.Curve.X(Low),THETA.Curve.X(High)];
        end
        
        function Plot(THETA,gui,Range)
            if nargin < 2
                gui=0;
            end
            THETA.Curve.Plot(gui)
            if nargin <31984
                THETA.PlotTheta(gui)     
            else
                THETA.PlotTheta(gui,Range)
            end
        end
        
        function PlotTheta(THETA,gui,Range)
            if nargin < 2
                gui=0;
            end
            if nargin <3
                WithinRange=ones(1,length(THETA.Curve.X))==1;
            else
                WithinRange = THETA.Curve.X >= Range(1)...
                    & THETA.Curve.X <= Range(2);
            end
            if ~gui
                figure()
            end
            plot(THETA.Curve.X(WithinRange),THETA.theta(WithinRange),'b.')
            if THETA.Curve.X(1)>100
                xlabel('Temperature[K]')
            else
                xlabel('Temperature [\circC]')
            end
            ylabel('Normalized Absorbance')
            title('\theta(T)')
            
            if isempty(THETA.thetaS)
                [h,ho]=legend(THETA.Name,'Location','SouthOutside');
            else
                hold on
                plot(THETA.Curve.X(WithinRange),THETA.thetaS(WithinRange),'r')
                [h,ho]=legend(THETA.Name,[THETA.Name,' (smoothed)'],'Location','SouthOutside');
                hold off
            end
            set(h,'Interpreter','none')
            %set(findobj(ho,'Type','text'),'FontUnits','normalized','FontSize',2)
            %set(h,'FontUnits','Normalized')
        end
        
        function ComputeVantHoff(THETA,VantHoffRange,Method,Concentration)
            WithinVantHoffRange = THETA.Curve.X >= VantHoffRange(1)...
                & THETA.Curve.X <= VantHoffRange(2);
            
            if nargin < 4
                Method='monomolecular';
            end
            if isempty(THETA.Curve.YS)
                theta=THETA.theta;
            else
                theta=THETA.thetaS;
            end
            if THETA.Curve.X(1)>100
                T=1./(THETA.Curve.X);
            else
                T=1./(THETA.Curve.X+273.15);
            end
            switch Method
                case 'monomolecular'
                    lnK=log((theta - 1e-3)./(1-theta + 1e-3));
                case 'bimolecular2A'
                    lnK=log(theta./(2*Concentration*((1-theta).^2)));
                case 'bimolecularAB'
                    lnK=log(2*theta./(Concentration*((1-theta).^2)));
                otherwise
            end
            
            data=[T lnK];
            vanthoff=[T(WithinVantHoffRange) lnK(WithinVantHoffRange)];
            
            stats=regstats(vanthoff(:,2),vanthoff(:,1),'linear',...
                {'yhat','rsquare','beta'});
            [B,BINT] = regress(vanthoff(:,2),[ones(size(vanthoff(:,1))) vanthoff(:,1)]);
            S_confidence=1.986*(BINT(1,2)-B(1));
            H_confidence=1.986*(BINT(2,2)-B(2))/1000;
            G_confidence=sqrt((1000*H_confidence)^2+(310.15*S_confidence)^2)/1000;
            lnK_predicted=stats.beta(2)*T+stats.beta(1);
            K_predicted=exp(lnK_predicted);
            switch Method
                case 'monomolecular'                
                    theta_predicted=K_predicted./(1+K_predicted);
                case 'bimolecular2A'
                    theta_predicted=(-sqrt(8*K_predicted*Concentration + 1)...
                        + 4*K_predicted*Concentration + 1)...
                    ./ (4 * K_predicted * Concentration);
                case 'bimolecularAB'
                    theta_predicted=(-sqrt(2*K_predicted*Concentration + 1)...
                        + K_predicted*Concentration + 1)...
                    ./ (K_predicted * Concentration);
                otherwise
            end
            
            residuals=theta_predicted-theta;
            rmse=sqrt(mean(residuals.^2));
            deltaH=-1.986*stats.beta(2);
            deltaS=1.986*stats.beta(1);
            deltaG=(deltaH-310.15*deltaS);
            THETA.VantHoff.Thermodynamic_Values.deltaH=-deltaH/1000;
            THETA.VantHoff.Thermodynamic_Values.deltaS=-deltaS;
            THETA.VantHoff.Thermodynamic_Values.deltaG=-deltaG/1000;
            THETA.VantHoff.Statistics.Y_hat=theta_predicted;
            THETA.VantHoff.Statistics.lnK=lnK_predicted;            
            THETA.VantHoff.Statistics.Residuals=residuals;
            THETA.VantHoff.Statistics.RMSE=rmse;
            THETA.VantHoff.Statistics.R_squared=stats.rsquare;
            THETA.VantHoff.Statistics.S_confidence=S_confidence;
            THETA.VantHoff.Statistics.H_confidence=H_confidence;
            THETA.VantHoff.Statistics.G_confidence=G_confidence;
            THETA.VantHoff.IncludedData=vanthoff;
            THETA.VantHoff.WholeData=data;
            THETA.VantHoff.Statistics.Beta=stats.beta;
            THETA.VantHoff.Tm=CalculateTm([THETA.Curve.X,theta_predicted]);
        end
        
        function VantHoffFitPlot(THETA,gui)
            if nargin < 2
                gui=0;
            end
            if ~gui
                figure()
            end
            if THETA.Curve.X(1)>100
                T=1./(THETA.Curve.X);
            else
                T=1./(THETA.Curve.X+273.15);
            end
            plot(real(THETA.VantHoff.WholeData(:,1)),...
                real(THETA.VantHoff.WholeData(:,2)),'k.')
            hold on
            plot(real(THETA.VantHoff.IncludedData(:,1)),...
                real(THETA.VantHoff.IncludedData(:,2)),'b+')
            
            %xlim([1/383.15,1/263.15])
            xticks=get(gca,'XTick');
            if THETA.Curve.X(1)>100
                NewTicks=round(1./xticks);
            else
                NewTicks=round(1./xticks-273.15);
            end
            set(gca,'XTickLabel',NewTicks)
            %xlabel('1 / Temperature [1 / K]')
            if THETA.Curve.X(1)>100
                xlabel('Temperature[K]')
            else
                xlabel('Temperature [\circC]')
            end
            ylabel('ln Keq')
            title('Van''t Hoff Plot')
            theta_pred=THETA.VantHoff.Statistics.Y_hat;
            lnK_pred=THETA.VantHoff.Statistics.lnK;
            plot(T,real(lnK_pred),'r')
            h=legend(THETA.Name,[THETA.Name,' (selected)'],[THETA.Name,' (fitted)'],...
                'Location','SouthOutside');
            set(h,'Interpreter','none')
            %set(h,'FontUnits','Normalized')
            hold off
        end
        
        function VantHoffPlot(THETA,gui)
            if nargin < 2
                gui=0;
            end
            if ~gui
                figure()
            end
            if isempty(THETA.thetaS)
                plot(THETA.Curve.X,THETA.theta,'b.')
                hold on
                plot(THETA.Curve.X,THETA.VantHoff.Statistics.Y_hat,'k')
                h=legend([THETA.Name,' (data)'],[THETA.Name,' (predicted)'],'Location','SouthOutside');
            else
                plot(THETA.Curve.X,THETA.thetaS,'r')
                hold on
                plot(THETA.Curve.X,THETA.VantHoff.Statistics.Y_hat,'k')
                h=legend([THETA.Name,' (smoothed)'],[THETA.Name,' (predicted)'],'Location','SouthOutside');
            end
            title('Predicted \theta(T) by VantHoff')
            ylim([-.5,1.5])
            if THETA.Curve.X(1)>100
                xlabel('Temperature[K]')
            else
                xlabel('Temperature [\circC]')
            end
            ylabel('Normalized Absorbance')
            set(h,'Interpreter','none')
            %set(h,'FontUnits','Normalized')
            hold off
        end
        
        function ComputeNonLinearModel(THETA,NonlinearRange,Method,Concentration)
            
            if nargin < 4
                Method='monomolecular';
            end
            
            WithinNonlinearRange = THETA.Curve.X >= NonlinearRange(1)...
                & THETA.Curve.X <= NonlinearRange(2);
            
            if isempty(THETA.Curve.YS)
                theta=THETA.theta;
            else
                theta=THETA.thetaS;
            end
            if THETA.Curve.X(1)>100
                T=1./(THETA.Curve.X);
            else
                T=1./(THETA.Curve.X+273.15);
            end
            switch Method
                case 'monomolecular'
                    K=theta./(1-theta);
                case 'bimolecular2A'
                    K=theta./(2*Concentration*((1-theta).^2));
                case 'bimolecularAB'
                    K=2*theta./(Concentration*((1-theta).^2));
                otherwise
            end
            
            data=[T K];
            nonlinear=[T(WithinNonlinearRange) K(WithinNonlinearRange)];
   
            f = fittype('exp1');
            
            [model gof]=fit(nonlinear(:,1),nonlinear(:,2),f);
            coeffs=coeffvalues(model);
            
            K_predicted=feval(model,T);
            
            switch Method
                case 'monomolecular'
                    theta_predicted=K_predicted./(1+K_predicted);
                case 'bimolecular2A'
                    theta_predicted=(-sqrt(8*K_predicted*Concentration + 1)...
                        + 4*K_predicted*Concentration + 1)...
                    ./ (4 * K_predicted * Concentration);
                case 'bimolecularAB'
                    theta_predicted=(-sqrt(2*K_predicted*Concentration + 1)...
                        + K_predicted*Concentration + 1)...
                    ./ (K_predicted * Concentration);
                otherwise
            end
            
            residuals=theta_predicted-theta;
            rmse=sqrt(mean(residuals.^2));
            deltaS=1.986*log(coeffs(1));
            deltaH=-1.986*coeffs(2);
            deltaG=(deltaH-310.15*deltaS)/1000;
            confidence_intervals=confint(model);
            S_confidence=1.986*(log(confidence_intervals(2,1))-log(coeffs(1)));
            H_confidence=1.986*(confidence_intervals(2,2)-coeffs(2))/1000;
            G_confidence=sqrt((1000*H_confidence)^2+(310.15*S_confidence)^2)/1000;
            THETA.NonLinear.Thermodynamic_Values.deltaH=-deltaH/1000;
            THETA.NonLinear.Thermodynamic_Values.deltaS=-deltaS;
            THETA.NonLinear.Thermodynamic_Values.deltaG=-deltaG;
            THETA.NonLinear.Statistics.Y_hat=theta_predicted;
            THETA.NonLinear.Statistics.Residuals=residuals;
            THETA.NonLinear.Statistics.RMSE=rmse;
            THETA.NonLinear.Statistics.R_squared=gof.rsquare;
            THETA.NonLinear.IncludedData=nonlinear;
            THETA.NonLinear.WholeData=data;
            THETA.NonLinear.Statistics.S_confidence=S_confidence;
            THETA.NonLinear.Statistics.H_confidence=H_confidence;
            THETA.NonLinear.Statistics.G_confidence=G_confidence;
            THETA.NonLinear.Statistics.model=model;
            THETA.NonLinear.Tm=CalculateTm([THETA.Curve.X,theta_predicted]);
        end
        
        function ExponentialFitPlot(THETA,gui)
            if nargin <2
                gui=0;
            end
            if ~gui
                figure()
            end
            plot(THETA.NonLinear.Statistics.model,...
                THETA.NonLinear.IncludedData(:,1),...
                THETA.NonLinear.IncludedData(:,2))
            xticks=get(gca,'XTick');
            if THETA.Curve.X(1)>100
                NewTicks=round(1./xticks);
            else
                NewTicks=round(1./xticks-273.15);
            end
            set(gca,'XTickLabel',NewTicks)
            %xlabel('1 / Temperature [1 / K]')
            if THETA.Curve.X(1)>100
                xlabel('Temperature[K]')
            else
                xlabel('Temperature [\circC]')
            end
            title('Exponential Fit Plot')    
            %xlabel('1/Temperature [1/K]')
            ylabel('Keq')
            h=legend([THETA.Name,' (data)'],[THETA.Name,' (fitted)'],'Location','SouthOutside');
            set(h,'Interpreter','none')
            %set(h,'FontUnits','Normalized')
        end
    
        function NonlinearAnalysisPlot(THETA,gui)
            if nargin <2
                gui=0;
            end
            if ~gui
                figure()
            end
            if isempty(THETA.thetaS)
                plot(THETA.Curve.X,THETA.theta,'b.')
                hold on
                plot(THETA.Curve.X,THETA.NonLinear.Statistics.Y_hat,'k')
                h=legend([THETA.Name,' (data)'],[THETA.Name,' (predicted)'],'Location','SouthOutside');
            else
                plot(THETA.Curve.X,THETA.thetaS,'r')
                hold on
                plot(THETA.Curve.X,THETA.NonLinear.Statistics.Y_hat,'k')
                h=legend([THETA.Name,' (smoothed)'],[THETA.Name,' (predicted)'],'Location','SouthOutside');
            end
            title('Predicted \theta(T) by Exponential')
            ylim([-.5,1.5])
            if THETA.Curve.X(1)>100
                xlabel('Temperature[K]')
            else
                xlabel('Temperature [\circC]')
            end
            ylabel('Normalized Absorbance')
            set(h,'Interpreter','none')
            %set(h,'FontUnits','Normalized')
            hold off
        end

        function PlotResiduals(THETA,nonlinear,gui)
            if nargin<3
                gui=0;
            end
            if nargin<2
                nonlinear=0;
            end
            if ~gui
                figure()
            end
            if nonlinear
                plot(THETA.Curve.X,real(THETA.NonLinear.Statistics.Residuals),'md')
                title('Nonlinear Residual Plot')
                ylabel('Y_{predicted} -Y_{observed} [Keq]' )
            else
                plot(THETA.Curve.X,real(THETA.VantHoff.Statistics.Residuals),'md')
                title('VantHoff Residual Plot')
                ylabel('Y_{predicted} -Y_{observed} [Keq]' )
            end

            if THETA.Curve.X(1)>100
                xlabel('Temperature[K]')
            else
                xlabel('Temperature [\circC]')
            end
            h=legend([THETA.Name,' Residuals'],'Location','SouthOutside');
            set(h,'Interpreter','none')
            %set(h,'FontUnits','Normalized')
        end 
        
        function ComputeTM(THETA)
            theta=THETA.theta;
            THETA.Tm=CalculateTm([THETA.Curve.X,theta]);            
            if ~isempty(THETA.Curve.YS)
                thetaS=THETA.thetaS;
                THETA.TmS=CalculateTm([THETA.Curve.X,thetaS]);
            end
        end
    end
end

function Tm=CalculateTm(data)
try
    higher=find(data(:,2)>=0.5);
    lower =find(data(:,2)<=0.5);
    if data(1,1)-data(end,1) < 0
    	Tm=mean([data(lower(end),1) data(higher(1),1)]);
    else 
        Tm=mean([data(lower(1),1) data(higher(end),1)]);
    end
catch
    disp('Range does not include the Tm')
    Tm=NaN;
end

end
