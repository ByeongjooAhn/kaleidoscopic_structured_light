function [label, data, rejected] = checkInsideSystemAll(label_in, data_in, virtual)


fprintf('checkInsideSystemAll...\n');
label = label_in;
data = data_in;

nScan = size(data_in.xp_list, 1);
rejected = NaN(size(label_in.c_list_all));

nObservation_total = sum(~isnan(label_in.c_list(:)));

count = 0;
for iScan = 1:nScan
    nCandidate = sum(~isnan(label_in.p_list_all(iScan, :)));
    for iCandidate = 1:nCandidate
        % compute rays
        [op, dp] = pixel2ray(data_in.xp_list(iScan, :), label_in.p_list_all(iScan, iCandidate), virtual.mirror_id_p, virtual.Projs);
        [oc_multi, dc_multi] = pixel2ray(data_in.xc_list(iScan, :, :), label_in.c_list_all(iScan, :, iCandidate), virtual.mirror_id_c, virtual.Cams);

        if isnan(label_in.p_list_all(iScan, iCandidate))
            continue;
        end

        % each measurement in iScan
        is_observed = ~isnan(label_in.c_list_all(iScan, :, iCandidate));
        if any(is_observed)

            for i = 1:size(dc_multi, 3) 
                oc = oc_multi(1, :, i);
                dc = dc_multi(1, :, i);

                if isnan(dc(1))
                    continue;
                end

                count = count + 1;
                if mod(count, 100000) == 0
                    fprintf('%d/%d \n', count, nObservation_total);
                end

                if isnan(oc(1))
                    error('something is wrong');
                end

                % triangulation
                [X, err_triangulation] = computeNearestPointFromRays(op, dp, oc, dc);

                is_reject = ~is_inside_system_margin(X, virtual.systemParams, virtual.margin);
                rejected(iScan, i, iCandidate) = is_reject;

                if is_reject
                    label.c_list_all(iScan, i, iCandidate) = NaN;
    %                 fprintf('invalid label: iScan = %d, i = %d, nObservation = %d\n', iScan, i, sum(is_observed));    
                end
            end

        end
    end
        
    if nCandidate > 0
        % pick best one from candidates with same epipolar geometry
        nInside = squeeze(sum(~isnan(label.c_list_all(iScan, :, 1:nCandidate)), 2));
        [~, iCandidate_best] = max(nInside);
        label.p_list(iScan) = label.p_list_all(iScan, iCandidate_best);
        label.c_list(iScan, :) = label.c_list_all(iScan, :, iCandidate_best);
    end
    
    % discard invalid label (wrong detection)
    is_nan = squeeze(isnan(label.c_list(iScan, :)));
    data.xc_list(iScan, :, is_nan) = NaN;
    data.I_list(iScan, :, is_nan) = NaN;
    if sum(~isnan(data.xc_list(iScan, :, :)), 'all')==0
        data.xp_list(iScan, :) = NaN;
        label.p_list(iScan) = NaN;
    end
    
end

label = rmfield(label, 'p_list_all');
label = rmfield(label, 'c_list_all');

end
