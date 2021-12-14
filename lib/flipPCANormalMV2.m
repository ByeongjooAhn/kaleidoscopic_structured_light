function normal = flipPCANormalMV2(normal_in, dp_list, dc_list)

nScan = size(normal_in, 1);
normal = normal_in;

for iScan = 1:nScan
    if ~isnan(normal_in(iScan,1))
        normal_iPoint = normal_in(iScan, :);
        n_candidate = [normal_iPoint; -normal_iPoint];

        dp = dp_list(iScan, :);
        dc = dc_list(iScan, :, :);
        dc = permute(dc, [3 2 1]);

        d_list = [-dp; -dc];
        d_list = d_list(~isnan(d_list(:,1)), :);

        sum_theta = zeros(2, 1);
        for i = 1:2
            sum_theta(i) = mean(acosd(sum(n_candidate(i, :).*d_list, 2)));
        end
        
        
        [~, idx_min] = min(sum_theta); % 1 for nothinng, 2 for flip
        normal(iScan, :) = n_candidate(idx_min, :);
        
        % incorrect normal reconstruction makes invisible points
        if any(acosd(sum(n_candidate(idx_min, :).*d_list, 2))>90)
            normal(iScan, :) = NaN;
        end
    end
end




end
