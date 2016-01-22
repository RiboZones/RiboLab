function cifdat = importcif(~, path)
% imports .cif file

fid = fopen(path);

% loop = false;
% loopvar = {};


idx = 1;
cifStr = {};

if fid < 0
    error('cif:importcif:FileNotFound','.cif file cannot be found!');
end
% read in all lines
while ~feof(fid)
    cifStr{idx} = fgetl(fid); %#ok<AGROW>
    idx = idx + 1;
end
% unite broken lines
bLine = cellfun(@(x)numel(x)>0 && x(1)==';',cifStr);
bLines=reshape(find(bLine),2,[])';

% first and last line of the series of broken lines

firstBL = bLines(:,1);
lastBL  = bLines(:,2);

numLines=numel(cifStr) - sum(lastBL-firstBL);
cifStr2 = cell(1,numLines);
idx = 1;
openBL=false;
needsClose=false;
% numVars=0;
var_idx=0;

for ii = 1:numel(cifStr)
    if any(ii==firstBL)
        openBL=true;
        if length(cifStr{ii}) == 1
        	cifStr2{idx}=cifStr{ii}(2:end);
        else
            cifStr2{idx}=strcat('"', cifStr{ii}(2:end));
            needsClose=true;
        end
    elseif any(ii==lastBL)
        openBL=false;
        if needsClose
            cifStr2{idx}=strcat(cifStr2{idx},'"');
            needsClose=false;
        end
    else
        if openBL
            cifStr2{idx} = [cifStr2{idx},cifStr{ii}];
        else 
            cifStr2{idx} = cifStr{ii};
        end
    end
    if ~openBL
        idx = idx + 1;
    end
    
    %     if ~BL
    %         cifStr2{end+1} = cifStr{ii};
    %     else
    %         % end comment sign
    %         cifStr2{end} = [cifStr2{end} ' ±'  cifStr{ii}(2:end)];
    %     end
    %
    %     if any(ii==lastBL)
    %         BL = false;
    %     end
end

cifStr = cifStr2;

strout = cell(1,numel(cifStr));
for ii = 1:numel(cifStr)
    strout{ii} = parseline(cifStr{ii});
end

for ii = 1:numel(strout)
    % remove comments
    comIdx = strcmp('comment',strout{ii}(1,:));
    strout{ii} = strout{ii}(:,~comIdx);
    % count variables
%     if ~isempty(strout{ii}) && strcmp(strout{ii}{1},'variable')
%         numVars = numVars + 1;
%     end
end

% % remove empty lines
% emptyIdx = cellfun(@(x)isempty(x),strout);
% strout(emptyIdx) = [];

%Don't remove empty lines. Just skip them instead. This will let us guess 
% size of LpVar to allow for preallocation. This works as long as there is 
% a # at the end of each loop. 
emptyIdx = cellfun(@(x)isempty(x),strout);
E=find(emptyIdx);

II=find(~emptyIdx);

LP = false;
addedVar=false;
lpVar = cell(0,0);
lpVal = cell(0,0);

cifdat.name = '';
cifdat.val  = '';

savedata = false;

lp_val_line=0;

for ii = II
    strLine = strout{ii};
    switch strLine{1,1}
        case 'loop'
            if LP
                % save data
                savedata = true;
            else
                LP = true;
            end
        case 'variable'
            if (~isempty(lpVal)) || (size(strLine,2)>1)
                LP = false;
                % save data
                savedata = true;
            end
            
            if LP
                var_idx = var_idx + 1;
                lpVar = [lpVar,strLine(2,1)];
                addedVar=true;
            elseif (size(strLine,2)> 1) && ismember(strLine(1,2),{'number' 'string'})
                cifdat(end+1).name = strLine{2,1};
                cifdat(end).val    = strLine{2,2};
                cifdat(end).type   = strLine{1,2};
            else
                cifdat(end+1).name = strLine{2,1};
                cifdat(end).val    = '';
                %warning('Wrong stuff comes after a variable in line: %d, %s',ii,strLine{2,1});
            end
            
        case 'number'
            if LP
                
                if isempty(lpVal)
                    lp_val_line = lp_val_line + 1;
                    lpVal = cell(E(find(E>ii, 1 ))-ii,numel(lpVar));
                    lpVal(lp_val_line,:)  = [strLine(2,:) cell(1,numel(lpVar)-numel(strLine(2,:)))];
                    lpType = [strLine(1,:) cell(1,numel(lpVar)-numel(strLine(2,:)))];
                else
                    filled = ~cellfun(@(x)isempty(x),lpVal(lp_val_line,:));
                    if all(filled)
                        lp_val_line = lp_val_line + 1;
                        lpVal(lp_val_line,:) = [strLine(2,:) cell(1,numel(lpVar)-numel(strLine(2,:)))];
                    else
                        emptyIdx = find(~filled);
                        lpVal(lp_val_line,emptyIdx(1:numel(strLine(2,:)))) = strLine(2,:);
                    end
                end
            end
        case 'string'
            if LP
                
                if isempty(lpVal)
                    lp_val_line = lp_val_line + 1;
                    lpVal = cell(E(find(E>ii, 1 ))-ii,numel(lpVar));
                    lpVal(lp_val_line,:)  = [strLine(2,:) cell(1,numel(lpVar)-numel(strLine(2,:)))];
                    lpType = [strLine(1,:) cell(1,numel(lpVar)-numel(strLine(2,:)))];
                else
                    filled = ~cellfun(@(x)isempty(x),lpVal(lp_val_line,:));
                    if all(filled)
                         lp_val_line = lp_val_line + 1;
                        lpVal(lp_val_line,:) = [strLine(2,:) cell(1,numel(lpVar)-numel(strLine(2,:)))];
                    else
                        emptyIdx = find(~filled);
                        lpVal(lp_val_line,emptyIdx(1:numel(strLine(2,:)))) = strLine(2,:);
                        
                    end
                end
            end
            
        otherwise
            if ~isempty(lpVal)
                % save data
                savedata = true;
            end
            LP = false;
    end
    if savedata || (ii == numel(strout))
         if addedVar
             for jj=1:length(lpVar)
                cifdat(end+1).name = lpVar{jj};
                cifdat(end).type   = lpType{jj};
                cifdat(end).val    = lpVal(:,jj);
             end
         end
        
%         for jj = 1:numel(lpVar)
%             cifdat(end+1).name = lpVar{jj};
%             if jj > size(lpVal,2)
%                 cifdat(end).type   = 'string';
%                 cifdat(end).val    = '';
%             else
%                 cifdat(end).type   = lpType{1,jj};
%                 cifdat(end).val    = lpVal(:,jj);
%                 if strcmp(lpType{1,jj},'number')
%                     cifdat(end).val = [cifdat(end).val{:}]';
%                 end
%             end
%         end
          lpVar = cell(0,0);
          lpVal = cell(0,0);
          lp_val_line=0;

        
        savedata= false;
    end
end

fclose(fid);
cifdat = cifdat(2:end);

end



function strout = parseline(strin)
% parse cif file line
strout = cell(2,0);

while ~isempty(strin)
    % remove whitespace
    strin = strtrim(strin);
    
    if isempty(strin)
        return;
    end
    
    % COMMENT
    if strin(1) == '#'
        endcomIdx    = find(strin(1:end)=='±',1,'first');
        if isempty(endcomIdx)
            endcomIdx = numel(strin)+1;
        end
        
        strout{1,end+1} = 'comment';
        strout{2,end}   = strin(2:(endcomIdx-1));
        strin = strin(endcomIdx:end);
        continue;
    end
    
    % VARIABLE
    if strin(1) == '_'
        whiteIdx    = find(strin(1:end)==' ',1,'first');
        if isempty(whiteIdx)
            whiteIdx = numel(strin)+1;
        end
        strout{1,end+1} = 'variable';
        strout{2,end} = strin(2:(whiteIdx-1));
        strin = strin((whiteIdx+1):end);
        continue;
    end
    
    % LOOP
    if (numel(strin) >4) && strcmpi(strin(1:5),'loop_')
        strout{1,end+1} = 'loop';
        strout{2,end} = [];
        return;
    end
    
    % STRING
    if strin(1) == ''''
        strIdx = find(strin(2:end)=='''',1,'first')+1;
        if isempty(strIdx)
            error('importcif:WrongCif','String is not closed!');
        end
        
        strout{1,end+1} = 'string';
        strout{2,end} = strin(2:(strIdx-1));
        strin = strin((strIdx+1):end);
        continue;
    end
    
    % STRING
    if strin(1) == '"'
        strIdx = find(strin(2:end)=='"',1,'first')+1;
        if isempty(strIdx)
            error('importcif:WrongCif','String is not closed!');
        end
        
        strout{1,end+1} = 'string';
        strout{2,end} = strin(2:(strIdx-1));
        strin = strin((strIdx+1):end);
        continue;
    end
    
    % NUMBER
    %    if ismember(strin(1), [mat2cell('0':'9',1,ones(1,10)) {'-' '.'}])
    if ~isnan(str2doubleq(strin))

        bracket1Idx = find(strin(1:end)=='(',1,'first');
        bracket2Idx = find(strin(1:end)==')',1,'first');
        whiteIdx    = find(strin(1:end)==' ',1,'first');
        if isempty(bracket1Idx)
            bracket1Idx = numel(strin)+1;
        end
        if isempty(bracket2Idx)
            bracket2Idx = numel(strin)+1;
        end
        if isempty(whiteIdx)
            whiteIdx = numel(strin)+1;
        end
        
        if whiteIdx <= bracket1Idx
            strout{1,end+1} = 'number';
            numOut = str2doubleq(strin(1:(whiteIdx-1)));
            if ~isempty(numOut)
                strout{2,end} = numOut;
            else
                strout{2,end} = 0;
            end
            strin = strin((whiteIdx+1):end);
            continue;
        else
            strout{1,end+1} = 'number';
            numOut = str2doubleq(strin(1:(bracket1Idx-1)));
            if ~isempty(numOut)
                strout{2,end} = numOut;
            else
                strout{2,end} = 0;
            end
            strin = strin((bracket2Idx+1):end);
            continue;
            
        end
    end
    
%     % EMPTY NUMBER
%     if strin(1) == '?'
%         whiteIdx    = find(strin(1:end)==' ',1,'first');
%         strout{1,end+1} = 'number';
%         strout{2,end} = NaN;
%         strin = strin((whiteIdx+1):end);
%         continue;
%     end
    % EMPTY String
    if strin(1) == '?'
        whiteIdx    = find(strin(1:end)==' ',1,'first');
        strout{1,end+1} = 'string';
        strout{2,end} = '?';
        strin = strin((whiteIdx+1):end);
        continue;
    end

    % END COMMENT WITHOUT BEGIN
    if strin(1) == '±'
        strin = strin(2:end);
        continue;
    end
    
    % STRING
    if (isstrprop(strin(1), 'alpha')) || true
        whiteIdx    = find(strin(1:end)==' ',1,'first');
        if isempty(whiteIdx)
            whiteIdx = numel(strin)+1;
        end
        
        strout{1,end+1} = 'string';
        strout{2,end} = strin(1:(whiteIdx-1));
        strin = strin((whiteIdx+1):end);
        continue;
    end
    
end

end
