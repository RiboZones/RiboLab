function [pw1,pw0]=cdmbe
%CDMBE - Changes current working directory to MBEToolbox directory

pw0=pwd;
pw1 = fileparts(which(mfilename));
cd(pw1);