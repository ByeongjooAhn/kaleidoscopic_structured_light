function [label, data]  = checkRepeatedLabel(label, data)

nScan = size(label.p_list, 1);
    
for iScan = 1:nScan
    
    % skip if it is already invalid
    if isnan(label.p_list(iScan))
        continue;
    end
    
    % remove repeated label
    label_c_temp = label.c_list(iScan, :);
    repeatedValues = findRepeatedValues(label_c_temp);
    for iRepeat = 1:length(repeatedValues)
        idx_repeated = (label_c_temp == repeatedValues(iRepeat));
        label_c_temp(idx_repeated) = NaN;
        data.xc_list(iScan, :, idx_repeated) = NaN;
    end
    
    % update c
    label.c_list(iScan, :) = label_c_temp;
    
    % update p
    if sum(~isnan(data.xc_list(iScan, :, :)), 'all')==0
        data.xp_list(iScan, :) = NaN;
        label.p_list(iScan) = NaN;
    end
    
    
end


end

function v = findRepeatedValues(a)
[~, uniqueIdx] = unique(a);
diffLocation = setdiff( 1:numel(a), uniqueIdx );
v = a( diffLocation );
v = unique(v);

end