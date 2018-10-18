%% OligioMelt
%       This program calculates thermodynamic data from oligio melting
% curves. obviously, more will be written here once the program is under
% active development. I am waiting for CLH. 
%%
function [Results DataOut]=OligoMelt(file,DataSetIndex,Windows,...
    AnalysisRange,varargin)

%% Input Processing block
% Input processing

%%
%  1. Step one
try
    TxtDataSet=importdata(file);
    if(isstruct(TxtDataSet.textdata))
        txt_data = TxtDataSet.data.Sheet1;
        text_data = TxtDataSet.textdata.Sheet1;
    else
        txt_data = TxtDataSet.data;
        text_data = TxtDataSet.textdata;
    end
    IntrumentNameCheck=text_data{1};
    comma=findstr(IntrumentNameCheck,',');
    if ~isempty(comma)
        DataSetName=IntrumentNameCheck;
        DataSetNames=cell(1,ceil(length(comma)/2));
        DataSetNames{1}=DataSetName(1:comma(1)-1);
        for i=2:ceil(length(comma)/2)
            DataSetNames{i}=DataSetName(comma(2*(i-1))+1:comma(2*i-1)-1);
        end
        if nargin==1
            Results=DataSetNames;
            return
        end
        trimends=isnan(txt_data(end,2:2:end));
        if sum(trimends)
            txt_data(end,:)=[];
        end
        Data=reshape(txt_data,[],2,length(DataSetNames));
    else
        if isempty(text_data{1})
            DataSetNames={text_data{2:2:end}};
        else
            DataSetNames={text_data{1:2:end}};
        end
        if nargin==1
            Results=DataSetNames;
            return
        end
        numdata=txt_data;
        ColsStartBlank=find(isnan(numdata(1,:)));
        lengthOfColumns=size(numdata,1);
        numCols=size(numdata,2);
        AllBlankCols=ColsStartBlank(sum(isnan(numdata(:,ColsStartBlank)))==lengthOfColumns);
        NoBlankColumns=numdata(:,setdiff(1:numCols,AllBlankCols));
        
        RowsStartBlank=find(isnan(NoBlankColumns(:,1)));
        numCols=size(NoBlankColumns,2);
        AllBlankRows=RowsStartBlank(sum(isnan(NoBlankColumns(RowsStartBlank,:)),2)==numCols);
        NoBlankColumns=NoBlankColumns(setdiff(1:lengthOfColumns,AllBlankRows),:);
        %     end
        if sum(max(NoBlankColumns)>=42)==1
            T=NoBlankColumns(:,max(NoBlankColumns)>=42);
            A=NoBlankColumns(:,max(NoBlankColumns)<42);
            dataA=zeros([length(A) 2*size(A,2)]);
            for i=1:2:2*size(A,2)
                dataA(:,i)=T;
                dataA(:,i+1)=A(:,(i+1)/2);
            end
        else
            dataA=NoBlankColumns;
        end
        Data=reshape(dataA,[],2,length(DataSetNames));
        
    end
catch
%     try
%         warning off
%         [numdata textdata]=xlsread(file);
%         warning on
%         DataSetNames=cellstr(strvcat(textdata));
%         
%         if nargin==1
%             Results=DataSetNames;
%             return
%         end
%         %     if ispc
%         %         NoBlankColumns=numdata(:,~isnan(numdata(1,:)));
%         %     else
%         ColsStartBlank=find(isnan(numdata(1,:)));
%         lengthOfColumns=size(numdata,1);
%         numCols=size(numdata,2);
%         AllBlankCols=ColsStartBlank(sum(isnan(numdata(:,ColsStartBlank)))==lengthOfColumns);
%         NoBlankColumns=numdata(:,setdiff(1:numCols,AllBlankCols));
%         
%         RowsStartBlank=find(isnan(NoBlankColumns(:,1)));
%         numCols=size(NoBlankColumns,2);
%         AllBlankRows=RowsStartBlank(sum(isnan(NoBlankColumns(RowsStartBlank,:)),2)==numCols);
%         NoBlankColumns=NoBlankColumns(setdiff(1:lengthOfColumns,AllBlankRows),:);
%         %     end
%         if sum(max(NoBlankColumns)>=42)==1
%             T=NoBlankColumns(:,max(NoBlankColumns)>=42);
%             A=NoBlankColumns(:,max(NoBlankColumns)<42);
%             dataA=zeros([length(A) 2*size(A,2)]);
%             for i=1:2:2*size(A,2)
%                 dataA(:,i)=T;
%                 dataA(:,i+1)=A(:,(i+1)/2);
%             end
%         else
%             dataA=NoBlankColumns;
%         end
%         Data=reshape(dataA,[],2,length(DataSetNames));
%     catch
%         disp('bad input')
%         return
%     end
end
Smoothing=true;
ExportFigures=true;
if nargin > 4
    for i = 1 : 2 : length(varargin)
        name = varargin{i};
        value = varargin{i+1};
        switch name
            case 'Smoothing'
                Smoothing=value;
            case 'ExportFigures'
                ExportFigures=value;
            case 'Concentration'
                Concentration=value;
            case 'AutoRange'
                auto_range=value;
            case 'Method'
                Method=value;
            otherwise
        end
    end
end
if ~exist('Method','var')
    Method='monomolecular';
end
%%
%  2. Step two
data=Data(~isnan(Data(:,1,DataSetIndex)),:,DataSetIndex);
FullRange=[min(data(:,1)) max(data(:,1))];
if nargin == 2
    Results=FullRange;
    if nargout < 2
        return
    end
end
if nargin < 4
    AnalysisRange=FullRange;
end
%%
%  3. Step three
name=DataSetNames{DataSetIndex};

%% Main block
% Main block

%%
%  1. Step one

if nargin==2
    try
        DataOut=Curve(name,data);
    catch ImproperFieldName
    end
    return
end
Output=OligoOutput(file,name,DataSetIndex,AnalysisRange,Windows);
Output.CreateCurve(data);
Output.curve.WindowLimits(Windows);
Output.curve.LinearRegression();
if Smoothing
    Output.curve.LinearRegressionS();
end
Output.CreateTheta();
Output.theta.CalculateTheta();
Output.theta.ComputeTM();

if exist('auto_range','var') && auto_range
    autorange=Output.theta.AutoRange();
    if abs(autorange(2)- autorange(1))>=15
        Output.NewRange(autorange);
        AnalysisRange=autorange;
    end
end

%%
%  2. Step two
switch Method
    case 'monomolecular'
        Output.theta.ComputeVantHoff(AnalysisRange);
        Output.theta.ComputeNonLinearModel(AnalysisRange);
    case {'bimolecular2A','bimolecularAB'}
        Output.theta.ComputeVantHoff(AnalysisRange,Method,Concentration);
        Output.theta.ComputeNonLinearModel(AnalysisRange,Method,Concentration);
    otherwise
end
%%
%  3. Step three
if ExportFigures
    Output.theta.Plot();
    Output.theta.VantHoffPlot();
    Output.theta.NonlinearAnalysisPlot();
end
%% Output processing block
% Output processing
Results=Output;
