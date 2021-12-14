function [points, label_p_all] = reconstructCrossMulti(op_list, dp_list, oc_list, dc_list, label)

nScan = size(op_list, 1);

points.location = NaN(nScan, 3);
points.err_triangulation = NaN(nScan, 1);
points.nObservation = NaN(nScan, 1);

for iScan = 1:nScan
    if mod(iScan, 100000) == 0
        fprintf('%d/%d \n', iScan, nScan);
    end

    if isnan(dp_list(iScan, 1))
        continue;
    end

    op = op_list(iScan, :);
    dp = dp_list(iScan, :);

    oc_multi = oc_list(iScan, :, :);
    dc_multi = dc_list(iScan, :, :);

    is_observed = squeeze(~isnan(oc_multi(1,1,:)));

    if any(is_observed)
        oc_multi = oc_multi(:, :, is_observed);
        dc_multi = dc_multi(:, :, is_observed);

        [X, err_triangulation] = computeNearestPointFromRays(op, dp, oc_multi, dc_multi);
        points.location(iScan, :) = X;

        nRay = sum(is_observed) + 1;
        points.err_triangulation(iScan) = err_triangulation/nRay;
        points.nObservation(iScan) = sum(is_observed);
    end
end

label_p_all = label.p_list;

end