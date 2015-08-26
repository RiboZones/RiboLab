function OnionMap(Onion_obj,Map_obj,varargin)

Rs=[Onion_obj.Model.Layers{:}];
Rs=vertcat(Rs.ItemNames);


for i=1:length(Rs)
    Rs{i}=Rs{i}(3:end);
end
residues_shell=strtrim(Rs);
shells=vertcat(Onion_obj.Model.Shells{:});


Map_obj.PlotCoord('filename',[Onion_obj.Name,'_onion.eps'],'IncludeItems',...
    residues_shell,'ColorMode','gradient','VarInterest',shells',...
    'EnableColorBar',false,varargin{:})

end